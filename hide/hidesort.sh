#!/bin/bash

# File tạm để lưu trạng thái (Đang Ẩn hay đang Hiện)
STATUS_FILE="/tmp/hypr_toggle_status"

# 1. GIỮ NGUYÊN: Lấy danh sách ứng dụng ẩn, sắp xếp theo lịch sử focus và ĐẢO NGƯỢC LẠI (Cũ nhất lên đầu)
hidden_windows=$(hyprctl clients -j | jq -r '[.[] | select(.workspace.name == "special:minimized")] | sort_by(.focusHistoryID) | reverse | .[].address')

# GIỮ NGUYÊN: Lấy ID của màn hình hiện tại bạn đang đứng
current_workspace=$(hyprctl monitors -j | jq '.[] | select(.focused == true) | .activeWorkspace.id')

# Kiểm tra xem màn hình có ứng dụng nào đang active không
active_window=$(hyprctl activewindow -j | jq -r '.address')
if [ "$active_window" = "null" ] || [ -z "$active_window" ]; then
    active_window=""
    # Nếu màn hình trống trơn, bắt buộc phải chuyển sang chế độ HIỆN
    echo "show" > "$STATUS_FILE"
fi

# Đọc trạng thái công tắc hiện tại (Mặc định ban đầu là ẩn - hide)
CURRENT_MODE=$(cat "$STATUS_FILE" 2>/dev/null || echo "hide")

# ==========================================
# 2. SỬA ĐIỀU KIỆN ẨN: Cứ có ứng dụng và đang ở chế độ hide là ẨN LIÊN TỤC
# ==========================================
if [ -n "$active_window" ] && [ "$CURRENT_MODE" != "show" ]; then
    # SỬA TẠI ĐÂY: Chuyển sang hyprctl eval với API Lua của Hyprland mới
    hyprctl eval 'hl.dispatch(hl.dsp.window.move({ workspace = "special:minimized", follow = false }))'
    exit 0
fi

# ==========================================
# 3. GIỮ NGUYÊN HOÀN TOÀN LOGIC HIỆN ĐÚNG CỦA BẠN
# ==========================================
if [ -n "$hidden_windows" ]; then
    # Lúc này ứng dụng cũ nhất đã nằm ở DÒNG ĐẦU TIÊN nhờ lệnh reverse
    first_hidden_window=$(echo "$hidden_windows" | head -n 1)

    # SỬA TẠI ĐÂY: Truyền tham số động thông qua hyprctl eval
    hyprctl eval "hl.dispatch(hl.dsp.window.move({ window = \"address:$first_hidden_window\", workspace = $current_workspace, follow = true }))"
    
    # Ép giữ chế độ HIỆN để lần bấm sau lôi tiếp cái khác ra, không bị ẩn ngược cái cũ
    echo "show" > "$STATUS_FILE"
else
    # Nếu trong kho ẩn đã hết sạch ứng dụng, tự động chuyển về chế độ ẨN để bấm ẩn lại từ đầu
    echo "hide" > "$STATUS_FILE"
fi
