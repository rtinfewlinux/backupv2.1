#!/bin/bash

# ==========================================
# PHẦN 1: LOGIC ẨN CHUẨN CỦA SCRIPT 1
# ==========================================
active_window=$(hyprctl activewindow -j | jq -r '.address')

if [ "$active_window" = "null" ] || [ -z "$active_window" ]; then
    active_window=""
fi

if [ -n "$active_window" ]; then
    hyprctl dispatch movetoworkspacesilent special:minimized
    exit 0
fi

# ==========================================
# PHẦN 2: LOGIC HIỆN CHUẨN CỦA SCRIPT 2
# ==========================================
hidden_windows=$(hyprctl clients -j | jq -r '[.[] | select(.workspace.name == "special:minimized")] | sort_by(.focusHistoryID) | reverse | .[].address')
first_hidden_window=$(echo "$hidden_windows" | head -n 1)
current_workspace=$(hyprctl monitors -j | jq '.[] | select(.focused == true) | .activeWorkspace.id')

if [ "$first_hidden_window" != "null" ] && [ -n "$first_hidden_window" ]; then
    # 1. Lôi ứng dụng ra màn hình chính
    hyprctl dispatch movetoworkspace "$current_workspace,address:$first_hidden_window"
    
    # 2. LỆNH SỬA LỖI: Ép Hyprland tắt hẳn trạng thái mở ngầm của vùng ẩn special:minimized
    # Điều này giúp ứng dụng cũ không bị tự động thu hồi khi lôi ứng dụng mới ra
    hyprctl dispatch togglespecialworkspace minimized
    hyprctl dispatch togglespecialworkspace minimized
fi
