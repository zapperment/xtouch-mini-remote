g_items = {}

g_states = {
	deviceName = { type = "string" },
	patchName = { type = "string" },
	debugMessage = { type = "string" },
	button1 = { type = "boolean" },
	button2 = { type = "boolean" },
	button3 = { type = "boolean" },
	button4 = { type = "boolean" },
	button5 = { type = "boolean" },
	button6 = { type = "boolean" },
	button7 = { type = "boolean" },
	button8 = { type = "boolean" },
	leftButton = { type = "boolean" },
	rightButton = { type = "boolean" },
	rewindButton = { type = "boolean" },
	fastFwdButton = { type = "boolean" },
	loopButton = { type = "boolean" },
	stopButton = { type = "boolean" },
	playButton = { type = "boolean" },
	recordButton = { type = "boolean" },
	rotary1 = { type = "number" },
	rotary2 = { type = "number" },
	rotary3 = { type = "number" },
	rotary4 = { type = "number" },
	rotary5 = { type = "number" },
	rotary6 = { type = "number" },
	rotary7 = { type = "number" },
	rotary8 = { type = "number" },
	masterFader = { type = "number" }
}

function send_debug(message)
	g_states.debugMessage.next = message
end

function remote_set_state(changed_items)
	for i, item_index in ipairs(changed_items) do
		local item_name = g_items[item_index].name
		local state = g_states[item_name]
		if state ~= nil then
			if state.type == "string" then
				state.next = remote.get_item_text_value(item_index)
			elseif state.type == "boolean" then
				local value = remote.get_item_value(item_index)
				state.next = value == 1 and true or false
			else
				state.next = remote.get_item_value(item_index)
			end
		end
	end
end

local function make_sysex_text_message(text)
	-- sysex header with manufacturer ID “mackie”
	local event = remote.make_midi("f0 00 00 66")
	start = 5
	stop = 5 + string.len(text) - 1
	for i = start, stop do
		sourcePos = i - start + 1
		event[i] = string.byte(text, sourcePos)
	end
	event[stop + 1] = 247         -- hex f7
	return event
end

function remote_deliver_midi()
	local changes = {}
	for name, state in pairs(g_states) do
		local next_value = state.next
		if state.prev ~= next_value then
			local value_str
			if state.type == "string" then
				value_str = "\"" .. next_value .. "\""
			elseif state.type == "boolean" then
				value_str = next_value and "true" or "false"
			else
				value_str = string.format("%i", next_value)
			end
			table.insert(changes, "\"" .. name .. "\":" .. value_str)
			state.prev = next_value
		end
	end
	if #changes == 0 then
		return {}
	end
	return {
		make_sysex_text_message("{" .. table.concat(changes, ",") .. "}")
	}
end

function from_hex(nr)
	return tonumber(nr, 16)
end

function to_hex(nr)
	return string.format("%02x", nr)
end

function remote_init()
	local auto_inputs = {}
	local auto_outputs = {}

	------------------------------------------------- Faders ------------------------------------------------

	local function define_master_fader()
		local item_name = "masterFader"
		table.insert(g_items, { name = item_name, input = "value", output = "value", min = 0, max = 127 })
	end

	------------------------------------------------- Rotaries ------------------------------------------------

	local function define_rotaries()
		for i = 1, 8 do
			local item_name = "rotary" .. i
			table.insert(g_items, { name = item_name, input = "delta", output = "value", min = 0, max = 127 })
		end
	end

	------------------------------------------------- Rotary buttons ------------------------------------------------

	local function define_rotary_buttons()
		for i = 1, 8 do
			local item_name = "rotaryButton" .. i
			table.insert(g_items, { name = item_name, input = "button", output = "text" })
		end
	end

	------------------------------------------------- Input buttons ------------------------------------------------

	local function define_buttons()
		local inputButtonDefs = {
			{ name = "button1" },
			{ name = "button2" },
			{ name = "button3" },
			{ name = "button4" },
			{ name = "button5" },
			{ name = "button6" },
			{ name = "button7" },
			{ name = "button8" },
			{ name = "layerButtonA" },
			{ name = "layerButtonB" },
			{ name = "leftButton" },
			{ name = "rightButton" },
			{ name = "rewindButton" },
			{ name = "fastFwdButton" },
			{ name = "loopButton" },
			{ name = "stopButton" },
			{ name = "playButton" },
			{ name = "recordButton" },
		}
		for _, v in pairs(inputButtonDefs) do
			local item_name = v.name
			table.insert(g_items, { name = item_name, input = "button", output = "value", modes = { "Solid", "Flash" } })
		end
	end

	------------------------------------------------------------

	define_master_fader()
	define_rotaries()
	define_rotary_buttons()
	define_buttons()

	table.insert(g_items, { name = "deviceName", output = "text" })
	g_device_name_index = #g_items
	table.insert(g_items, { name = "patchName", output = "text" })
	g_patch_name_index = #g_items

	remote.define_items(g_items)
	remote.define_auto_inputs(auto_inputs)
	remote.define_auto_outputs(auto_outputs)

	send_debug("X-Toucher remote codec initialized")
end

function remote_prepare_for_use()
	return {
		-- turn off MC mode
		remote.make_midi("b0 7f 00", { port = 1 }),

		-- turn off all LED rings
		remote.make_midi("b0 09 00", { port = 1 }),
		remote.make_midi("b0 0a 00", { port = 1 }),
		remote.make_midi("b0 0b 00", { port = 1 }),
		remote.make_midi("b0 0c 00", { port = 1 }),
		remote.make_midi("b0 0d 00", { port = 1 }),
		remote.make_midi("b0 0e 00", { port = 1 }),
		remote.make_midi("b0 0f 00", { port = 1 }),
		remote.make_midi("b0 10 00", { port = 1 }),
	}
end
