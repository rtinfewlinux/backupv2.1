#!/bin/bash

# 1. Lấy danh sách ứng dụng ẩn, sắp xếp theo lịch sử focus và ĐẢO NGƯỢC LẠI (Cũ nhất lên đầu)
hidden_windows=$(hyprctl clients -j | jq -r '[.[] | select(.workspace.name == "special:minimized")] | sort_by(.focusHistoryID) | reverse | .[].address')

# Lấy ID của màn hình hiện tại bạn đang đứng
current_workspace=$(hyprctl monitors -j | jq '.[] | select(.focused == true) | .activeWorkspace.id')

# Đếm số lượng ứng dụng đang mở trên màn hình hiện tại này
current_windows=$(hyprctl clients -j | jq -r "[.[] | select(.workspace.id == $current_workspace)] | .address")

# 2. SỬA ĐÚNG CHỖ NÀY: Nếu màn hình hiện tại ĐANG CÓ ỨNG DỤNG (không trống) -> Tiến hành ẩn tab hiện tại đi
if [ -n "$current_windows" ]; then
    hyprctl dispatch movetoworkspacesilent special:minimized
    exit 0
fi

# 3. Nếu đang có tab bị ẩn -> Lúc này ứng dụng cũ nhất đã nằm ở DÒNG ĐẦU TIÊN nhờ lệnh reverse
first_hidden_window=$(echo "$hidden_windows" | head -n 1)

# Ép cửa sổ đó xuất hiện trở lại đúng màn hình hiện tại của bạn
hyprctl dispatch movetoworkspace "$current_workspace,address:$first_hidden_window"
