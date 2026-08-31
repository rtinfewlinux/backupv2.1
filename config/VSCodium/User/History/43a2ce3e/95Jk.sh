-- Phím tắt gọi TOÀN BỘ cửa sổ đang ẩn ra lại màn hình hiện tại cùng lúc
hl.bind("CTRL + ALT + TAB", function()
    -- 1. Lấy danh sách các đối tượng cửa sổ đang nằm trong vùng ẩn special:minimized
    local hidden_windows = hl.get_workspace_windows("special:minimized")

    -- Nếu danh sách trống (không có tab nào ẩn) thì dừng lại không làm gì cả
    if not hidden_windows or #hidden_windows == 0 then
        return
    end

    -- 2. Lấy ID của workspace (màn hình) hiện tại bạn đang đứng
    local current_ws = hl.get_active_workspace().id

    -- 3. Sử dụng vòng lặp duyệt qua TOÀN BỘ các tab ẩn để đưa chúng ra ngoài
    for _, win in ipairs(hidden_windows) do
        hl.dispatch(hl.dsp.window.move({ 
            window = "address:" .. win.address, 
            workspace = current_ws, 
            follow = false -- Đặt false để lặp kéo tất cả cửa sổ ra mà không bị đứng màn hình
        }))
    end
end)