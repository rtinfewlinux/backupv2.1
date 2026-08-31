#!/bin/bash

# 1. Lấy danh sách các cửa sổ đang nằm trong vùng ẩn special:minimized
hidden_windows=$(hyprctl clients -j | jq -r '.[] | select(.workspace.name == "special:minimized") | .address')

# 2. Nếu vùng ẩn TRỐNG (chưa ẩn tab nào) -> Tiến hành ẩn tab hiện tại đi
if [ -z "$hidden_windows" ]; then
    hyprctl dispatch 'hl.dsp.window.move({ workspace = "special:minimized", follow = false })'
    exit 0
fi

# 3. Nếu đang có tab bị ẩn:
# Lấy ID của workspace (màn hình) hiện tại bạn đang đứng
current_workspace=$(hyprctl monitors -j | jq '.[] | select(.focused == true) | .activeWorkspace.id')

# Lấy mã định danh (address) của cửa sổ ĐẦU TIÊN đang bị ẩn
first_hidden_window=$(echo "$hidden_windows" | head -n 1)

# Sử dụng lệnh gọi Lua thô từ CLI hyprctl
hyprctl dispatch "hl.dsp.window.move({ window = \"address:$first_hidden_window\", workspace = $current_workspace, follow = true })"
