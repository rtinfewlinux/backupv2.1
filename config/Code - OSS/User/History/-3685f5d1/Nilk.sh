#!/bin/bash

# ==========================================
# 1. KIỂM TRA MÀN HÌNH CÓ ỨNG DỤNG KHÔNG
# ==========================================
# Lấy ID của workspace (màn hình) hiện tại bạn đang đứng
current_workspace=$(hyprctl monitors -j | jq '.[] | select(.focused == true) | .activeWorkspace.id')

# Đếm xem màn hình hiện tại đang hiển thị bao nhiêu cửa sổ
window_count=$(hyprctl clients -j | jq "[.[] | select(.workspace.id == $current_workspace)] | length")

# ==========================================
# 2. LOGIC ẨN ĐÚNG CỦA BẠN (Ẩn liên tục)
# ==========================================
# Nếu màn hình đang có ứng dụng (window_count lớn hơn 0) -> Chạy lệnh ẨN ĐÚNG của bạn
if [ "$window_count" -gt 0 ]; then
    hyprctl dispatch movetoworkspacesilent special:minimized
    exit 0
fi

# ==========================================
# 3. LOGIC HIỆN ĐÚNG CỦA BẠN (Hiện lần lượt không mất cái cũ)
# Chỉ kích hoạt khi màn hình đã trống trơn (window_count = 0)
# ==========================================
# Lấy danh sách ứng dụng ẩn, sắp xếp theo lịch sử focus và ĐẢO NGƯỢC LẠI (Cũ nhất lên đầu)
hidden_windows=$(hyprctl clients -j | jq -r '[.[] | select(.workspace.name == "special:minimized")] | sort_by(.focusHistoryID) | reverse | .[].address')

# Nếu thực sự đang có tab bị ẩn -> Lúc này ứng dụng cũ nhất đã nằm ở DÒNG ĐẦU TIÊN nhờ lệnh reverse
if [ -n "$hidden_windows" ]; then
    first_hidden_window=$(echo "$hidden_windows" | head -n 1)

    # Ép cửa sổ đó xuất hiện trở lại đúng màn hình hiện tại của bạn
    hyprctl dispatch movetoworkspace "$current_workspace,address:$first_hidden_window"
fi
