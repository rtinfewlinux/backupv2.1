#!/bin/bash

# 1. Kiểm tra xem màn hình hiện tại có ứng dụng nào đang mở và được chọn (active) không
active_window=$(hyprctl activewindow -j | jq -r '.address')

# 2. LÀM SẠCH BIẾN: Nếu kết quả trả về là chữ "null" hoặc trống, biến active_window sẽ thành rỗng
if [ "$active_window" = "null" ] || [ -z "$active_window" ]; then
    active_window=""
fi

# 3. NẾU MÀN HÌNH ĐANG CÓ ỨNG DỤNG -> Cứ bấm phím là ẨN ngay ứng dụng đó đi
if [ -n "$active_window" ]; then
    hyprctl dispatch movetoworkspacesilent special:minimized
    exit 0
fi

# 4. NẾU MÀN HÌNH TRỐNG -> Tiến hành LÔI LẦN LƯỢT từng ứng dụng bị ẩn ra (Cũ nhất ra trước)
# Sắp xếp theo focusHistoryID và đảo ngược (reverse) để đưa ứng dụng ẩn đầu tiên lên đầu dòng
hidden_windows=$(hyprctl clients -j | jq -r '[.[] | select(.workspace.name == "special:minimized")] | sort_by(.focusHistoryID) | reverse | .[].address')

# Lấy mã định danh của ứng dụng đứng đầu hàng đợi
first_hidden_window=$(echo "$hidden_windows" | head -n 1)

# Nếu thực sự có ứng dụng đang ẩn, mang nó về màn hình (workspace) hiện tại
if [ "$first_hidden_window" != "null" ] && [ -n "$first_hidden_window" ]; then
    hyprctl dispatch movetoworkspace "+0,address:$first_hidden_window"
fi
