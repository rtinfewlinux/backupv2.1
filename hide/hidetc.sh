#!/bin/bash

# 1. Lấy danh sách mã định danh của TẤT CẢ các tab đang bị ẩn
hidden_windows=$(hyprctl clients -j | jq -r '.[] | select(.workspace.name == "special:minimized") | .address')

# Nếu không có tab nào đang ẩn thì dừng lại
if [ -z "$hidden_windows" ] || [ "$hidden_windows" == "null" ]; then
    exit 0
fi

# 2. Lấy ID của màn hình hiện tại bạn đang đứng
current_workspace=$(hyprctl monitors -j | jq '.[] | select(.focused == true) | .activeWorkspace.id')

# 3. Dùng vòng lặp gọi TOÀN BỘ các tab ẩn ra lại cùng một lúc
echo "$hidden_windows" | while read -r win_address; do
    if [ -n "$win_address" ]; then
        hyprctl dispatch movetoworkspace "$current_workspace,address:$win_address"
    fi
done
