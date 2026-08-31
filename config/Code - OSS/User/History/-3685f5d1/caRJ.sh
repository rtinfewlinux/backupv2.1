#!/bin/bash

# 1. Lấy ID của workspace hiện tại bạn đang đứng
current_ws=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .activeWorkspace.id')

# 2. Đếm xem workspace hiện tại đang có bao nhiêu cửa sổ hiển thị
# (Sử dụng lệnh quét các client có workspace ID trùng với workspace hiện tại)
window_count=$(hyprctl clients -j | jq "[.[] | select(.workspace.id == $current_ws)] | length")

# 3. NẾU MÀN HÌNH ĐANG CÓ ỨNG DỤNG (window_count > 0) -> Ẩn ngay ứng dụng đang chọn
if [ "$window_count" -gt 0 ]; then
    hyprctl dispatch movetoworkspacesilent special:minimized
    exit 0
fi

# 4. NẾU MÀN HÌNH TRỐNG TRƠN (window_count = 0) -> Tiến hành lôi lần lượt từng ứng dụng ẩn ra
# Sắp xếp theo focusHistoryID và đảo ngược (reverse) để đưa ứng dụng cũ nhất lên đầu dòng
hidden_windows=$(hyprctl clients -j | jq -r '[.[] | select(.workspace.name == "special:minimized")] | sort_by(.focusHistoryID) | reverse | .[].address')

# Lấy mã định danh của ứng dụng đứng đầu hàng đợi
first_hidden_window=$(echo "$hidden_windows" | head -n 1)

# Nếu thực sự có ứng dụng đang ẩn, mang nó về màn hình hiện tại
if [ "$first_hidden_window" != "null" ] && [ -n "$first_hidden_window" ]; then
    hyprctl dispatch movetoworkspace "+0,address:$first_hidden_window"
fi
