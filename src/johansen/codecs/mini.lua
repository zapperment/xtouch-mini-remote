------------------------------------------------- Gulli Johansen ------------------------------------------------

k_vpot_min_value = 0
k_vpot_max_value = 10
k_vpot_spread_max_value = 6
k_vpot_center_value = 5
k_vpot_spread_scale = (k_vpot_spread_max_value - k_vpot_min_value) / (k_vpot_max_value - k_vpot_min_value)

k_fader_min_value = 0
k_fader_max_value = 920

k_min_peak_value = 0
-- FL: Peak max value for vertical. For horizontal it's 0xd.
k_max_peak_value = 10
k_peak_meter_update_interval = 20

k_control_model = 56

k_unit_channel_count = 8

g_selected_model = 0
g_num_channels = 0
g_num_rows = 0

g_no_feedback_items = {}
g_min_rotary_index = -1
g_max_rotary_index = -1
g_min_rotary_button_index = -1
g_max_rotary_button_index = -1
g_min_peak_index = -1
g_max_peak_index = -1

g_last_input_time = 0
g_last_input_item = -1
g_last_channel_input_time = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, }
g_last_channel_input_item = {}

g_new_peak_enabled_states = {}
g_new_peak_level_states = {}
g_sent_peak_enabled_states = {}
g_sent_peak_level_states = {}
-- FL: One for each port.
g_last_peak_update = { 0, 0 }

function from_hex(nr)
    return tonumber(nr, 16)
end

function to_hex(nr)
    return string.format("%02x", nr)
end

local function get_port_for_channel(channel)
    local port_no = 1
    if g_selected_model == k_combo_model then
        if channel > k_unit_channel_count then
            -- FL: Combo, Extender to the right on port # 2
            port_no = 2
        end
    elseif g_selected_model == k_combo_left_model then
        if channel <= k_unit_channel_count then
            -- FL: Combo, Extender to the left on port # 2
            port_no = 2
        end
    end
    return port_no
end

local function get_channel_index_for_channel(channel)
    local index = channel
    if g_selected_model ~= k_c4_model and index > k_unit_channel_count then
        index = index - k_unit_channel_count
    end
    return index
end

function make_rotary_control_byte(mode, value)
    -- FL: control_byte=center_dot<<6 + out_mode<<4 + out_value
    if mode == 7 then
        -- mode=Off
        control_byte = 0
    elseif mode == 6 then
        -- mode==On/Off
        if value > 0 then
            control_byte = 64
        else
            control_byte = 0
        end
    elseif mode == 5 then
        -- mode==Spread
        control_byte = 48 + value * k_vpot_spread_scale + 1
    elseif mode == 4 then
        -- mode==Boost/Cut
        control_byte = 16 + value + 1
    elseif mode == 3 then
        -- mode==Wrap
        control_byte = 32 + value + 1
    elseif mode == 2 then
        -- mode==Single Dot, Bipolar
        control_byte = value + 1
        if value == k_vpot_center_value then
            control_byte = control_byte + 64
        end
    else
        -- mode==Single Dot
        control_byte = value + 1
    end
    return control_byte
end

function remote_init(manufacturer, model)
    local global_items = {}
    local global_auto_inputs = {}
    local global_auto_outputs = {}

    ------------------------------------------------- Faders ------------------------------------------------

    local function MakeFaderMIDIInputMask(channel)
        assert(channel >= 1)
        assert(channel <= 9)
        local mask = "e" .. (channel - 1) .. "<?xxx>?yy"
        return mask
    end

    local function MakeFaderMIDIInputValueFormula()
        return "x+y*8"
    end

    local function MakeFaderMIDIOutputMask(channel)
        assert(channel >= 1)
        assert(channel <= 9)
        local mask = "e" .. (channel - 1) .. "<0xxx>0yy"
        return mask
    end

    local function MakeFaderMIDIOutputXFormula()
        return "bit.band(value,7)*enabled"
    end

    local function MakeFaderMIDIOutputYFormula()
        return "bit.rshift(value,3)*enabled"
    end

    local function define_faders()
        g_min_fader_index = table.getn(global_items) + 1
        for i = 1, g_num_channels do
            local item_name = "Fader " .. i
            table.insert(global_items, { name = item_name, input = "value", output = "value", min = k_fader_min_value, max = k_fader_max_value })
            local port_no = get_port_for_channel(i)
            local index = get_channel_index_for_channel(i)
            table.insert(global_auto_inputs, { name = item_name, pattern = MakeFaderMIDIInputMask(index), value = MakeFaderMIDIInputValueFormula(), port = port_no })
            table.insert(global_auto_outputs, { name = item_name, pattern = MakeFaderMIDIOutputMask(index), x = MakeFaderMIDIOutputXFormula(), y = MakeFaderMIDIOutputYFormula(), port = port_no })
        end
        g_max_fader_index = table.getn(global_items)
    end

    local function define_master_fader()
        local port_no = 1
        local item_name = "Master Fader"
        table.insert(global_items, { name = item_name, input = "value", output = "value", min = k_fader_min_value, max = k_fader_max_value })
        table.insert(global_auto_inputs, { name = item_name, pattern = MakeFaderMIDIInputMask(9), value = MakeFaderMIDIInputValueFormula(), port = port_no })
        table.insert(global_auto_outputs, { name = item_name, pattern = MakeFaderMIDIOutputMask(9), x = MakeFaderMIDIOutputXFormula(), y = MakeFaderMIDIOutputYFormula(), port = port_no })
    end

    ------------------------------------------------- Rotaries ------------------------------------------------

    local function MakeRotaryMIDIInputMask(channel)
        if g_selected_model == k_c4_model then
            assert(channel >= 1)
            assert(channel <= k_unit_channel_count * 4)
            local mask = "b0" .. to_hex(channel - 1) .. "<?y??>x"
            return mask
        else
            assert(channel >= 1)
            assert(channel <= k_unit_channel_count)
            local mask = "b01" .. (channel - 1) .. "<?y??>x"
            return mask
        end
    end

    local function MakeRotaryMIDIInputValueFormula()
        return "x*(1-2*y)"
    end

    local function MakeRotaryMIDIOutputMask(channel)
        if g_selected_model == k_c4_model then
            assert(channel >= 1)
            assert(channel <= k_unit_channel_count * 4)
            local mask = "b0" .. to_hex(32 + channel - 1) .. "xx"
            return mask
        else
            assert(channel >= 1)
            assert(channel <= k_unit_channel_count)
            local mask = "b03" .. (channel - 1) .. "xx"
            return mask
        end
    end

    local function MakeRotaryMIDIOutputXFormula()
        return "make_rotary_control_byte(mode,value)*enabled"
    end

    local function define_rotaries()
        g_min_rotary_index = table.getn(global_items) + 1
        for i = 1, g_num_channels do
            local item_name = "Rotary " .. i
            local mode_names = { "Single Dot", "Single Dot, Bipolar", "Wrap", "Boost/Cut", "Spread", "On/Off", "Off" }
            table.insert(global_items, { name = item_name, input = "delta", output = "value", min = 0, max = k_vpot_max_value, modes = mode_names })
            local port_no = get_port_for_channel(i)
            local index = get_channel_index_for_channel(i)
            table.insert(global_auto_inputs, { name = item_name, pattern = MakeRotaryMIDIInputMask(index), value = MakeRotaryMIDIInputValueFormula(), port = port_no })
            table.insert(global_auto_outputs, { name = item_name, pattern = MakeRotaryMIDIOutputMask(index), x = MakeRotaryMIDIOutputXFormula(), port = port_no })
        end
        g_max_rotary_index = table.getn(global_items)
    end

    ----------------------------------------------- Button/LED masks ----------------------------------------------

    local function MakeButtonMIDIInputMask(button_id)
        assert(button_id >= 0)
        assert(button_id <= from_hex("67"))
        local mask = "90" .. to_hex(button_id) .. "<?xxx>x"
        return mask
    end

    local function MakeButtonInputValueFormula()
        return "x/127"
    end

    local function MakeLEDMIDIOutputMask(led_id)
        assert(led_id >= 0)
        assert(led_id <= from_hex("73"))
        local mask = "90" .. to_hex(led_id) .. "xx"
        return mask
    end

    local function MakeLEDOutputXFormula()
        return "value*(127-(mode-1)*126)*enabled"
    end

    ------------------------------------------------- Rotary buttons ------------------------------------------------

    local function define_rotary_buttons()
        g_min_rotary_button_index = table.getn(global_items) + 1
        for i = 1, g_num_channels do
            local item_name = "Rotary Button " .. i
            table.insert(global_items, { name = item_name, input = "button", output = "text" })
            local port_no = get_port_for_channel(i)
            local index = get_channel_index_for_channel(i)
            local button_id = from_hex("20") + index - 1
            table.insert(global_auto_inputs, { name = item_name, pattern = MakeButtonMIDIInputMask(button_id), value = MakeButtonInputValueFormula(), port = port_no })
        end
        g_max_rotary_button_index = table.getn(global_items)
    end

    ------------------------------------------------- Input buttons ------------------------------------------------

    local function define_buttons()
        local inputButtonDefs = {
            { id = from_hex("59"), name = "Button 1", type = "inout" },
            { id = from_hex("5a"), name = "Button 2", type = "inout" },
            { id = from_hex("28"), name = "Button 3", type = "inout" },
            { id = from_hex("29"), name = "Button 4", type = "inout" },
            { id = from_hex("2a"), name = "Button 5", type = "inout" },
            { id = from_hex("2b"), name = "Button 6", type = "inout" },
            { id = from_hex("2c"), name = "Button 7", type = "inout" },
            { id = from_hex("2d"), name = "Button 8", type = "inout" },

            { id = from_hex("54"), name = "Frm Left Button", type = "inout" },
            { id = from_hex("55"), name = "Frm Right Button", type = "inout" },
            { id = from_hex("56"), name = "Loop Button", type = "inout" },
            { id = from_hex("57"), name = "Left Button", type = "inout" },
            { id = from_hex("58"), name = "Right Button", type = "inout" },
            { id = from_hex("5b"), name = "Rewind Button", type = "inout" },
            { id = from_hex("5c"), name = "Fast Fwd Button", type = "inout" },
            { id = from_hex("5d"), name = "Stop Button", type = "inout" },
            { id = from_hex("5e"), name = "Play Button", type = "inout" },
            { id = from_hex("5f"), name = "Record Button", type = "inout" },

        }
        local port_no = 1
        for _, v in pairs(inputButtonDefs) do
            local item_name = v.name
            local button_id = v.id
            if (v.type == "inout") then
                table.insert(global_items, { name = item_name, input = "button", output = "value", modes = { "Solid", "Flash" } })
                table.insert(global_auto_inputs, { name = item_name, pattern = MakeButtonMIDIInputMask(button_id), value = MakeButtonInputValueFormula(), port = port_no })
                table.insert(global_auto_outputs, { name = item_name, pattern = MakeLEDMIDIOutputMask(button_id), x = MakeLEDOutputXFormula(), port = port_no })
            else
                table.insert(global_items, { name = item_name, input = "button", output = "text" })
                table.insert(global_auto_inputs, { name = item_name, pattern = MakeButtonMIDIInputMask(button_id), value = MakeButtonInputValueFormula(), port = port_no })
            end
            if item_name == "SMPTE/Beats Button" then
                g_smpte_button_index = table.getn(global_items)
            end
            if item_name == "Rewind Button" or item_name == "Fast Fwd Button" or item_name == "Stop Button" or item_name == "Play Button" or item_name == "Record Button" then
                index = table.getn(global_items)
                g_no_feedback_items[index] = true
            end
        end
    end

    ------------------------------------------------------------

    assert(manufacturer == "Behringer")
    assert(model == "X-Touch Mini")

    if model == "X-Touch Mini" then
        g_selected_model = k_control_model
        g_num_channels = k_unit_channel_count
        g_num_rows = 2
        define_faders()
        define_master_fader()
        define_rotaries()
        define_rotary_buttons()
        define_buttons()

        for feedback_index = 1, g_num_channels do
            g_last_channel_input_time[feedback_index] = 0
            g_last_channel_input_item[feedback_index] = -1
        end

        remote.define_items(global_items)
        remote.define_auto_inputs(global_auto_inputs)
        remote.define_auto_outputs(global_auto_outputs)
    end

end
