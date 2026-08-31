#!/bin/bash

# 1. Lấy danh sách ứng dụng ẩn, sắp xếp theo lịch sử focus và ĐẢO NGƯỢC LẠI (Cũ nhất lên đầu)
hidden_windows=$(hyprctl clients -j | jq -r '[.[] | select(.workspace.name == "special:minimized")] | sort_by(.focusHistoryID) | reverse | .[].address')

# Lấy địa chỉ ứng dụng đang mở/chọn trên màn hình (active)
active_window=$(hyprctl activewindow -j | jq -r '.address')
if [ "$active_window" = "null" ]; then active_window=""; fi

# ==========================================
# SỬA LOGIC ẨN: Chỉ ẩn khi kho trống HOẶC khi ứng dụng hiện tại KHÔNG nằm trong kho ẩn
# ==========================================
if [ -z "$hidden_windows" ] || { [ -n "$active_window" ] && ! echo "$hidden_windows" | grep -q "$active_window"; }; then
    hyprctl dispatch movetoworkspacesilent special:minimized
    exit 0
fi

# ==========================================
# LOGIC HIỆN CHUẨN 100% CỦA BẠN
# ==========================================
# Lúc này ứng dụng cũ nhất đã nằm ở DÒNG ĐẦU TIÊN nhờ lệnh reverse
first_hidden_window=$(echo "$hidden_windows" | head -n 1)

# Lấy ID của màn hình hiện tại bạn đang đứng
current_workspace=$(hyprctl monitors -j | jq '.[] | select(.focused == true) | .activeWorkspace.id')

# Ép cửa sổ đó xuất hiện trở lại đúng màn hình hiện tại của bạn
hyprctl dispatch movetoworkspace "$current_workspace,address:$first_hidden_window"
