function from_hex(nr)
	return tonumber(nr, 16)
end

function to_hex(nr)
	return string.format("%02x", nr)
end

function remote_init()
	local items = {}
	local auto_inputs = {}
	local auto_outputs = {}

	------------------------------------------------- Faders ------------------------------------------------

	local function define_master_fader()
		local item_name = "Master Fader"
		table.insert(items, { name = item_name, input = "value", output = "value", min = 0, max = 920 })
		table.insert(auto_inputs, { name = item_name, pattern = "e8<?xxx>?yy", value = "x+y*8" })
		table.insert(auto_outputs, { name = item_name, pattern = "e8<0xxx>0yy", x = "bit.band(value,7)", y = "bit.rshift(value,3)" })
	end

	------------------------------------------------- Rotaries ------------------------------------------------

	local function define_rotaries()
		for i = 1, 8 do
			local item_name = "Rotary " .. i
			table.insert(items, { name = item_name, input = "delta", output = "value", min = 0, max = 10 })
			table.insert(auto_inputs, { name = item_name, pattern = "b01" .. (i - 1) .. "<?y??>x", value = "x*(1-2*y)" })
			table.insert(auto_outputs, { name = item_name, pattern = "b03" .. (i - 1) .. "xx", x = "value+1" })
		end
	end

	----------------------------------------------- Button/LED masks ----------------------------------------------

	local function make_button_midi_input_mask(button_id)
		return "90" .. to_hex(button_id) .. "<?xxx>x"
	end

	local button_input_value_formula = "x/127"

	------------------------------------------------- Rotary buttons ------------------------------------------------

	local function define_rotary_buttons()
		for i = 1, 8 do
			local item_name = "Rotary Button " .. i
			table.insert(items, { name = item_name, input = "button", output = "text" })
			local button_id = from_hex("20") + i - 1
			table.insert(auto_inputs, { name = item_name, pattern = make_button_midi_input_mask(button_id), value = button_input_value_formula })
		end
	end

	------------------------------------------------- Input buttons ------------------------------------------------

	local function define_buttons()
		local inputButtonDefs = {
			{ id = from_hex("59"), name = "Button 1" },
			{ id = from_hex("5a"), name = "Button 2" },
			{ id = from_hex("28"), name = "Button 3" },
			{ id = from_hex("29"), name = "Button 4" },
			{ id = from_hex("2a"), name = "Button 5" },
			{ id = from_hex("2b"), name = "Button 6" },
			{ id = from_hex("2c"), name = "Button 7" },
			{ id = from_hex("2d"), name = "Button 8" },

			{ id = from_hex("54"), name = "Layer A Button" },
			{ id = from_hex("55"), name = "Layer B Button" },

			{ id = from_hex("57"), name = "Left Button" },
			{ id = from_hex("58"), name = "Right Button" },

			{ id = from_hex("5b"), name = "Rewind Button" },
			{ id = from_hex("5c"), name = "Fast Fwd Button" },

			{ id = from_hex("56"), name = "Loop Button" },

			{ id = from_hex("5d"), name = "Stop Button" },
			{ id = from_hex("5e"), name = "Play Button" },
			{ id = from_hex("5f"), name = "Record Button" },
		}
		for _, v in pairs(inputButtonDefs) do
			local item_name = v.name
			local button_id = v.id
			table.insert(items, { name = item_name, input = "button", output = "value", modes = { "Solid", "Flash" } })
			table.insert(auto_inputs, { name = item_name, pattern = make_button_midi_input_mask(button_id), value = button_input_value_formula })
			table.insert(auto_outputs, { name = item_name, pattern = "90" .. to_hex(button_id) .. "xx", x = "value*(127-(mode-1)*126)*enabled" })
		end
	end

	------------------------------------------------------------

	define_master_fader()
	define_rotaries()
	define_rotary_buttons()
	define_buttons()

	remote.define_items(items)
	remote.define_auto_inputs(auto_inputs)
	remote.define_auto_outputs(auto_outputs)
end

function remote_prepare_for_use()
	return {
		-- turn on MC mode
		remote.make_midi("b0 7f 01", { port = 1 }),
	}
end
