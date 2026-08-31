#!/bin/bash

# 1. Lấy ID của workspace hiện tại bạn đang đứng
current_ws=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .activeWorkspace.id')

# 2. Lấy thông tin chi tiết của cửa sổ đang active (đang chọn)
active_info=$(hyprctl activewindow -j)
active_address=$(echo "$active_info" | jq -r '.address')
active_ws_id=$(echo "$active_info" | jq -r '.workspace.id')

# Làm sạch biến nếu màn hình trống trơn
if [ "$active_address" = "null" ]; then active_address=""; fi

# 3. LOGIC ẨN (ƯU TIÊN): Nếu màn hình đang chọn có ứng dụng VÀ ứng dụng đó đang nằm ở workspace chính
# Điều này đảm bảo cứ có app trên màn hình là bấm nút sẽ ẨN ĐƯỢC NGAY liên tục, không bị kẹt
if [ -n "$active_address" ] && [ "$active_ws_id" = "$current_ws" ]; then
    hyprctl dispatch movetoworkspacesilent special:minimized
    exit 0
fi

# 4. LOGIC HIỆN: Nếu màn hình trống trơn (không có ứng dụng nào hiển thị tại workspace này)
# Tiến hành lôi lần lượt từng ứng dụng ẩn ra (Cũ nhất ra trước)
hidden_windows=$(hyprctl clients -j | jq -r '[.[] | select(.workspace.name == "special:minimized")] | sort_by(.focusHistoryID) | reverse | .[].address')
first_hidden_window=$(echo "$hidden_windows" | head -n 1)

if [ "$first_hidden_window" != "null" ] && [ -n "$first_hidden_window" ]; then
    hyprctl dispatch movetoworkspace "+0,address:$first_hidden_window"
    exit 0
fi