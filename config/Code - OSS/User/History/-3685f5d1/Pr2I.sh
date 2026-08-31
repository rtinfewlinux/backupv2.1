#!/bin/bash

# ==========================================
# 1. LẤY THÔNG TIN CỬA SỔ VÀ KHO ẨN
# ==========================================
# Lấy danh sách ứng dụng ẩn, sắp xếp theo lịch sử focus và ĐẢO NGƯỢC LẠI (Cũ nhất lên đầu)
hidden_windows=$(hyprctl clients -j | jq -r '[.[] | select(.workspace.name == "special:minimized")] | sort_by(.focusHistoryID) | reverse | .[].address')

# Lấy địa chỉ của ứng dụng đang mở/chọn trên màn hình (active window)
active_window=$(hyprctl activewindow -j | jq -r '.address')
if [ "$active_window" = "null" ]; then active_window=""; fi

# ==========================================
# 2. LOGIC ẨN ĐÚNG CỦA BẠN (SỬA ĐIỀU KIỆN)
# ==========================================
# CHỈ ẨN KHI: Màn hình đang có ứng dụng VÀ ứng dụng đó KHÔNG nằm trong kho ẩn (ứng dụng mới)
if [ -n "$active_window" ] && ! echo "$hidden_windows" | grep -q "$active_window"; then
    hyprctl dispatch movetoworkspacesilent special:minimized
    exit 0
fi

# ==========================================
# 3. LOGIC HIỆN ĐÚNG CỦA BẠN (Hiện lần lượt không mất cái cũ)
# ==========================================
# Nếu đang có tab bị ẩn -> Lúc này ứng dụng cũ nhất đã nằm ở DÒNG ĐẦU TIÊN nhờ lệnh reverse
if [ -n "$hidden_windows" ]; then
    first_hidden_window=$(echo "$hidden_windows" | head -n 1)

    # Lấy ID của màn hình hiện tại bạn đang đứng
    current_workspace=$(hyprctl monitors -j | jq '.[] | select(.focused == true) | .activeWorkspace.id')

    # Ép cửa sổ đó xuất hiện trở lại đúng màn hình hiện tại của bạn
    hyprctl dispatch movetoworkspace "$current_workspace,address:$first_hidden_window"
fi
