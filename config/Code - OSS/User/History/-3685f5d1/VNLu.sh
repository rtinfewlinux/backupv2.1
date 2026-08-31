#!/bin/bash

# 1. Lấy thông tin ứng dụng hiện tại và danh sách ứng dụng trong vùng ẩn
active_window=$(hyprctl activewindow -j | jq -r '.address')
hidden_windows=$(hyprctl clients -j | jq -r '[.[] | select(.workspace.name == "special:minimized")] | sort_by(.focusHistoryID) | reverse | .[].address')

# Làm sạch biến nếu trả về null
if [ "$active_window" = "null" ]; then active_window=""; fi

# 2. LOGIC ẨN: Nếu màn hình đang có ứng dụng VÀ ứng dụng này KHÔNG nằm trong danh sách ẩn
# (Tức là một ứng dụng bình thường bạn chưa từng ẩn) -> Tiến hành ẩn nó vào kho
if [ -n "$active_window" ] && ! echo "$hidden_windows" | grep -q "$active_window"; then
    hyprctl dispatch movetoworkspacesilent special:minimized
    exit 0
fi

# 3. LOGIC HIỆN: Nếu màn hình trống HOẶC ứng dụng đang chọn chính là cái vừa được lôi ra
# Tiến hành lôi tiếp ứng dụng cũ nhất trong kho ẩn ra màn hình chính
if [ -n "$hidden_windows" ]; then
    first_hidden_window=$(echo "$hidden_windows" | head -n 1)
    hyprctl dispatch movetoworkspace "+0,address:$first_hidden_window"
    exit 0
fi

# 4. TRƯỜNG HỢP CUỐI: Nếu kho ẩn đã trống hoàn toàn, cho phép ẩn lại từ đầu
if [ -n "$active_window" ]; then
    hyprctl dispatch movetoworkspacesilent special:minimized
fi
