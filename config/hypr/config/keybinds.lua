local mainMod = _G.mainMod or "SUPER"
local terminal = _G.terminal or "kitty"

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. " + SHIFT + Left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + Right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + Up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + Down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })

hl.bind(mainMod .. " + CTRL + Left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + CTRL + Right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + CTRL + Up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + CTRL + Down", hl.dsp.window.move({ direction = "d" }))

hl.bind(mainMod .. " + Left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + Right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + Up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + Down", hl.dsp.focus({ direction = "down" }))

hl.bind("ALT + F4", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))

hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("serpantinum brightness lower"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("serpantinum brightness raise"), { locked = true })

hl.bind("Print", hl.dsp.exec_cmd("serpantinum screenshot"), { locked = true })
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("serpantinum screenshot --edit"), { locked = true })
hl.bind("SUPER + Print", hl.dsp.exec_cmd("serpantinum screenshot --full"), { locked = true })
hl.bind("SUPER + SHIFT + Print", hl.dsp.exec_cmd("serpantinum screenshot --full --edit"), { locked = true })

hl.bind("XF86PowerOff", hl.dsp.exec_cmd("serpantinum lock"), { locked = true })
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("serpantinum lock"), { repeating = true, locked = true })

hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("serpantinum volume mic-toggle"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("serpantinum volume mute-toggle"), { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("serpantinum volume lower"), { repeating = true, locked = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("serpantinum volume raise"), { repeating = true, locked = true })

hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("chromium"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("nautilus"))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))

hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("serpantinum reload"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("serpantinum msg toggle clipboard"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("serpantinum msg toggle launcher"))
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("serpantinum msg toggle music"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("serpantinum msg toggle system"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("serpantinum msg toggle wallpaper"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("serpantinum msg toggle calendar"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("serpantinum msg toggle network"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("serpantinum msg toggle volume"))
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd("serpantinum msg toggle guide"))

for i = 1, 10 do
	local ws = tostring(i)
	local key = tostring(i % 10)
	hl.bind(mainMod .. " + " .. key, hl.dsp.exec_cmd("serpantinum msg workspace " .. ws))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.exec_cmd("serpantinum msg workspace " .. ws .. " move"))
end

hl.bind("ALT + TAB", function()
	local hidden_windows = hl.get_workspace_windows("special:minimized")

	-- Nếu chưa ẩn cửa sổ nào -> Ẩn cửa sổ hiện tại
	if not hidden_windows or #hidden_windows == 0 then
		hl.dispatch(hl.dsp.window.move({ workspace = "special:minimized", follow = false }))
	else
		-- Nếu đang có cửa sổ ẩn -> Mang cửa sổ đầu tiên ra màn hình hiện tại
		local current_ws = hl.get_active_workspace().id
		local first_hidden_window = hidden_windows[1]

		hl.dispatch(hl.dsp.window.move({
			window = "address:" .. first_hidden_window.address,
			workspace = current_ws,
			follow = true,
		}))
	end
end)

hl.bind("CTRL + TAB", hl.dsp.window.move({ workspace = "special:minimized", follow = false }))

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
			follow = false, -- Đặt false để kéo đồng loạt không bị đứng hình giật cục
		}))
	end
end)

-- Biến toàn cục lưu trạng thái toggle (Thay thế cho việc đọc ghi file /tmp)
local current_mode = "hide"

hl.bind(mainMod .. " + ALT + TAB", function()
	-- 1. Lấy danh sách các cửa sổ bị ẩn
	local hidden_windows = hl.get_workspace_windows("special:minimized") or {}

	-- Sắp xếp danh sách theo focusHistoryID giảm dần (Đảo ngược giống lệnh reverse của jq)
	table.sort(hidden_windows, function(a, b)
		return (a.focusHistoryID or 0) > (b.focusHistoryID or 0)
	end)

	-- 2. Kiểm tra cửa sổ đang hoạt động hiện tại
	local active_win = hl.get_active_window()
	local active_address = (active_win and active_win.address ~= "0x0" and active_win.address ~= "")
			and active_win.address
		or nil

	if not active_address then
		current_mode = "show"
	end

	-- 3. Logic ẨN LIÊN TỤC
	if active_address and current_mode ~= "show" then
		hl.dispatch(hl.dsp.window.move({ workspace = "special:minimized", follow = false }))
		return
	end

	-- 4. Logic HIỆN LẦN LƯỢT
	if #hidden_windows > 0 then
		local first_hidden_window = hidden_windows[1]
		local current_ws = hl.get_active_workspace().id

		hl.dispatch(hl.dsp.window.move({
			window = "address:" .. first_hidden_window.address,
			workspace = current_ws,
			follow = true,
		}))

		current_mode = "show"
	else
		current_mode = "hide"
	end
end)
