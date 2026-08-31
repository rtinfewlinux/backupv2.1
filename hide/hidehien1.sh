#!/bin/bash

# 1. Lấy ID của workspace hiện tại bạn đang đứng
current_ws=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .activeWorkspace.id')

# 2. Lấy thông tin chi tiết của cửa sổ đang active (đang chọn)
active_info=$(hyprctl activewindow -j)
active_address=$(echo "$active_info" | jq -r '.address')
active_ws_id=$(echo "$active_info" | jq -r '.workspace.id')

# Làm sạch biến nếu màn hình trống trơn
if [ "$active_address" = "null" ]; then active_address=""; fi

# 3. LOGIC ẨN (ƯU TIÊN): Nếu màn hình đang chọn có ứng dụng VÀ ứng dụng đó đang nằm ở workspace chính
if [ -n "$active_address" ] && [ "$active_ws_id" = "$current_ws" ]; then
    # SỬA TẠI ĐÂY: Dùng hyprctl eval để thực thi hàm Lua ẩn cửa sổ
    hyprctl eval 'hl.dispatch(hl.dsp.window.move({ workspace = "special:minimized", follow = false }))'
    exit 0
fi

# 4. LOGIC HIỆN: Nếu màn hình trống trơn (không có ứng dụng nào hiển thị tại workspace này)
hidden_windows=$(hyprctl clients -j | jq -r '[.[] | select(.workspace.name == "special:minimized")] | sort_by(.focusHistoryID) | reverse | .[].address')
first_hidden_window=$(echo "$hidden_windows" | head -n 1)

if [ "$first_hidden_window" != "null" ] && [ -n "$first_hidden_window" ]; then
    # SỬA TẠI ĐÂY: Ép cửa sổ đó xuất hiện trở lại đúng màn hình hiện tại (+0 của bản cũ đổi thành current_ws)
    hyprctl eval "hl.dispatch(hl.dsp.window.move({ window = \"address:$first_hidden_window\", workspace = $current_ws, follow = true }))"
    exit 0
fi