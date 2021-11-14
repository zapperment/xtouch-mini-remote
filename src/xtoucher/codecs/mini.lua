g_items = {}

g_states = {
	["Device Name"] = {
		command = "00",
		next = nil,
		prev = nil
	},
	["Patch Name"] = {
		command = "01",
		next = nil,
		prev = nil
	},
	["Debug Message"] = {
		command = "02",
		next = nil,
		prev = nil
	}
}

function send_debug(message)
	g_states["Debug Message"].next = message
	g_debug_message = message
end

function remote_set_state(changed_items)
	for i, item_index in ipairs(changed_items) do
		local item_name = g_items[item_index].name
		if g_states[item_name] ~= nil then
			g_states[item_name].next = remote.get_item_text_value(item_index)
		else
			send_debug(string.format("setting state: %i", item_index))
		end
	end
end

-- command 00: device name
-- command 01: patch name
-- command 02: debug message
local function make_sysex_text_message(text, command)
	-- sysex header with manufacturer ID “mackie”
	local event = remote.make_midi("f0 00 00 66 " .. command)
	start = 6
	stop = 6 + string.len(text) - 1
	for i = start, stop do
		sourcePos = i - start + 1
		event[i] = string.byte(text, sourcePos)
	end
	event[stop + 1] = 247         -- hex f7
	return event
end

function remote_deliver_midi()
	local ret_events = {}
	for i, state in pairs(g_states) do
		local next_value = state.next
		if state.prev ~= next_value then
			local event = make_sysex_text_message(next_value, state.command)
			table.insert(ret_events, event)
			state.prev = next_value;
		end
	end
	return ret_events
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
		local item_name = "Master Fader"
		table.insert(g_items, { name = item_name, input = "value", output = "value", min = 0, max = 920 })
	end

	------------------------------------------------- Rotaries ------------------------------------------------

	local function define_rotaries()
		for i = 1, 8 do
			local item_name = "Rotary " .. i
			table.insert(g_items, { name = item_name, input = "delta", output = "value", min = 0, max = 10 })
		end
	end

	------------------------------------------------- Rotary buttons ------------------------------------------------

	local function define_rotary_buttons()
		for i = 1, 8 do
			local item_name = "Rotary Button " .. i
			table.insert(g_items, { name = item_name, input = "button", output = "text" })
		end
	end

	------------------------------------------------- Input buttons ------------------------------------------------

	local function define_buttons()
		local inputButtonDefs = {
			{ name = "Button 1" },
			{ name = "Button 2" },
			{ name = "Button 3" },
			{ name = "Button 4" },
			{ name = "Button 5" },
			{ name = "Button 6" },
			{ name = "Button 7" },
			{ name = "Button 8" },

			{ name = "Layer A Button" },
			{ name = "Layer B Button" },

			{ name = "Left Button" },
			{ name = "Right Button" },

			{ name = "Rewind Button" },
			{ name = "Fast Fwd Button" },

			{ name = "Loop Button" },

			{ name = "Stop Button" },
			{ name = "Play Button" },
			{ name = "Record Button" },
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

	table.insert(g_items, { name = "Device Name", output = "text" })
	g_device_name_index = #g_items
	table.insert(g_items, { name = "Patch Name", output = "text" })
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
