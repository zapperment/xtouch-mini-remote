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

g_sysex_item_id_to_item_index_map = {}
g_item_index_to_sysex_item_id_map = {}

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

function get_item_index(item_name)
	for item_index, item in ipairs(g_items) do
		if item.name == item_name then
			return item_index
		end
	end
end

function get_sysex_item_id(item_name)
	return g_item_index_to_sysex_item_id_map[get_item_index(item_name)]
end

local function make_sysex_text_message(name, text)
	-- sysex header with manufacturer ID of Behringer GmbH
	-- followed by 0x19, which is 25 - 0-24 are the rotaries and buttons,
	-- 25 means variable length text
	local event = remote.make_midi("f0 00 20 32 xx", { x=get_sysex_item_id(name) })
	start = 6
	stop = 6 + string.len(text) - 1
	for i = start, stop do
		sourcePos = i - start + 1
		event[i] = string.byte(text, sourcePos)
	end
	event[stop + 1] = 247 -- hex f7 marks end of sysex message
	return event
end

-- Sends the current changes table in JSON format,
-- encoded as sysex MIDI, to the X-Toucher app
-- to update the state of button lights and rotary LEDs
function remote_deliver_midi()
	local messages = {}
	for name, state in pairs(g_states) do
		local next_value = state.next
		if state.prev ~= next_value then
			if state.type == "string" then
				table.insert(messages, make_sysex_text_message(name, next_value))
			elseif state.type == "boolean" then
				table.insert(messages, remote.make_midi("f0 00 20 32 xx yy f7", { x=get_sysex_item_id(name), y=next_value and 127 or 0 }))
			else
				table.insert(messages, remote.make_midi("f0 00 20 32 xx yy f7", { x=get_sysex_item_id(name), y=next_value }))
			end
			state.prev = next_value
		end
	end
	return messages
end

-- Processes incoming sysex MIDI messages from the X-Toucher app,
-- interprets them and sends them to Reason
function remote_process_midi(event)
	ret = remote.match_midi("f0 00 20 32 xx yy f7", event)
	if ret == nil then
		return false
	end
	local item_index = g_sysex_item_id_to_item_index_map[ret.x]
	local item_input = g_items[item_index].input
	local item_next_value = (item_input == "button" and ret.y == 127) and 1 or ret.y
	local item_prev_value = remote.get_item_value(item_index)
	if item_prev_value == item_next_value then
		return false
	end
	remote.handle_input({ time_stamp = event.time_stamp, item = item_index, value = item_input == "button" and 1 or item_next_value })
	return true
end

function from_hex(nr)
	return tonumber(nr, 16)
end

function to_hex(nr)
	return string.format("%02x", nr)
end

function remote_init()

	------------------------------------------------- Faders ------------------------------------------------

	local function define_master_fader()
		local item_name = "masterFader"
		table.insert(g_items, { name = item_name, input = "value", output = "value", min = 0, max = 127 })
	end

	------------------------------------------------- Rotaries ------------------------------------------------

	local function define_rotaries()
		for i = 1, 8 do
			local item_name = "rotary" .. i
			table.insert(g_items, { name = item_name, input = "value", output = "value", min = 0, max = 127 })
		end
	end

	------------------------------------------------- Rotary buttons ------------------------------------------------

	local function define_rotary_buttons()
		for i = 1, 8 do
			local item_name = "rotaryButton" .. i
			table.insert(g_items, { name = item_name, input = "button", output = "value" })
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
			table.insert(g_items, { name = item_name, input = "button", output = "value" })
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

	table.insert(g_sysex_item_id_to_item_index_map, 0, get_item_index("button1"))
	table.insert(g_sysex_item_id_to_item_index_map, 1, get_item_index("button2"))
	table.insert(g_sysex_item_id_to_item_index_map, 2, get_item_index("button3"))
	table.insert(g_sysex_item_id_to_item_index_map, 3, get_item_index("button4"))
	table.insert(g_sysex_item_id_to_item_index_map, 4, get_item_index("button5"))
	table.insert(g_sysex_item_id_to_item_index_map, 5, get_item_index("button6"))
	table.insert(g_sysex_item_id_to_item_index_map, 6, get_item_index("button7"))
	table.insert(g_sysex_item_id_to_item_index_map, 7, get_item_index("button8"))
	table.insert(g_sysex_item_id_to_item_index_map, 8, get_item_index("leftButton"))
	table.insert(g_sysex_item_id_to_item_index_map, 9, get_item_index("rightButton"))
	table.insert(g_sysex_item_id_to_item_index_map, 10, get_item_index("rewindButton"))
	table.insert(g_sysex_item_id_to_item_index_map, 11, get_item_index("fastFwdButton"))
	table.insert(g_sysex_item_id_to_item_index_map, 12, get_item_index("loopButton"))
	table.insert(g_sysex_item_id_to_item_index_map, 13, get_item_index("stopButton"))
	table.insert(g_sysex_item_id_to_item_index_map, 14, get_item_index("playButton"))
	table.insert(g_sysex_item_id_to_item_index_map, 15, get_item_index("recordButton"))
	table.insert(g_sysex_item_id_to_item_index_map, 16, get_item_index("rotary1"))
	table.insert(g_sysex_item_id_to_item_index_map, 17, get_item_index("rotary2"))
	table.insert(g_sysex_item_id_to_item_index_map, 18, get_item_index("rotary3"))
	table.insert(g_sysex_item_id_to_item_index_map, 19, get_item_index("rotary4"))
	table.insert(g_sysex_item_id_to_item_index_map, 20, get_item_index("rotary5"))
	table.insert(g_sysex_item_id_to_item_index_map, 21, get_item_index("rotary6"))
	table.insert(g_sysex_item_id_to_item_index_map, 22, get_item_index("rotary7"))
	table.insert(g_sysex_item_id_to_item_index_map, 23, get_item_index("rotary8"))
	table.insert(g_sysex_item_id_to_item_index_map, 24, get_item_index("masterFader"))

	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("button1"), 0)
	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("button2"), 1)
	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("button3"), 2)
	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("button4"), 3)
	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("button5"), 4)
	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("button6"), 5)
	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("button7"), 6)
	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("button8"), 7)
	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("leftButton"), 8)
	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("rightButton"), 9)
	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("rewindButton"), 10)
	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("fastFwdButton"), 11)
	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("loopButton"), 12)
	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("stopButton"), 13)
	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("playButton"), 14)
	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("recordButton"), 15)
	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("rotary1"), 16)
	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("rotary2"), 17)
	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("rotary3"), 18)
	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("rotary4"), 19)
	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("rotary5"), 20)
	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("rotary6"), 21)
	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("rotary7"), 22)
	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("rotary8"), 23)
	table.insert(g_item_index_to_sysex_item_id_map, get_item_index("masterFader"), 24)

	send_debug("X-Toucher remote codec initialized")
end

function remote_release_from_use()
	return {
		make_sysex_text_message("goodbye")
	}
end

