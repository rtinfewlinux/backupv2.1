#!/bin/bash

# 1. Lấy mã định danh ứng dụng đang active và danh sách các ứng dụng trong kho ẩn
active_window=$(hyprctl activewindow -j | jq -r '.address')
hidden_windows=$(hyprctl clients -j | jq -r '[.[] | select(.workspace.name == "special:minimized")] | sort_by(.focusHistoryID) | reverse | .[].address')

# Làm sạch biến active_window nếu trả về "null" (màn hình trống)
if [ "$active_window" = "null" ]; then active_window=""; fi

# 2. LOGIC HIỆN: Nếu màn hình trống HOẶC ứng dụng đang chọn NẰM TRONG danh sách ẩn trước đó
# Hệ thống hiểu là bạn đang bấm liên tiếp để lôi tiếp các ứng dụng khác ra
if [ -z "$active_window" ] || echo "$hidden_windows" | grep -q "$active_window"; then
    
    # Lấy mã định danh của ứng dụng tiếp theo trong hàng đợi ẩn
    # Nếu đang chọn một ứng dụng vừa hiện, ta sẽ bốc ứng dụng KẾ TIẾP trong danh sách ẩn
    if [ -n "$active_window" ]; then
        next_hidden_window=$(echo "$hidden_windows" | grep -A 1 "$active_window" | tail -n 1)
        # Nếu ứng dụng hiện tại đã là cái cuối cùng trong kho ẩn, không làm gì cả
        if [ "$next_hidden_window" = "$active_window" ]; then next_hidden_window=""; fi
    else
        # Nếu màn hình trống, lấy ngay ứng dụng đầu hàng đợi (cũ nhất)
        next_hidden_window=$(echo "$hidden_windows" | head -n 1)
    fi

    # Thực hiện lôi ứng dụng ra nếu tìm thấy cái tiếp theo
    if [ -n "$next_hidden_window" ] && [ "$next_hidden_window" != "null" ]; then
        hyprctl dispatch movetoworkspace "+0,address:$next_hidden_window"
        exit 0
    fi
fi

# 3. LOGIC ẨN (Mặc định): Nếu ứng dụng đang chọn là ứng dụng bình thường (không nằm trong danh sách ẩn)
# Tiến hành ẩn liên tục bao nhiêu cái tùy thích
if [ -n "$active_window" ]; then
    hyprctl dispatch movetoworkspacesilent special:minimized
    exit 0
fi
