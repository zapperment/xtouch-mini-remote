--  Impact.lua
--  Copyright Nektar Technology Inc, 2013 v1.2.14
--  Written by Tim Chandler
--  WARNING! Do not Edit or re-save this file with Notepad under Windows. Using Wordpad or Programmer's Notepad is OK
release_tag = "20210507, build #139"
gDisableDisplayUpdates = false
RunSecondScan = true
g_model_is_iX = true
g_model_is_lxmini = false
gSendShiftCCForGrab = false

function remote_init(manufacturer, model)

    g_keyboard_port = 2
    g_control_port = 1
    g_num_instrument_ctrls = 6000
    g_num_faders = 9
    g_num_buttons = 9
    g_num_knobs = 8
    g_fader_max = 127
    g_max_num_groups = 128
    kNumMixChannels = 8
    g_max_num_steps = 16

    ccS1 = ccMixerMode
    ccS2 = ccInstMode
    ccS3 = ccUserMode

    local items = {}

    table.insert(items, {
        name = "Keyboard",
        input = "keyboard"
    })

    table.insert(items, {
        name = "Pitch Bend",
        input = "value",
        output = "value",
        min = 0,
        max = 16383,
        modes = {"NORMAL", "OVERRIDE"}
    })

    table.insert(items, {
        name = "Modulation",
        input = "value",
        output = "value",
        min = 0,
        max = 127,
        modes = {"NORMAL", "OVERRIDE"}
    })

    table.insert(items, {
        name = "Damper Pedal",
        input = "value",
        output = "value",
        min = 0,
        max = 127,
        modes = {"NORMAL", "OVERRIDE"}
    })

    table.insert(items, {
        name = "Expression Pedal",
        input = "value",
        output = "value",
        min = 0,
        max = 127,
        modes = {"NORMAL", "OVERRIDE"}
    })

    table.insert(items, {
        name = "Channel Pressure",
        input = "value",
        output = "value",
        min = 0,
        max = 127,
        modes = {"NORMAL", "OVERRIDE"}
    })

    table.insert(items, {
        name = "Program Change",
        input = "value",
        output = "value",
        min = 0,
        max = 127,
        modes = {"NORMAL", "OVERRIDE"}
    })

    g_last_keyboard_item = 7
    g_inst_ctrl_first = g_last_keyboard_item + 1

    for i = 0, g_num_instrument_ctrls do

        local item_name = "Ctrl " .. i

        table.insert(items, {
            name = item_name,
            input = "value",
            output = "value",
            min = 0,
            max = 127,
            modes = {"CTRL", "TRIGGER"}
        })

    end

    g_inst_ctrl_last = table.getn(items)
    g_cc_first = table.getn(items) + 1

    for i = 0, 127 do

        local item_name = "MIDI CC " .. i

        table.insert(items, {
            name = item_name,
            input = "value",
            output = "value",
            min = 0,
            max = 127
        })

    end

    g_cc_last = table.getn(items)
    g_pad_note_first = table.getn(items) + 1

    for i = 0, 16 do

        local item_name = "Pad " .. (i + 1) .. " Note"

        table.insert(items, {
            name = item_name,
            input = "value",
            output = "value",
            min = 0,
            max = 127
        })

    end

    g_pad_note_last = table.getn(items)
    g_pad_first = table.getn(items) + 1

    for i = 0, 16 do

        local item_name = "Pad " .. (i + 1)

        table.insert(items, {
            name = item_name,
            input = "button",
            output = "value",
            min = 0,
            max = 1,
            modes = {"BUTTON", "DRUM", "DRUM_CTRL"}
        })

    end

    g_pad_last = table.getn(items)
    g_pad_mute_first = table.getn(items) + 1

    for i = 0, 16 do

        local item_name = "Pad " .. (i + 1) .. " Mute"

        table.insert(items, {
            name = item_name,
            input = "value",
            output = "value",
            min = 0,
            max = 2048
        })

    end

    g_pad_mute_last = table.getn(items)
    g_pad_solo_first = table.getn(items) + 1

    for i = 0, 16 do

        local item_name = "Pad " .. (i + 1) .. " Solo"

        table.insert(items, {
            name = item_name,
            input = "value",
            output = "value",
            min = 0,
            max = 2048
        })

    end

    g_pad_solo_last = table.getn(items)
    g_pad_volume_first = table.getn(items) + 1

    for i = 0, 16 do

        local item_name = "Pad " .. (i + 1) .. " Volume"

        table.insert(items, {
            name = item_name,
            input = "value",
            output = "value",
            min = 0,
            max = 2048
        })

    end

    g_pad_volume_last = table.getn(items)
    g_pad_drum_first = table.getn(items) + 1

    for i = 0, 16 do

        local item_name = "Pad " .. (i + 1) .. " Drum Assignment"

        table.insert(items, {
            name = item_name,
            input = "value",
            output = "value",
            min = 0,
            max = g_num_instrument_ctrls
        })

    end

    g_pad_drum_last = table.getn(items)
    g_drum_first = table.getn(items) + 1

    for i = 0, 16 do

        local item_name = "Drum " .. i + 1

        table.insert(items, {
            name = item_name,
            input = "button"
        })

    end

    g_drum_last = table.getn(items)
    g_group_first = table.getn(items) + 1

    for i = 0, g_max_num_groups do

        local item_name = "Group " .. i + 1

        table.insert(items, {
            name = item_name,
            input = "button"
        })

    end

    g_group_last = table.getn(items)
    g_step_first = table.getn(items) + 1

    for i = 0, g_max_num_steps do

        local item_name = "Step " .. i + 1

        table.insert(items, {
            name = item_name,
            output = "value",
            min = 0,
            max = 1
        })

    end

    g_step_last = table.getn(items)
    g_step_toggle_first = table.getn(items) + 1

    for i = 0, g_max_num_steps do

        local item_name = "Step " .. (i + 1) .. " Toggle"

        table.insert(items, {
            name = item_name,
            input = "button",
            output = "value",
            min = 0,
            max = 1
        })

    end

    g_step_toggle_last = table.getn(items)
    g_fader_first = table.getn(items) + 1

    for i = 1, g_num_faders do

        local item_name = "Fader " .. i

        table.insert(items, {
            name = item_name,
            input = "value",
            output = "value",
            min = 0,
            max = g_num_instrument_ctrls,
            modes = {"DEFAULT", "NAME", "DRUM_MIX"}
        })

    end

    g_fader_last = table.getn(items)
    g_button_first = table.getn(items) + 1

    for i = 1, g_num_buttons do

        local item_name = "Button " .. i

        table.insert(items, {
            name = item_name,
            input = "value",
            output = "value",
            min = 0,
            max = g_num_instrument_ctrls,
            modes = {"CTRL", "GROUP", "MODIFIER1", "MODIFIER2", "DRUM_MIX", "TRIG"}
        })

    end

    g_button_last = table.getn(items)
    g_knob_first = table.getn(items) + 1

    for i = 1, g_num_knobs do

        local item_name = "Knob " .. i

        table.insert(items, {
            name = item_name,
            input = "value",
            output = "value",
            min = 0,
            max = g_num_instrument_ctrls
        })

    end

    g_knob_last = table.getn(items)
    g_mod1_first = table.getn(items) + 1

    for i = 1, 64 do

        local item_name = "Modifier1 " .. (i - 1)

        table.insert(items, {
            name = item_name,
            input = "button",
            output = "value",
            min = 0,
            max = 1
        })

    end

    g_mod1_last = table.getn(items)
    g_mod2_first = table.getn(items) + 1

    for i = 1, 64 do

        local item_name = "Modifier2 " .. (i - 1)

        table.insert(items, {
            name = item_name,
            input = "button",
            output = "value",
            min = 0,
            max = 1
        })

    end

    g_mod2_last = table.getn(items)
    g_shift = table.getn(items) + 1
    g_func_first = g_shift

    table.insert(items, {
        name = "Shift",
        input = "button"
    })

    table.insert(items, {
        name = "Track Down",
        input = "button"
    })

    table.insert(items, {
        name = "Track Up",
        input = "button"
    })

    table.insert(items, {
        name = "Patch Down",
        input = "button"
    })

    table.insert(items, {
        name = "Patch Up",
        input = "button"
    })

    g_func_last = table.getn(items)

    table.insert(items, {
        name = "Default",
        input = "button",
        output = "value"
    })

    g_default = table.getn(items)

    table.insert(items, {
        name = "User",
        input = "button"
    })

    g_user = table.getn(items)

    table.insert(items, {
        name = "Plugin View",
        input = "button",
        output = "value"
    })

    g_plugin_view = table.getn(items)

    table.insert(items, {
        name = "Track Mute",
        input = "button"
    })

    g_track_mute = table.getn(items)

    table.insert(items, {
        name = "Track Solo",
        input = "button"
    })

    g_track_solo = table.getn(items)

    table.insert(items, {
        name = "Track Auto",
        input = "button"
    })

    g_track_auto = table.getn(items)
    g_shift_on = table.getn(items) + 1

    table.insert(items, {
        name = "Shift On",
        input = "button"
    })

    g_shift_off = table.getn(items) + 1

    table.insert(items, {
        name = "Shift Off",
        input = "button"
    })

    g_trans_first = table.getn(items) + 1

    table.insert(items, {
        name = "CLICK",
        input = "button"
    })

    table.insert(items, {
        name = "LOOP",
        input = "button",
        output = "value"
    })

    table.insert(items, {
        name = "REWIND",
        input = "button"
    })

    table.insert(items, {
        name = "FORWARD",
        input = "button"
    })

    table.insert(items, {
        name = "STOP",
        input = "button"
    })

    table.insert(items, {
        name = "PLAY",
        input = "button",
        output = "value"
    })

    table.insert(items, {
        name = "RECORD",
        input = "button",
        output = "value"
    })

    g_trans_last = table.getn(items)

    table.insert(items, {
        name = "UNDO",
        input = "button"
    })

    g_undo = table.getn(items)

    table.insert(items, {
        name = "QREC",
        input = "button"
    })

    g_qrec = table.getn(items)

    table.insert(items, {
        name = "GOTO_L",
        input = "button"
    })

    g_goto_l = table.getn(items)

    table.insert(items, {
        name = "GOTO_R",
        input = "button"
    })

    g_goto_r = table.getn(items)

    table.insert(items, {
        name = "PRE_COUNT",
        input = "button"
    })

    g_pre_count = table.getn(items)

    table.insert(items, {
        name = "Tempo",
        input = "value",
        output = "value",
        min = 0,
        max = 999
    })

    g_tempo = table.getn(items)

    table.insert(items, {
        name = "SPP",
        input = "value",
        output = "value",
        min = 0,
        max = 2147483646
    })

    g_song_pos = table.getn(items)

    table.insert(items, {
        name = "L Pos",
        input = "value",
        output = "value",
        min = 0,
        max = 2147483646
    })

    g_L_pos = table.getn(items)

    table.insert(items, {
        name = "R Pos",
        input = "value",
        output = "value",
        min = 0,
        max = 2147483646
    })

    g_R_pos = table.getn(items)

    table.insert(items, {
        name = "L Bar",
        output = "text"
    })

    g_L_bar = table.getn(items)

    table.insert(items, {
        name = "R Bar",
        output = "text"
    })

    g_R_bar = table.getn(items)

    table.insert(items, {
        name = "Track Name",
        output = "text"
    })

    g_track_name = table.getn(items)

    table.insert(items, {
        name = "Device",
        output = "text",
        modes = {"INST", "FX", "DRUM"}
    })

    g_device_name = table.getn(items)

    table.insert(items, {
        name = "Document",
        output = "text"
    })

    g_document_name = table.getn(items)

    remote.define_items(items)

    local inputs = {{
        pattern = "9? xx 00",
        name = "Keyboard",
        value = "0",
        note = "x",
        velocity = "64",
        port = g_keyboard_port
    }, {
        pattern = "8? xx 00",
        name = "Keyboard",
        value = "0",
        note = "x",
        velocity = "64",
        port = g_keyboard_port
    }, {
        pattern = "<100x>? yy zz",
        name = "Keyboard",
        port = g_keyboard_port
    }, {
        pattern = "e? xx yy",
        name = "Pitch Bend",
        value = "y*128 + x",
        port = g_keyboard_port
    }, {
        pattern = "b? 01 xx",
        name = "Modulation",
        port = g_keyboard_port
    }, {
        pattern = "b? 40 xx",
        name = "Damper Pedal",
        port = g_keyboard_port
    }, {
        pattern = "b? 0B xx",
        name = "Expression Pedal",
        port = g_keyboard_port
    }, {
        pattern = "D? xx ??",
        name = "Channel Pressure",
        port = g_keyboard_port
    }, {
        pattern = "C? xx",
        name = "Program Change",
        port = g_keyboard_port
    }, {
        pattern = "bf 65 ?<???x>",
        name = "CLICK",
        port = g_control_port
    }, {
        pattern = "bf 66 ?<???x>",
        name = "LOOP",
        port = g_control_port
    }, {
        pattern = "bf 67 ?<???x>",
        name = "REWIND",
        port = g_control_port
    }, {
        pattern = "bf 68 ?<???x>",
        name = "FORWARD",
        port = g_control_port
    }, {
        pattern = "bf 69 ?<???x>",
        name = "STOP",
        port = g_control_port
    }, {
        pattern = "bf 6a ?<???x>",
        name = "PLAY",
        port = g_control_port
    }, {
        pattern = "bf 6b ?<???x>",
        name = "RECORD",
        port = g_control_port
    }, {
        pattern = "b? 00 xx",
        name = "MIDI CC 0"
    }, {
        pattern = "b? 01 xx",
        name = "MIDI CC 1"
    }, {
        pattern = "b? 02 xx",
        name = "MIDI CC 2"
    }, {
        pattern = "b? 03 xx",
        name = "MIDI CC 3"
    }, {
        pattern = "b? 04 xx",
        name = "MIDI CC 4"
    }, {
        pattern = "b? 05 xx",
        name = "MIDI CC 5"
    }, {
        pattern = "b? 06 xx",
        name = "MIDI CC 6"
    }, {
        pattern = "b? 07 xx",
        name = "MIDI CC 7"
    }, {
        pattern = "b? 08 xx",
        name = "MIDI CC 8"
    }, {
        pattern = "b? 09 xx",
        name = "MIDI CC 9"
    }, {
        pattern = "b? 0a xx",
        name = "MIDI CC 10"
    }, {
        pattern = "b? 0b xx",
        name = "MIDI CC 11"
    }, {
        pattern = "b? 0c xx",
        name = "MIDI CC 12"
    }, {
        pattern = "b? 0d xx",
        name = "MIDI CC 13"
    }, {
        pattern = "b? 0e xx",
        name = "MIDI CC 14"
    }, {
        pattern = "b? 0f xx",
        name = "MIDI CC 15"
    }, {
        pattern = "b? 10 xx",
        name = "MIDI CC 16"
    }, {
        pattern = "b? 11 xx",
        name = "MIDI CC 17"
    }, {
        pattern = "b? 12 xx",
        name = "MIDI CC 18"
    }, {
        pattern = "b? 13 xx",
        name = "MIDI CC 19"
    }, {
        pattern = "b? 14 xx",
        name = "MIDI CC 20"
    }, {
        pattern = "b? 15 xx",
        name = "MIDI CC 21"
    }, {
        pattern = "b? 16 xx",
        name = "MIDI CC 22"
    }, {
        pattern = "b? 17 xx",
        name = "MIDI CC 23"
    }, {
        pattern = "b? 18 xx",
        name = "MIDI CC 24"
    }, {
        pattern = "b? 19 xx",
        name = "MIDI CC 25"
    }, {
        pattern = "b? 1a xx",
        name = "MIDI CC 26"
    }, {
        pattern = "b? 1b xx",
        name = "MIDI CC 27"
    }, {
        pattern = "b? 1c xx",
        name = "MIDI CC 28"
    }, {
        pattern = "b? 1d xx",
        name = "MIDI CC 29"
    }, {
        pattern = "b? 1e xx",
        name = "MIDI CC 30"
    }, {
        pattern = "b? 1f xx",
        name = "MIDI CC 31"
    }, {
        pattern = "b? 20 xx",
        name = "MIDI CC 32"
    }, {
        pattern = "b? 21 xx",
        name = "MIDI CC 33"
    }, {
        pattern = "b? 22 xx",
        name = "MIDI CC 34"
    }, {
        pattern = "b? 23 xx",
        name = "MIDI CC 35"
    }, {
        pattern = "b? 24 xx",
        name = "MIDI CC 36"
    }, {
        pattern = "b? 25 xx",
        name = "MIDI CC 37"
    }, {
        pattern = "b? 26 xx",
        name = "MIDI CC 38"
    }, {
        pattern = "b? 27 xx",
        name = "MIDI CC 39"
    }, {
        pattern = "b? 28 xx",
        name = "MIDI CC 40"
    }, {
        pattern = "b? 29 xx",
        name = "MIDI CC 41"
    }, {
        pattern = "b? 2a xx",
        name = "MIDI CC 42"
    }, {
        pattern = "b? 2b xx",
        name = "MIDI CC 43"
    }, {
        pattern = "b? 2c xx",
        name = "MIDI CC 44"
    }, {
        pattern = "b? 2d xx",
        name = "MIDI CC 45"
    }, {
        pattern = "b? 2e xx",
        name = "MIDI CC 46"
    }, {
        pattern = "b? 2f xx",
        name = "MIDI CC 47"
    }, {
        pattern = "b? 30 xx",
        name = "MIDI CC 48"
    }, {
        pattern = "b? 31 xx",
        name = "MIDI CC 49"
    }, {
        pattern = "b? 32 xx",
        name = "MIDI CC 50"
    }, {
        pattern = "b? 33 xx",
        name = "MIDI CC 51"
    }, {
        pattern = "b? 34 xx",
        name = "MIDI CC 52"
    }, {
        pattern = "b? 35 xx",
        name = "MIDI CC 53"
    }, {
        pattern = "b? 36 xx",
        name = "MIDI CC 54"
    }, {
        pattern = "b? 37 xx",
        name = "MIDI CC 55"
    }, {
        pattern = "b? 38 xx",
        name = "MIDI CC 56"
    }, {
        pattern = "b? 39 xx",
        name = "MIDI CC 57"
    }, {
        pattern = "b? 3a xx",
        name = "MIDI CC 58"
    }, {
        pattern = "b? 3b xx",
        name = "MIDI CC 59"
    }, {
        pattern = "b? 3c xx",
        name = "MIDI CC 60"
    }, {
        pattern = "b? 3d xx",
        name = "MIDI CC 61"
    }, {
        pattern = "b? 3e xx",
        name = "MIDI CC 62"
    }, {
        pattern = "b? 3f xx",
        name = "MIDI CC 63"
    }, {
        pattern = "b? 40 xx",
        name = "MIDI CC 64"
    }, {
        pattern = "b? 41 xx",
        name = "MIDI CC 65"
    }, {
        pattern = "b? 42 xx",
        name = "MIDI CC 66"
    }, {
        pattern = "b? 43 xx",
        name = "MIDI CC 67"
    }, {
        pattern = "b? 44 xx",
        name = "MIDI CC 68"
    }, {
        pattern = "b? 45 xx",
        name = "MIDI CC 69"
    }, {
        pattern = "b? 46 xx",
        name = "MIDI CC 70"
    }, {
        pattern = "b? 47 xx",
        name = "MIDI CC 71"
    }, {
        pattern = "b? 48 xx",
        name = "MIDI CC 72"
    }, {
        pattern = "b? 49 xx",
        name = "MIDI CC 73"
    }, {
        pattern = "b? 4a xx",
        name = "MIDI CC 74"
    }, {
        pattern = "b? 4b xx",
        name = "MIDI CC 75"
    }, {
        pattern = "b? 4c xx",
        name = "MIDI CC 76"
    }, {
        pattern = "b? 4d xx",
        name = "MIDI CC 77"
    }, {
        pattern = "b? 4e xx",
        name = "MIDI CC 78"
    }, {
        pattern = "b? 4f xx",
        name = "MIDI CC 79"
    }, {
        pattern = "b? 50 xx",
        name = "MIDI CC 80"
    }, {
        pattern = "b? 51 xx",
        name = "MIDI CC 81"
    }, {
        pattern = "b? 52 xx",
        name = "MIDI CC 82"
    }, {
        pattern = "b? 53 xx",
        name = "MIDI CC 83"
    }, {
        pattern = "b? 54 xx",
        name = "MIDI CC 84"
    }, {
        pattern = "b? 55 xx",
        name = "MIDI CC 85"
    }, {
        pattern = "b? 56 xx",
        name = "MIDI CC 86"
    }, {
        pattern = "b? 57 xx",
        name = "MIDI CC 87"
    }, {
        pattern = "b? 58 xx",
        name = "MIDI CC 88"
    }, {
        pattern = "b? 59 xx",
        name = "MIDI CC 89"
    }, {
        pattern = "b? 5a xx",
        name = "MIDI CC 90"
    }, {
        pattern = "b? 5b xx",
        name = "MIDI CC 91"
    }, {
        pattern = "b? 5c xx",
        name = "MIDI CC 92"
    }, {
        pattern = "b? 5d xx",
        name = "MIDI CC 93"
    }, {
        pattern = "b? 5e xx",
        name = "MIDI CC 94"
    }, {
        pattern = "b? 5f xx",
        name = "MIDI CC 95"
    }, {
        pattern = "b? 60 xx",
        name = "MIDI CC 96"
    }, {
        pattern = "b? 61 xx",
        name = "MIDI CC 97"
    }, {
        pattern = "b? 62 xx",
        name = "MIDI CC 98"
    }, {
        pattern = "b? 63 xx",
        name = "MIDI CC 99"
    }, {
        pattern = "b? 64 xx",
        name = "MIDI CC 100"
    }, {
        pattern = "b? 65 xx",
        name = "MIDI CC 101"
    }, {
        pattern = "b? 66 xx",
        name = "MIDI CC 102"
    }, {
        pattern = "b? 67 xx",
        name = "MIDI CC 103"
    }, {
        pattern = "b? 68 xx",
        name = "MIDI CC 104"
    }, {
        pattern = "b? 69 xx",
        name = "MIDI CC 105"
    }, {
        pattern = "b? 6a xx",
        name = "MIDI CC 106"
    }, {
        pattern = "b? 6b xx",
        name = "MIDI CC 107"
    }, {
        pattern = "b? 6c xx",
        name = "MIDI CC 108"
    }, {
        pattern = "b? 6d xx",
        name = "MIDI CC 109"
    }, {
        pattern = "b? 6e xx",
        name = "MIDI CC 110"
    }, {
        pattern = "b? 6f xx",
        name = "MIDI CC 111"
    }, {
        pattern = "b? 70 xx",
        name = "MIDI CC 112"
    }, {
        pattern = "b? 71 xx",
        name = "MIDI CC 113"
    }, {
        pattern = "b? 72 xx",
        name = "MIDI CC 114"
    }, {
        pattern = "b? 73 xx",
        name = "MIDI CC 115"
    }, {
        pattern = "b? 74 xx",
        name = "MIDI CC 116"
    }, {
        pattern = "b? 75 xx",
        name = "MIDI CC 117"
    }, {
        pattern = "b? 76 xx",
        name = "MIDI CC 118"
    }, {
        pattern = "b? 77 xx",
        name = "MIDI CC 119"
    }, {
        pattern = "b? 78 xx",
        name = "MIDI CC 120"
    }, {
        pattern = "b? 79 xx",
        name = "MIDI CC 121"
    }, {
        pattern = "b? 7a xx",
        name = "MIDI CC 122"
    }, {
        pattern = "b? 7b xx",
        name = "MIDI CC 123"
    }, {
        pattern = "b? 7c xx",
        name = "MIDI CC 124"
    }, {
        pattern = "b? 7d xx",
        name = "MIDI CC 125"
    }, {
        pattern = "b? 7e xx",
        name = "MIDI CC 126"
    }, {
        pattern = "b? 7f xx",
        name = "MIDI CC 127"
    }, {
        pattern = "bf 26 xx",
        name = "Fader 1"
    }, {
        pattern = "bf 27 xx",
        name = "Fader 2"
    }, {
        pattern = "bf 28 xx",
        name = "Fader 3"
    }, {
        pattern = "bf 29 xx",
        name = "Fader 4"
    }, {
        pattern = "bf 2a xx",
        name = "Fader 5"
    }, {
        pattern = "bf 2b xx",
        name = "Fader 6"
    }, {
        pattern = "bf 2c xx",
        name = "Fader 7"
    }, {
        pattern = "bf 2d xx",
        name = "Fader 8"
    }, {
        pattern = "bf 2e xx",
        name = "Fader 9"
    }, {
        pattern = "bf 2f xx",
        name = "Button 1"
    }, {
        pattern = "bf 30 xx",
        name = "Button 2"
    }, {
        pattern = "bf 31 xx",
        name = "Button 3"
    }, {
        pattern = "bf 32 xx",
        name = "Button 4"
    }, {
        pattern = "bf 33 xx",
        name = "Button 5"
    }, {
        pattern = "bf 34 xx",
        name = "Button 6"
    }, {
        pattern = "bf 35 xx",
        name = "Button 7"
    }, {
        pattern = "bf 36 xx",
        name = "Button 8"
    }, {
        pattern = "bf 37 xx",
        name = "Button 9"
    }, {
        pattern = "bf 38 xx",
        name = "Knob 1"
    }, {
        pattern = "bf 39 xx",
        name = "Knob 2"
    }, {
        pattern = "bf 3a xx",
        name = "Knob 3"
    }, {
        pattern = "bf 3b xx",
        name = "Knob 4"
    }, {
        pattern = "bf 3c xx",
        name = "Knob 5"
    }, {
        pattern = "bf 3d xx",
        name = "Knob 6"
    }, {
        pattern = "bf 3e xx",
        name = "Knob 7"
    }, {
        pattern = "bf 3f xx",
        name = "Knob 8"
    }, {
        pattern = "bf 6c ?<???x>",
        name = "Shift"
    }, {
        pattern = "bf 6d ?<???x>",
        name = "Track Down",
        port = g_control_port
    }, {
        pattern = "bf 6e ?<???x>",
        name = "Track Up",
        port = g_control_port
    }, {
        pattern = "bf 6f ?<???x>",
        name = "Patch Down",
        port = g_control_port
    }, {
        pattern = "bf 70 ?<???x>",
        name = "Patch Up",
        port = g_control_port
    }}

    remote.define_auto_inputs(inputs)

end

g_last_ctrl = nil
g_last_status = nil
ch16 = 191
ch1 = 176
gActiveMapping = false;
g_codec_disabled = true
kNumPads = 8
g_update_pad_colors = nil
g_pad_color_update_timer = nil
kNumMixChannels = 8
g_update_led_button_colors = nil
hdr = remote.make_midi("F0 00 01 77 7F")
hdr_sz = table.getn(hdr)

cmd = {
    set = 1,
    get = 2
}

tgt = {
    global = 5,
    display = 6,
    sal = 9
}

idx = {
    current = 0,
    reason = 1,
    ledBtns = 23
}

obj = {
    setup = 0,
    title = 1
}

glob_elm = {
    mix_null = 17,
    ins_null = 18,
    usb_set = 15
}

msg = {
    nm = 1,
    up = 2,
    dn = 3
}

ctrl_mutes = {}
cc_mutes = {}
muted = 0
low = -1
high = 1
SoftTakeOverWindow = 3
sysEx_event = nil
gLastMuteStatus = nil

local function mute_all_ctrls(group_changed)
    local start = 0
    local stop = g_num_instrument_ctrls

    for i = start, stop do
        if group_changed and i == g_last_ctrl then
            ctrl_mutes[i] = nil
        else
            ctrl_mutes[i] = muted
        end
    end
end

local function update_ctrl_mutes(status, ctrl, in_value)
    local remValue
    local ref_table

    if g_device == "Mixer" then
        if status == ch16 then
            remValue = remote.get_item_value(g_fader_first + ctrl)
            ref_table = ctrl_mutes
        end
    else
        if status == ch16 then
            remValue = ctrl_values[ctrl]
            ref_table = ctrl_mutes
        else
            remValue = cc_values[ctrl]
            ref_table = cc_mutes
        end
    end
    if not remValue or not ref_table then
        return
    end
    if not ref_table[ctrl] or ref_table[ctrl] == muted then
        if in_value > remValue + SoftTakeOverWindow then
            ref_table[ctrl] = high
        elseif in_value < remValue - SoftTakeOverWindow then
            ref_table[ctrl] = low
        else
            ref_table[ctrl] = nil
        end
    elseif ref_table[ctrl] == high then
        if in_value < remValue or (remValue == 0 and in_value == 0) then
            ref_table[ctrl] = nil
        end
    elseif ref_table[ctrl] == low then
        if in_value > remValue or (remValue == 127 and in_value == 127) then
            ref_table[ctrl] = nil
        end
    end
end

local function sysDisplaySoftTakeOverStatus(ctrl)
    local ref_table = {}
    if gDisableDisplayUpdates then
        return nil
    end
    start = 0
    stop = hdr_sz
    for i = start, stop do
        ref_table[i] = hdr[i]
    end
    table.insert(ref_table, cmd.set)
    table.insert(ref_table, tgt.display)
    table.insert(ref_table, idx.current)
    table.insert(ref_table, obj.title)
    table.insert(ref_table, 1)
    table.insert(ref_table, 1)
    if ctrl_mutes[ctrl] == high then
        table.insert(ref_table, msg.dn)
    elseif ctrl_mutes[ctrl] == low then
        table.insert(ref_table, msg.up)
    else
        table.insert(ref_table, msg.nm)
    end
    local checksum = 0
    stop = table.getn(ref_table) - hdr_sz
    for i = start, stop do
        checksum = checksum + ref_table[i + hdr_sz]
        if checksum > 127 then
            checksum = checksum - 128
        end
    end
    checksum = 128 - checksum
    if checksum == 128 then
        checksum = 0
    end
    table.insert(ref_table, checksum)
    table.insert(ref_table, 247)
    return ref_table
end

local function sysSetPadColor(update_all)
    local ref_table = {}
    start = 0
    stop = hdr_sz
    for i = start, stop do
        ref_table[i] = hdr[i]
    end
    table.insert(ref_table, cmd.set)
    table.insert(ref_table, tgt.display)
    table.insert(ref_table, idx.current)
    local found_something_to_update = false
    for i = 0, kNumPads - 1 do
        if update_all or (pad_colors[i] ~= pad_colors_last[i]) then
            table.insert(ref_table, 0)
            table.insert(ref_table, i + 1)
            table.insert(ref_table, 1)
            table.insert(ref_table, pad_colors[i])
            pad_colors_last[i] = pad_colors[i]
            found_something_to_update = true
        end
    end
    local checksum = 0
    stop = table.getn(ref_table) - hdr_sz
    for i = start, stop do
        checksum = checksum + ref_table[i + hdr_sz]
        if checksum > 127 then
            checksum = checksum - 128
        end
    end
    checksum = 128 - checksum
    if checksum == 128 then
        checksum = 0
    end
    table.insert(ref_table, checksum)
    table.insert(ref_table, 247)
    if found_something_to_update then
        return ref_table
    else
        return nil
    end
end

local function midiCCvalue(ch, d1, d2)
    local ref_table = {}
    table.insert(ref_table, 176 + ch - 1)
    table.insert(ref_table, d1)
    table.insert(ref_table, d2)
    return ref_table
end

local function midiNotevalue(ch, note, vel)
    local ref_table = {}
    table.insert(ref_table, 144 + ch - 1)
    table.insert(ref_table, note)
    table.insert(ref_table, vel)
    return ref_table
end

local function setDefaultUserLEDStatus(on)
    if on then
        if g_user_page_active then
            g_default_led_status_msg = midiCCvalue(16, 119, 0)
            g_user_led_status_msg = midiCCvalue(16, 119, 17)
        else
            g_default_led_status_msg = midiCCvalue(16, 119, 1)
            g_user_led_status_msg = midiCCvalue(16, 119, 16)
        end
    else
        g_default_led_status_msg = midiCCvalue(16, 119, 0)
        g_user_led_status_msg = midiCCvalue(16, 119, 16)
    end
    g_last_default_user_led_status = on
end

local function send_midi_pad_mode()
    if gPadMode then
        if gPadMode == pd_scenes then
            g_clips_led_status_msg = midiCCvalue(16, 117, 0)
            g_scenes_led_status_msg = midiCCvalue(16, 118, 127)
        elseif gPadMode == pd_clips then
            g_clips_led_status_msg = midiCCvalue(16, 117, 127)
            g_scenes_led_status_msg = midiCCvalue(16, 118, 0)
        else
            g_clips_led_status_msg = midiCCvalue(16, 117, 0)
            g_scenes_led_status_msg = midiCCvalue(16, 118, 0)
        end
    end
end

local function send_midi_pad_note_on(pad)
    local note
    local offset = gPadBank * kNumPads
    if pad <= (gPadBank * kNumPads) + kNumPads and pad >= (gPadBank * kNumPads) then
        pad = pad - (gPadBank * kNumPads)
    end
    if pad >= kNumPads then
        return
    end
    if pad == 0 then
        note = ntPad1
    end
    if pad == 1 then
        note = ntPad2
    end
    if pad == 2 then
        note = ntPad3
    end
    if pad == 3 then
        note = ntPad4
    end
    if pad == 4 then
        note = ntPad5
    end
    if pad == 5 then
        note = ntPad6
    end
    if pad == 6 then
        note = ntPad7
    end
    if pad == 7 then
        note = ntPad8
    end
    return midiNotevalue(16, note, pad_states[pad + offset])
end

local function send_led_button_state(btn)
    if btn >= kNumMixChannels then
        return
    end
    return midiCCvalue(16, ccButton1 + btn, led_button_states[btn])
end

local function sysDevInquiry()
    local ref_table = {}
    table.insert(ref_table, 240)
    table.insert(ref_table, 126)
    table.insert(ref_table, 127)
    table.insert(ref_table, 6)
    table.insert(ref_table, 1)
    table.insert(ref_table, 247)
    return ref_table
end

local function sysStartup(glob_elm, value)
    local ref_table = {}
    start = 0
    stop = hdr_sz
    for i = start, stop do
        ref_table[i] = hdr[i]
    end
    table.insert(ref_table, cmd.set)
    table.insert(ref_table, tgt.global)
    table.insert(ref_table, idx.current)
    table.insert(ref_table, obj.title)
    table.insert(ref_table, glob_elm)
    table.insert(ref_table, 1)
    table.insert(ref_table, value)
    local checksum = 0
    stop = table.getn(ref_table) - hdr_sz
    for i = start, stop do
        checksum = checksum + ref_table[i + hdr_sz]
        if checksum > 127 then
            checksum = checksum - 128
        end
    end
    checksum = 128 - checksum
    if checksum == 128 then
        checksum = 0
    end
    table.insert(ref_table, checksum)
    table.insert(ref_table, 247)
    return ref_table
end

gSalModeWasSet = nil

local function set_pads_sal_mode(on)
    if on then
        g_pads_in_sal_mode = true
        g_pad_color_update_timer = remote.get_time_ms()
    else
        g_pads_in_sal_mode = false
    end
    local ref_table = {}
    start = 0
    stop = hdr_sz
    for i = start, stop do
        ref_table[i] = hdr[i]
    end
    table.insert(ref_table, cmd.set)
    table.insert(ref_table, tgt.sal)
    table.insert(ref_table, idx.reason)
    table.insert(ref_table, 1)
    table.insert(ref_table, 0)
    table.insert(ref_table, 1)
    if on then
        table.insert(ref_table, 1)
    else
        table.insert(ref_table, 0)
    end
    local checksum = 0
    stop = table.getn(ref_table) - hdr_sz
    for i = start, stop do
        checksum = checksum + ref_table[i + hdr_sz]
        if checksum > 127 then
            checksum = checksum - 128
        end
    end
    checksum = 128 - checksum
    if checksum == 128 then
        checksum = 0
    end
    table.insert(ref_table, checksum)
    table.insert(ref_table, 247)
    gSalModeWasSet = remote.get_time_ms()
    return ref_table
end

local function resetPadColor()
    for i = 0, kNumPads - 1 do
        pad_colors[i] = padColor.off_yellow
        pad_colors_last[i] = padColor.off_yellow
    end
end

gPadShiftSent = false

local function displayPadShiftState()
    resetPadColor()
    if gPadBank == 0 then
        pad_colors[0] = padColor.green_yellow
        pad_colors[4] = padColor.red_yellow
    else
        pad_colors[0] = padColor.red_yellow
        pad_colors[4] = padColor.green_yellow
    end
    gPadShiftSent = true
end

gBeatsPerBar = 0
gLoopStart = 0
gLoopLength = 0
gLoopBank = 0
gLoopOffset = 0
g_loop_values = {}
gLoopR = 0
gLoopL = 0
g_update_R_locator = nil
kMaxLengthOfSong = 2147483646

local function calculate_beats_per_bar()
    if g_device == "Mixer" then
        return
    end
    local L_Bars = tonumber(remote.get_item_text_value(g_L_bar))
    local R_Bars = tonumber(remote.get_item_text_value(g_R_bar))
    local numBars
    if L_Bars > 1 then
        target = g_L_pos
        numBars = L_Bars - 1
    else
        target = g_R_pos
        numBars = R_Bars - 1
    end
    local numBeats = remote.get_item_value(target)
    gBeatsPerBar = math.floor(numBeats / numBars)
end

local function setup_loop_presets()
    if g_device == "Mixer" then
        return
    end
    calculate_beats_per_bar()
    start = 0
    stop = kNumPads - 1
    gLoopL = remote.get_item_value(g_L_pos)
    gLoopR = remote.get_item_value(g_R_pos)
    local numBeatsInALoopLength = gBeatsPerBar * gLoopLength
    for i = start, stop do
        local numBarsIntoTimeline = i * gBeatsPerBar * gLoopLength
        local one_loop = {}
        if gLoopStart + gLoopOffset + numBarsIntoTimeline > kMaxLengthOfSong then
            return
        end
        one_loop[0] = gLoopStart + gLoopOffset + numBarsIntoTimeline
        one_loop[1] = one_loop[0] + numBeatsInALoopLength
        g_loop_values[i] = one_loop
    end
end

local function initialize_loop_presets()
    gBeatsPerBar = 3840 * 16
    gLoopBank = 0
    gLoopOffset = 0
    gLoopStart = 0
    gLoopLength = 4
    setup_loop_presets()
end

local function update_loop_presets()
    gLoopStart = remote.get_item_value(g_L_pos)
    local R_pos = tonumber(remote.get_item_text_value(g_R_bar))
    local L_pos = tonumber(remote.get_item_text_value(g_L_bar))
    if R_pos < L_pos then
        return
    end
    if g_update_R_locator then
        R_pos = L_pos + gLoopLength
    end
    gLoopLength = R_pos - L_pos
    setup_loop_presets()
end

startup = false
port_setup = {}
mixer_null_off = {}
inst_null_off = {}
port_setup_sent = false
mixer_null_off_sent = false
inst_null_off_sent = false
gm_dev_inquiry_sent = false

local function clear_array(ref)
    local start = 0
    local stop = table.getn(ref)
    for i in pairs(ref) do
        ref[i] = 0
    end
end

local function null_array(ref)
    local start = 0
    local stop = table.getn(ref)
    for i in pairs(ref) do
        ref[i] = nil
    end
end

device_maps = {}
device_grabbed_default = {}
device_grabbed_user = {}
gLastDeviceName = ""

local function clear_grab()
    null_array(ctrl_grab)
    g_last_ctrl_for_learn = nil
    g_last_ctrl_grab = nil
end

local function set_parameter_targets_on_track_change()
    clear_grab()
    device_maps[gLastDeviceName] = {}
    device_grabbed_user[gLastDeviceName] = {}
    device_grabbed_default[gLastDeviceName] = {}
    for i = 0, table.getn(ctrl_targets) do
        device_maps[gLastDeviceName][i] = ctrl_targets[i]
    end
    for i = 0, g_knob_last - g_fader_first do
        device_grabbed_default[gLastDeviceName][i] = grabbed_ctrls[i]
    end
    for i = 0, 8 do
        device_grabbed_user[gLastDeviceName][i] = grabbed_user[i]
    end
    clear_array(ctrl_targets)
    null_array(grabbed_user)
    null_array(grabbed_ctrls)
    if device_maps[remote.get_item_text_value(g_device_name)] then
        grabbed_ctrls = device_grabbed_default[remote.get_item_text_value(g_device_name)]
        grabbed_user = device_grabbed_user[remote.get_item_text_value(g_device_name)]
        for i = 0, table.getn(ctrl_targets) do
            if grabbed_ctrls[i] then
                ctrl_targets[i] = grabbed_ctrls[i]
            else
                ctrl_targets[i] = remote.get_item_value(g_fader_first + i)
            end
        end
    else
        local stop = g_knob_last - g_fader_first
        for i = 0, stop do
            if remote.is_item_enabled(g_fader_first + i) then
                ctrl_targets[i] = remote.get_item_value(g_fader_first + i)
            end
        end
    end
    gLastDeviceName = remote.get_item_text_value(g_device_name)
end

function remote_probe(manufacturer, model, prober)
    local request_events = {remote.make_midi("F0 7E 7F 06 01 F7")}
    local response
    local response2
    if model == "Impact LX49+" or model == "Impact LX49+ Mixer Mode" then
        response = "F0 7E 7F 06 02 00 01 77 67 48 15 40 xx xx xx xx F7"
    elseif model == "Impact LX25+" or model == "Impact LX25+ Mixer Mode" then
        response = "F0 7E 7F 06 02 00 01 77 67 48 16 40 xx xx xx xx F7"
    elseif model == "Impact LX61+" or model == "Impact LX61+ Mixer Mode" then
        response = "F0 7E 7F 06 02 00 01 77 67 48 17 40 xx xx xx xx F7"
    elseif model == "Impact LX88+" or model == "Impact LX88+ Mixer Mode" then
        response = "F0 7E 7F 06 02 00 01 77 67 48 18 40 xx xx xx xx F7"
    elseif model == "Impact LXMini" then
        response = "F0 7E 7F 06 02 00 01 77 67 48 19 40 xx xx xx xx F7"
    elseif model == "Impact GX49" then
        response = "F0 7E 7F 06 02 00 01 77 67 48 33 40 xx xx xx xx F7"
    elseif model == "Impact GX61" then
        response = "F0 7E 7F 06 02 00 01 77 67 48 34 40 xx xx xx xx F7"
    elseif model == "SE49" then
        response = "F0 7E 7F 06 02 00 01 77 67 48 35 40 xx xx xx xx F7"
    elseif model == "SE61" then
        response = "F0 7E 7F 06 02 00 01 77 67 48 3A 40 xx xx xx xx F7"
    elseif model == "SE25" then
        response = "F0 7E 7F 06 02 00 01 77 67 48 06 40 xx xx xx xx F7"
        response2 = "F0 7E 7F 06 02 00 01 77 67 67 06 40 xx xx xx xx F7"
    elseif model == "Impact GXP49" then
        response = "F0 7E 7F 06 02 00 01 77 67 48 36 40 xx xx xx xx F7"
    elseif model == "Impact GXP61" then
        response = "F0 7E 7F 06 02 00 01 77 67 48 37 40 xx xx xx xx F7"
    elseif model == "Impact GXP88" then
        response = "F0 7E 7F 06 02 00 01 77 67 48 38 40 xx xx xx xx F7"
    elseif model == "Impact GXMini" then
        response = "F0 7E 7F 06 02 00 01 77 67 48 39 40 xx xx xx xx F7"
    end
    local function match_events(mask, events)
        for i, event in ipairs(events) do
            local res = remote.match_midi(mask, event)
            if res ~= nil then
                return true
            end
        end
        return false
    end
    results = {}
    ins = {}
    outs = {}
    local MidiOutPort
    for outPortIndex = 1, prober.out_ports do
        prober.midi_send_function(outPortIndex, request_events)
        prober.wait_function(50)
        for inPortIndex = 1, prober.in_ports do
            local events = prober.midi_receive_function(inPortIndex)
            if match_events(response, events) then
                table.insert(ins, inPortIndex)
                table.insert(outs, outPortIndex)
            end
            if model == "SE25" then
                if match_events(response2, events) then
                    table.insert(ins, inPortIndex)
                    table.insert(outs, outPortIndex)
                end
            end
        end
    end
    for i = 0, prober.out_ports do
        if outs[i] then
            if (model == "Impact GXP49" or model == "Impact GXP61" or model == "Impact GXP88") and outs[i + 1] then
                i = i + 1;
            end
            MidiOutPort = outs[i]
        end
    end
    if RunSecondScan and not MidiOutPort then
        for outPortIndex = 1, prober.out_ports do
            prober.midi_send_function(outPortIndex, request_events)
            prober.wait_function(50)
            for inPortIndex = 1, prober.in_ports do
                local events = prober.midi_receive_function(inPortIndex)
                if match_events(response, events) then
                    table.insert(ins, inPortIndex)
                    MidiOutPort = outPortIndex
                end
            end
        end
    end
    if ins[1] then
        local oneResult = {
            in_ports = {ins[table.getn(ins)], ins[table.getn(ins)] - 1},
            out_ports = {MidiOutPort}
        }
        table.insert(results, oneResult)
    end
    return results
end

function remote_prepare_for_use()
    local retEvents = {}
    startup = true
    return retEvents
end

function remote_release_from_use()
    local retEvents = {}
    if g_device ~= "Mixer" then
        g_clips_led_status_msg = midiCCvalue(16, 117, 0)
        g_scenes_led_status_msg = midiCCvalue(16, 118, 0)
        g_default_led_status_msg = midiCCvalue(16, 119, 0)
        g_user_led_status_msg = midiCCvalue(16, 119, 16)
        table.insert(retEvents, g_clips_led_status_msg)
        table.insert(retEvents, g_scenes_led_status_msg)
        table.insert(retEvents, g_default_led_status_msg)
        table.insert(retEvents, g_user_led_status_msg)
        if (not g_model_is_iX or g_model_is_lxmini) then
            local sysEx_event = set_pads_sal_mode(k_off)
            if sysEx_event then
                table.insert(retEvents, sysEx_event)
            end
        end
        local sysEx_event1 = sysStartup(glob_elm.usb_set, 0)
        if sysEx_event1 then
            table.insert(retEvents, sysEx_event1)
        end
    end
    return retEvents
end

ShiftMode = false
GrabMode = false
gInstrumentMode = false
gMixerMode = false
g_track_is_changing = nil
g_update_page_mappings = nil
drum_is_active = false
kCtrlPort = 1
kKeysPort = 2
just_knobs = true
gFirstShiftDone = false
g_last_ctrl_grab = nil
g_last_ctrl_for_learn = nil
g_last_input_time = 0
g_last_iX_fader_value = 0
g_user_page_active = false
g_default_led_status_msg = nil
g_user_led_status_msg = nil
g_clips_led_status_msg = nil
g_scenes_led_status_msg = nil
g_pads_in_sal_mode = false
g_pads_set_loop = false;
ctrl_values = {}
ctrl_targets = {}
ctrl_targets_last = {}
cc_values = {}
ctrl_grab = {}
grabbed_ctrls = {}
grabbed_user = {}
drum_triggers = {}
pad_drum_assignments = {}
pad_drum_volume = {}
pad_mutes = {}
pad_solos = {}
pad_states = {}
pad_states_last = {}
drum_pad_colors = {}
pad_colors = {}
pad_colors_last = {}
mixChannel_mutes = {}
mixChannel_solos = {}
led_button_colors = {}
led_button_colors_last = {}
led_button_states = {}
led_button_states_last = {}
gPadBank = 0
gPadBankLast = 0
gShiftTimer = nil
set_modifier_1 = nil
set_modifier_2 = nil
ccMixFader1 = 12
ccMixFader8 = 19
ccMixFader9 = 20
ccMixButton1 = 21
ccMixButton9 = 29
ccMixKnob1 = 30
ccMixKnob8 = 37
ccFader1 = 38
ccFader8 = 45
ccFader9 = 46
ccButton1 = 47
ccButton9 = 55
ccKnob1 = 56
ccKnob8 = 63
ccTransClick = 101
ccTransLoop = 102
ccTransRew = 103
ccTransFwd = 104
ccTransStop = 105
ccTransPlay = 106
ccTransRec = 107
ccShift = 108
ccTrackDown = 109
ccTrackUp = 110
ccPatchDown = 111
ccPatchUp = 112
ccDefaultUser = 119
ccClips = 117
ccScenes = 118
ccMixerMode = 113
ccInstMode = 114
ccUserMode = 115
ccS1 = -1
ccS2 = -1
ccS3 = -1
ntMsgCh1 = 144
ntMsgCh16 = 159
ntOffMsgCh1 = 128
ntOffMsgCh16 = 143
ntPad1 = 60
ntPad2 = 62
ntPad3 = 64
ntPad4 = 65
ntPad5 = 67
ntPad6 = 69
ntPad7 = 71
ntPad8 = 72
ntPad9 = 74
ntPad10 = 76
ntPad11 = 77
ntPad12 = 79
ntPad13 = 81
ntPad14 = 83
ntPad15 = 84
ntPad16 = 86

padColor = {
    off_yellow = 0,
    red_yellow = 1,
    green_yellow = 2,
    off_green = 3,
    red_green = 4,
    yellow_green = 5,
    off_red = 6,
    green_red = 7,
    yellow_red = 8,
    orange_yellow = 9,
    orange_green = 10,
    orange_red = 11,
    off_orange = 12,
    red_orange = 13,
    green_orange = 14,
    yellow_orange = 15
}

pd_notes = 0
pd_mute = 1
pd_solo = 2
pd_steps = 3
pd_clips = 4
pd_scenes = 5
gPadMode = pd_notes
gPadModeLast = nil
gLastActiveScene = 0
btnMode = pd_mute
sysex = 240
k_on = 1
k_off = nil
g_last_default_user_led_status = k_off

local function currentTempo()
    return remote.get_item_value(g_tempo)
end

local function isPlaying()
    if remote.get_item_value(g_trans_first + 5) > 0 then
        return true
    else
        return false
    end
end

local function isRecording()
    if remote.get_item_value(g_trans_last) > 0 then
        return true
    else
        return false
    end
end

local function isLooping()
    if remote.get_item_value(g_trans_first + 1) > 0 then
        return true
    else
        return false
    end
end

function remote_process_midi(event)
    local status = event[1]
    local ctrl = event[2]
    local value = event[3]
    if status == sysex then
        if g_codec_disabled then
            if event[6] == 0 and event[7] == 1 and event[8] == 119 then
                g_codec_disabled = false
            end
            return true
        end
        if event[2] == 126 and event[3] == 127 and event[4] == 6 and event[5] == 2 then
            if g_update_R_locator then
                g_update_R_locator = nil
                local msg = {
                    time_stamp = event.time_stamp,
                    item = g_R_pos,
                    value = gLoopR
                }
                remote.handle_input(msg)
            end
        end
    end
    if g_codec_disabled then
        return true
    end
    if ShiftMode then
        if ctrl ~= ccShift then
            clear_grab()
            GrabMode = false
        end
        if g_device == "Mixer" then
            if ctrl == ccMixButton1 then
                if value > 0 then
                    local msg = {
                        time_stamp = event.time_stamp,
                        item = g_bank_down,
                        value = 1
                    }
                    remote.handle_input(msg)
                    return true
                end
            elseif ctrl == ccMixButton1 + 1 then
                if value > 0 then
                    local msg = {
                        time_stamp = event.time_stamp,
                        item = g_bank_up,
                        value = 1
                    }
                    remote.handle_input(msg)
                    return true
                end
            end
        end
    end
    if g_device ~= "Mixer" then
        if set_modifier_1 then
            local msg = {
                time_stamp = event.time_stamp,
                item = g_mod1_first + set_modifier_1,
                value = 1
            }
            remote.handle_input(msg)
            set_modifier_1 = nil
        end
        if set_modifier_2 then
            local msg = {
                time_stamp = event.time_stamp,
                item = g_mod2_first + set_modifier_2,
                value = 1
            }
            remote.handle_input(msg)
            set_modifier_2 = nil
        end
        if event.port == kCtrlPort and ctrl == ccScenes then
            if value == 0 then
                return true
            end
            if not gFirstShiftDone then
                gFirstShiftDone = true
            end
            if ShiftMode then
                gLoopBank = 0
                gLoopOffset = 0
                gLastActiveScene = 0
                update_loop_presets()
                if gPadMode == pd_scenes then
                    return true
                end
            end
            if gPadMode == pd_scenes then
                gPadMode = pd_notes
                resetPadColor()
                if (not g_model_is_iX or g_model_is_lxmini) and not drum_is_active then
                    sysEx_event = set_pads_sal_mode(k_off)
                end
            else
                calculate_beats_per_bar()
                resetPadColor()
                gPadMode = pd_scenes;
                if (not g_model_is_iX or g_model_is_lxmini) and not g_pads_in_sal_mode then
                    sysEx_event = set_pads_sal_mode(k_on)
                end
                if not g_loop_values[0] or g_loop_values[0][0] == g_loop_values[0][1] then
                    initialize_loop_presets()
                else
                    setup_loop_presets()
                end
            end
        end
        if event.port == kCtrlPort and status == ntMsgCh16 then
            local pad_note = 0
            if gPadMode == pd_scenes then
                if value == 0 then
                    return true
                end
                if ctrl == ntPad1 then
                    pad_note = 0
                end
                if ctrl == ntPad2 then
                    pad_note = 1
                end
                if ctrl == ntPad3 then
                    pad_note = 2
                end
                if ctrl == ntPad4 then
                    pad_note = 3
                end
                if ctrl == ntPad5 then
                    pad_note = 4
                end
                if ctrl == ntPad6 then
                    pad_note = 5
                end
                if ctrl == ntPad7 then
                    pad_note = 6
                end
                if ctrl == ntPad8 then
                    pad_note = 7
                end
                local L_pos
                local R_pos
                if ShiftMode then
                    gLoopOffset = pad_note * kNumPads * gLoopLength * gBeatsPerBar
                    gLoopBank = pad_note
                    setup_loop_presets()
                    return true
                end
                calculate_beats_per_bar()
                if not g_loop_values[pad_note] then
                    gLastActiveScene = pad_note
                    return true
                end
                L_pos = g_loop_values[pad_note][0]
                R_pos = g_loop_values[pad_note][1]
                if L_pos then
                    gLoopL = L_pos
                    local msg = {
                        time_stamp = event.time_stamp,
                        item = g_L_pos,
                        value = gLoopL
                    }
                    remote.handle_input(msg)
                end
                if R_pos then
                    gLoopR = R_pos
                    local val = gLoopR
                    local spp = math.floor(remote.get_item_value(g_song_pos) / gBeatsPerBar + 1.0) * gBeatsPerBar
                    if isPlaying() then
                        val = spp
                        g_update_R_locator = remote.get_time_ms()
                    end
                    local msg = {
                        time_stamp = event.time_stamp,
                        item = g_R_pos,
                        value = val
                    }
                    remote.handle_input(msg)
                end
                if not isLooping() then
                    local msg = {
                        time_stamp = event.time_stamp,
                        item = g_trans_first + 1,
                        value = 1
                    }
                    remote.handle_input(msg)
                end
                if not isPlaying() then
                    local msg = {
                        time_stamp = event.time_stamp,
                        item = g_song_pos,
                        value = gLoopL
                    }
                    remote.handle_input(msg)
                    local msg = {
                        time_stamp = event.time_stamp,
                        item = g_trans_first + 5,
                        value = 1
                    }
                    remote.handle_input(msg)
                end
                gLastActiveScene = pad_note
                return true
            end
        end
    end
    if drum_is_active then
        if event.port == kCtrlPort and status == ntMsgCh16 then
            local pad_note = nil
            local offset = gPadBank * 8
            if ShiftMode then
                if ctrl == ntPad1 then
                    gPadBank = 0
                    gPadShiftSent = false
                end
                if ctrl == ntPad5 then
                    gPadBank = 1
                    gPadShiftSent = false
                end
                return true
            end
            if ctrl == ntPad1 then
                pad_note = 0
            end
            if ctrl == ntPad2 then
                pad_note = 1
            end
            if ctrl == ntPad3 then
                pad_note = 2
            end
            if ctrl == ntPad4 then
                pad_note = 3
            end
            if ctrl == ntPad5 then
                pad_note = 4
            end
            if ctrl == ntPad6 then
                pad_note = 5
            end
            if ctrl == ntPad7 then
                pad_note = 6
            end
            if ctrl == ntPad8 then
                pad_note = 7
            end
            if remote.get_item_mode(g_pad_first + pad_note) == 1 then
                if value == 0 then
                    return true
                end
                local id = g_inst_ctrl_first + remote.get_item_value(g_pad_first + pad_note)
                local val = 0
                if remote.get_item_value(id) == 0 then
                    val = 127
                end
                local msg = {
                    time_stamp = event.time_stamp,
                    item = id,
                    value = val
                }
                remote.handle_input(msg)
                return true
            end
            if gPadMode == pd_notes then
                if ctrl == ntPad1 then
                    pad_note = drum_triggers[0 + offset]
                end
                if ctrl == ntPad2 then
                    pad_note = drum_triggers[1 + offset]
                end
                if ctrl == ntPad3 then
                    pad_note = drum_triggers[2 + offset]
                end
                if ctrl == ntPad4 then
                    pad_note = drum_triggers[3 + offset]
                end
                if ctrl == ntPad5 then
                    pad_note = drum_triggers[4 + offset]
                end
                if ctrl == ntPad6 then
                    pad_note = drum_triggers[5 + offset]
                end
                if ctrl == ntPad7 then
                    pad_note = drum_triggers[6 + offset]
                end
                if ctrl == ntPad8 then
                    pad_note = drum_triggers[7 + offset]
                end
                local msg = {
                    time_stamp = event.time_stamp,
                    item = 1,
                    value = 1,
                    note = pad_note,
                    velocity = event[3]
                }
                remote.handle_input(msg)
                ctrl = pad_note
            elseif gPadMode == pd_solo or gPadMode == pd_mute then
                if value == 0 then
                    return true
                end
                local tgt = remote.get_item_value(g_pad_mute_first + pad_note + offset)
                local state = pad_mutes[pad_note + offset]
                if gPadMode == pd_solo then
                    tgt = remote.get_item_value(g_pad_solo_first + pad_note + offset)
                    state = pad_solos[pad_note + offset]
                end
                if state > 0 then
                    state = 0
                else
                    state = 127
                end
                local msg = {
                    time_stamp = event.time_stamp,
                    item = g_inst_ctrl_first + tgt,
                    value = state
                }
                remote.handle_input(msg)
                return true
            end
        end
        if (status >= ntMsgCh1 and status <= ntMsgCh16 and value == 0) or
            (status >= ntOffMsgCh1 and status <= ntOffMsgCh16) then
            start = 0
            stop = 16
            for i = start, stop do
                if drum_triggers[i] then
                    if remote.get_item_text_value(g_device_name) == "Kong" then
                        local first_note_in_group = 60 + (3 * i)
                        if ctrl >= first_note_in_group and ctrl < first_note_in_group + 3 then
                            ctrl = drum_triggers[i]
                        end
                    end
                    if ctrl == drum_triggers[i] then
                        local drum = i
                        if pad_drum_assignments[i] then
                            drum = pad_drum_assignments[i]
                        end
                        local msg = {
                            time_stamp = event.time_stamp,
                            item = g_drum_first + drum,
                            value = 1
                        }
                        remote.handle_input(msg)
                        if last_active_drum ~= drum then
                            mute_all_ctrls(true)
                        end
                        last_active_drum = drum
                    end
                end
            end
        end
    end
    if status < ch1 or status > ch16 then
        return false
    end
    if ctrl == 1 or ctrl == 64 then
        local mode
        if ctrl == 1 then
            if remote.get_item_mode(3) > 1 then
                local msg = {
                    time_stamp = event.time_stamp,
                    item = g_inst_ctrl_first + remote.get_item_value(3),
                    value = value
                }
                remote.handle_input(msg)
                return true
            else
                return false
            end
        else
            if remote.get_item_mode(4) < 1 then
                local msg = {
                    time_stamp = event.time_stamp,
                    item = g_inst_ctrl_first + remote.get_item_value(4),
                    value = value
                }
                remote.handle_input(msg)
                return true
            else
                return false
            end
        end
    end
    local input_item
    g_last_input_time = remote.get_time_ms()
    g_last_status = status
    if status == ch16 then
        if (not g_model_is_iX or g_model_is_lxmini) and ctrl == ccUserMode and value > 0 then
            mute_all_ctrls()
        end
        if ctrl == ccDefaultUser then
            if g_device ~= "Mixer" and value > 0 then
                if gInstrumentMode then
                    if g_user_page_active then
                        local msg = {
                            time_stamp = event.time_stamp,
                            item = g_default,
                            value = 1
                        }
                        remote.handle_input(msg)
                        g_user_page_active = false
                    else
                        if not drum_is_active then
                            local msg = {
                                time_stamp = event.time_stamp,
                                item = g_user,
                                value = 1
                            }
                            remote.handle_input(msg)
                            g_user_page_active = true
                        end
                    end
                    setDefaultUserLEDStatus(k_on)
                end
            end
        end
        if ctrl == ccS1 or ctrl == ccS2 or ctrl == ccS3 then
            if value == 0 then
                return true
            end
            if ctrl == ccS1 then
                index = g_track_mute
            end
            if ctrl == ccS2 then
                index = g_track_solo
            end
            if ctrl == ccS3 then
                index = g_track_auto
            end
            local msg = {
                time_stamp = event.time_stamp,
                item = index,
                value = 1
            }
            remote.handle_input(msg)
            return true
        end
        if ctrl == ccMixerMode or ctrl == ccInstMode or ctrl == ccUserMode then
            if g_device ~= "Mixer" then
                if ShiftMode then
                    if value == 0 then
                        return true
                    end
                    if ctrl == ccInstMode then
                        local msg = {
                            time_stamp = event.time_stamp,
                            item = g_plugin_view,
                            value = 1
                        }
                        remote.handle_input(msg)
                    end
                else
                    if ctrl == ccInstMode then
                        setDefaultUserLEDStatus(k_on)
                    else
                        setDefaultUserLEDStatus(k_off)
                    end
                end
            end
            if ctrl == ccInstMode then
                gInstrumentMode = true
            else
                gInstrumentMode = false
            end
            if ctrl == ccMixerMode then
                gMixerMode = true
            else
                gMixerMode = false
            end
        end
        if ctrl == ccShift then
            if value > 0 then
                local now_ms = remote.get_time_ms()
                if gShiftTimer and now_ms - gShiftTimer < 500 then
                    null_array(grabbed_user)
                    null_array(grabbed_ctrls)
                    for i = 0, g_knob_last - g_fader_first do
                        ctrl_targets[i] = remote.get_item_value(g_fader_first + i)
                    end
                end
                gShiftTimer = remote.get_time_ms()
                ShiftMode = true
                gPadShiftSent = false
                if not gFirstShiftDone then
                    initialize_loop_presets()
                    gFirstShiftDone = true
                end
            else
                mute_all_ctrls()
                ShiftMode = false
            end
            if g_device ~= "Mixer" then
                if value > 0 then
                    if not isPlaying() then
                        clear_grab()
                        GrabMode = true
                    end
                else
                    GrabMode = false
                end
            end
            return true
        end
        if ctrl > ccShift and ctrl <= ccPatchUp then
            if g_device ~= "Mixer" then
                if value > 0 then
                    local msg = {
                        time_stamp = event.time_stamp,
                        item = ctrl - ccShift + g_func_first,
                        value = 1
                    }
                    remote.handle_input(msg)
                end
            end
            return true
        elseif ctrl >= ccTransClick and ctrl <= ccTransRec then
            if g_device ~= "Mixer" then
                if not g_model_is_iX and (ctrl == ccTransRew or ctrl == ccTransFwd) then
                    if ShiftMode then
                        if value == 0 then
                            return true
                        end
                        local spp = math.floor(remote.get_item_value(g_song_pos) / gBeatsPerBar + 0.5) * gBeatsPerBar
                        local msg = {
                            time_stamp = event.time_stamp,
                            item = g_song_pos,
                            value = spp
                        }
                        remote.handle_input(msg)
                        local index = ctrl - ccTransRew + g_L_pos
                        local msg = {
                            time_stamp = event.time_stamp,
                            item = index,
                            value = spp
                        }
                        remote.handle_input(msg)
                        return true
                    end
                end
                if g_model_is_iX then
                    if ShiftMode then
                        if value == 0 then
                            return true
                        end
                        if ctrl == ccTransLoop or ctrl == ccTransStop then
                            local spp = math.floor(remote.get_item_value(g_song_pos) / gBeatsPerBar + 0.5) *
                                            gBeatsPerBar
                            local msg = {
                                time_stamp = event.time_stamp,
                                item = g_song_pos,
                                value = spp
                            }
                            remote.handle_input(msg)
                            local index = g_L_pos
                            if ctrl == ccTransStop then
                                index = g_R_pos
                            end
                            local msg = {
                                time_stamp = event.time_stamp,
                                item = index,
                                value = spp
                            }
                            remote.handle_input(msg)
                        elseif ctrl == ccTransClick then
                            local msg = {
                                time_stamp = event.time_stamp,
                                item = g_undo,
                                value = 1
                            }
                            remote.handle_input(msg)
                        elseif ctrl == ccTransRew then
                            local msg = {
                                time_stamp = event.time_stamp,
                                item = g_goto_l,
                                value = 1
                            }
                            remote.handle_input(msg)
                        elseif ctrl == ccTransFwd then
                            local msg = {
                                time_stamp = event.time_stamp,
                                item = g_goto_r,
                                value = 1
                            }
                            remote.handle_input(msg)
                        elseif ctrl == ccTransPlay then
                            local msg = {
                                time_stamp = event.time_stamp,
                                item = g_pre_count,
                                value = 1
                            }
                            remote.handle_input(msg)
                        elseif ctrl == ccTransRec then
                            local msg = {
                                time_stamp = event.time_stamp,
                                item = g_qrec,
                                value = 1
                            }
                            remote.handle_input(msg)
                        end
                        return true
                    end
                end
                if ctrl == ccTransLoop and value > 0 then
                    if ShiftMode then
                        local msg = {
                            time_stamp = event.time_stamp,
                            item = g_goto_l,
                            value = 1
                        }
                        remote.handle_input(msg)
                        return true
                    end
                end
                if ctrl == ccTransStop and value > 0 then
                    if ShiftMode then
                        local msg = {
                            time_stamp = event.time_stamp,
                            item = g_undo,
                            value = 1
                        }
                        remote.handle_input(msg)
                        return true
                    end
                end
                if ctrl == ccTransPlay and value > 0 then
                    if ShiftMode then
                        local msg = {
                            time_stamp = event.time_stamp,
                            item = g_trans_first,
                            value = 1
                        }
                        remote.handle_input(msg)
                        return true
                    else
                        if isPlaying() then
                            local msg = {
                                time_stamp = event.time_stamp,
                                item = g_trans_first + 4,
                                value = 1
                            }
                            remote.handle_input(msg)
                            return true
                        end
                    end
                end
                if ctrl == ccTransRec and value > 0 then
                    if ShiftMode then
                        local msg = {
                            time_stamp = event.time_stamp,
                            item = g_qrec,
                            value = 1
                        }
                        remote.handle_input(msg)
                        return true
                    end
                end
                return false
            end
            return true
        end
        if g_device ~= "Mixer" then
            if g_model_is_iX then
                if ctrl == ccFader9 then
                    ctrl = ccMixFader9
                end
                if ctrl == ccMixFader9 then
                    ctrl = ccFader9
                end
            end
            input_item = ctrl - ccFader1
            if ctrl >= ccFader1 and ctrl <= ccKnob8 then
                if not g_last_default_user_led_status then
                    setDefaultUserLEDStatus(k_on)
                end
                if ctrl_grab[1] and input_item ~= g_last_ctrl_grab then
                    ctrl_targets[input_item] = ctrl_grab[1]
                    table.remove(ctrl_grab, 1)
                    g_last_ctrl_grab = input_item
                    if g_user_page_active and ctrl >= ccKnob1 then
                        grabbed_user[ctrl - ccKnob1] = ctrl_targets[input_item]
                    else
                        grabbed_ctrls[input_item] = ctrl_targets[input_item]
                    end
                    return true
                end
                if g_model_is_iX and ctrl == ccFader9 then
                    g_last_iX_fader_value = value
                end
                if drum_is_active then
                    if not grabbed_ctrls[input_item] then
                        local offset = gPadBank * kNumPads
                        if ctrl >= ccFader1 and ctrl <= ccFader8 and
                            remote.get_item_mode(g_fader_first + ctrl - ccFader1) == 3 then
                            local drum_vol = pad_drum_volume[input_item + offset]
                            if remote.get_item_text_value(g_device_name) == "Kong" then
                                drum_vol = 12 + 29 * pad_drum_assignments[input_item + offset]
                                if pad_drum_assignments[input_item + offset] == pad_drum_assignments[g_last_drum_fader] and
                                    g_last_drum_fader ~= input_item + offset then
                                    ctrl_mutes[drum_vol] = muted
                                end
                            else
                                if drum_vol and g_last_drum_fader ~= input_item + offset then
                                    ctrl_mutes[drum_vol] = muted
                                end
                            end
                            ctrl_targets[input_item] = drum_vol
                            g_last_drum_fader = input_item + offset
                        end
                        if ctrl == ccButton9 and remote.get_item_mode(g_button_first + ctrl - ccButton1) == 5 then
                            if value > 0 then
                                btnMode = pd_solo
                            else
                                btnMode = pd_mute
                            end
                            return true
                        end
                        if ctrl >= ccButton1 and ctrl < ccButton9 and
                            remote.get_item_mode(g_button_first + ctrl - ccButton1) == 5 then
                            if value > 0 then
                                local pad_note = ctrl - ccButton1
                                local mode = remote.get_item_mode(g_button_first + ctrl - ccButton1)
                                local tgt = remote.get_item_value(g_pad_mute_first + pad_note + offset)
                                local state = pad_mutes[pad_note + offset]
                                if btnMode == pd_solo then
                                    tgt = remote.get_item_value(g_pad_solo_first + pad_note + offset)
                                    state = pad_solos[pad_note + offset]
                                end
                                if state > 0 then
                                    state = 0
                                else
                                    state = 127
                                end
                                local msg = {
                                    time_stamp = event.time_stamp,
                                    item = g_inst_ctrl_first + tgt,
                                    value = state
                                }
                                remote.handle_input(msg)
                            end
                            return true
                        end
                    end
                end
                if ctrl >= ccButton1 and ctrl <= ccButton9 then
                    if not grabbed_ctrls[input_item] then
                        local mode = remote.get_item_mode(g_button_first + ctrl - ccButton1)
                        if mode == 6 then
                            local id = g_inst_ctrl_first + remote.get_item_value(g_button_first + ctrl - ccButton1)
                            local val = 0
                            if remote.get_item_value(id) == 0 then
                                val = 127
                            end
                            local msg = {
                                time_stamp = event.time_stamp,
                                item = id,
                                value = val
                            }
                            remote.handle_input(msg)
                            return true
                        end
                        if mode == 2 then
                            if value > 0 then
                                local msg = {
                                    time_stamp = event.time_stamp,
                                    item = g_group_first + ctrl - ccButton1,
                                    value = 1
                                }
                                remote.handle_input(msg)
                            end
                            mute_all_ctrls()
                            return true
                        end
                    end
                end
                ctrl = ctrl_targets[input_item]
                if not ctrl then
                    return true
                end
                if ctrl_mutes[ctrl] then
                    update_ctrl_mutes(status, ctrl, value)
                end
                if event[2] < ccButton1 or event[2] > ccButton9 then
                    if ctrl_mutes[ctrl] then
                        if ctrl_mutes[ctrl] ~= gLastMuteStatus or ctrl ~= g_last_ctrl then
                            if (gActiveMapping) then
                                sysEx_event = sysDisplaySoftTakeOverStatus(ctrl)
                                gLastMuteStatus = ctrl_mutes[ctrl]
                            end
                        end
                        return true
                    else
                        if gActiveMapping and gLastMuteStatus then
                            sysEx_event = sysDisplaySoftTakeOverStatus(ctrl)
                            gLastMuteStatus = ctrl_mutes[ctrl]
                        end
                    end
                end
                g_last_ctrl = ctrl
                local item_index = g_inst_ctrl_first + ctrl
                if input_item + g_fader_first >= g_button_first and input_item + g_fader_first <= g_button_last then
                    if remote.get_item_mode(g_inst_ctrl_first + ctrl) == 2 then
                        local msg = {
                            time_stamp = event.time_stamp,
                            item = item_index,
                            value = value
                        }
                        remote.handle_input(msg)
                        return true
                    end
                    if value == 0 then
                        return true
                    else
                        if remote.get_item_value(item_index) > 0 then
                            value = 0
                        end
                    end
                end
                local msg = {
                    time_stamp = event.time_stamp,
                    item = item_index,
                    value = value
                }
                remote.handle_input(msg)
                return true
            elseif ctrl >= ccMixFader1 and ctrl <= ccMixKnob8 then
                ctrl = ctrl_targets[ctrl - ccMixFader1]
                if ctrl then
                    ctrl_mutes[ctrl] = muted
                end
                return true
            end
        end
        if g_device == "Mixer" then
            if ctrl == ccMixButton9 then
                mute_all_ctrls()
            end
            if ctrl >= ccMixFader1 and ctrl <= ccMixKnob8 then
                input_item = ctrl - ccMixFader1 + g_fader_first
                ctrl = ctrl - ccMixFader1
                if input_item >= g_button_first and input_item <= g_button_last then
                    if input_item < g_button_last and value == 0 then
                        return true
                    end
                    if input_item == g_button_last then
                        if value > 0 then
                            btnMode = pd_solo
                        else
                            btnMode = pd_mute
                        end
                        return true
                    end
                    if remote.get_item_mode(input_item) > 1 then
                        local tgt = g_mute_first
                        if btnMode == pd_solo then
                            tgt = g_solo_first
                        end
                        tgt = tgt + input_item - g_button_first
                        local msg = {
                            time_stamp = event.time_stamp,
                            item = tgt,
                            value = 1
                        }
                        remote.handle_input(msg)
                    else
                        local msg = {
                            time_stamp = event.time_stamp,
                            item = input_item,
                            value = 1
                        }
                        remote.handle_input(msg)
                    end
                    return true
                end
                if ctrl_mutes[ctrl] then
                    update_ctrl_mutes(status, ctrl, value)
                end
                if ctrl_mutes[ctrl] then
                    if ctrl_mutes[ctrl] ~= gLastMuteStatus or ctrl ~= g_last_ctrl then
                        sysEx_event = sysDisplaySoftTakeOverStatus(ctrl)
                        gLastMuteStatus = ctrl_mutes[ctrl]
                    end
                    return true
                else
                    if gLastMuteStatus then
                        sysEx_event = sysDisplaySoftTakeOverStatus(ctrl)
                        gLastMuteStatus = ctrl_mutes[ctrl]
                    end
                end
                g_last_ctrl = ctrl
                local msg = {
                    time_stamp = event.time_stamp,
                    item = input_item,
                    value = value
                }
                remote.handle_input(msg)
                return true
            elseif ctrl >= ccFader1 and ctrl <= ccKnob8 then
                ctrl = ctrl - ccFader1
                ctrl_mutes[ctrl] = muted
                return true
            else
                return true
            end
        end
    else
        if g_device == "Mixer" then
            return true
        end
        if cc_mutes[ctrl] then
            update_ctrl_mutes(status, ctrl, value)
        end
        if cc_mutes[ctrl] then
            return true
        end
        return false
    end
end

function remote_set_state(changed_items)
    for i, item_index in ipairs(changed_items) do
        if g_device ~= "Mixer" then
            if item_index >= g_inst_ctrl_first and item_index <= g_inst_ctrl_last then
                local ctrl_item = item_index - g_inst_ctrl_first
                ctrl_values[ctrl_item] = remote.get_item_value(item_index)
                if GrabMode then
                    if ctrl_item ~= g_last_ctrl_for_learn then
                        table.insert(ctrl_grab, ctrl_item)
                        g_last_ctrl_for_learn = ctrl_item
                        gSendShiftCCForGrab = true
                    end
                else
                    local now_ms = remote.get_time_ms()
                    if ctrl_item ~= g_last_ctrl or now_ms - g_last_input_time > 100 then
                        if now_ms - g_last_input_time > 100 then
                            ctrl_mutes[ctrl_item] = muted
                            if g_model_is_iX then
                                if ctrl_item == ctrl_targets[g_fader_last - g_fader_first] then
                                    update_ctrl_mutes(ch16, ctrl_targets[g_fader_last - g_fader_first],
                                        g_last_iX_fader_value)
                                    if ctrl_mutes[ctrl_targets[g_fader_last - g_fader_first]] ~= gLastMuteStatus then
                                        sysEx_event = sysDisplaySoftTakeOverStatus(ctrl_targets[g_fader_last -
                                                                                       g_fader_first])
                                        gLastMuteStatus = ctrl_mutes[ctrl_targets[g_fader_last - g_fader_first]]
                                    end
                                end
                            end
                        end
                    end
                end
                if remote.is_item_enabled(item_index) then
                    local start = 0
                    local stop = g_pad_drum_last - g_pad_drum_first
                    for i = start, stop do
                        if remote.is_item_enabled(g_pad_drum_first + i) and remote.get_item_value(g_pad_drum_first + i) ==
                            ctrl_item then
                            pad_drum_assignments[i] = tonumber(remote.get_item_text_value(item_index))
                        end
                        if remote.is_item_enabled(g_pad_mute_first + i) and remote.get_item_value(g_pad_mute_first + i) ==
                            ctrl_item then
                            pad_mutes[i] = remote.get_item_value(item_index)
                        end
                        if remote.is_item_enabled(g_pad_solo_first + i) and remote.get_item_value(g_pad_solo_first + i) ==
                            ctrl_item then
                            pad_solos[i] = remote.get_item_value(item_index)
                        end
                        if remote.is_item_enabled(g_pad_first + i) and remote.get_item_value(g_pad_first + i) ==
                            ctrl_item then
                            pad_states[i] = remote.get_item_value(item_index)
                        end
                    end
                end
                local start = 0
                local stop = g_button_last - g_button_first
                for i = start, stop do
                    if remote.is_item_enabled(g_button_first + i) and remote.get_item_value(g_button_first + i) ==
                        ctrl_item then
                        local mode = remote.get_item_mode(g_button_first + i)
                        if mode == 3 or mode == 4 then
                            local value = remote.get_item_value(item_index)
                            if value > 0 then
                                value = 1
                            end
                            if mode == 3 then
                                set_modifier_1 = value
                            else
                                set_modifier_2 = value
                            end
                        end
                    end
                end
            elseif item_index >= g_pad_first and item_index <= g_pad_last then
                if remote.is_item_enabled(item_index) then
                    local mode = remote.get_item_mode(item_index)
                    if mode ~= 3 then
                        pad_states[item_index - g_pad_first] = remote.get_item_value(item_index)
                    else
                        pad_states[item_index - g_pad_first] = 0
                    end
                else
                    pad_states[item_index - g_pad_first] = nil
                end
            elseif item_index >= g_pad_note_first and item_index <= g_pad_note_last then
                if remote.is_item_enabled(item_index) then
                    drum_triggers[item_index - g_pad_note_first] = remote.get_item_value(item_index)
                else
                    drum_triggers[item_index - g_pad_note_first] = nil
                end
            elseif item_index >= g_pad_volume_first and item_index <= g_pad_volume_last then
                if remote.is_item_enabled(item_index) then
                    pad_drum_volume[item_index - g_pad_volume_first] = remote.get_item_value(item_index)
                else
                    pad_drum_volume[item_index - g_pad_volume_first] = nil
                end
            elseif item_index >= g_pad_drum_first and item_index <= g_pad_drum_last then
                if remote.is_item_enabled(item_index) then
                    pad_drum_assignments[item_index - g_pad_drum_first] =
                        tonumber(remote.get_item_text_value(g_inst_ctrl_first + remote.get_item_value(item_index)))
                else
                    pad_drum_assignments[item_index - g_pad_drum_first] = nil
                end
            elseif item_index >= g_fader_first and item_index <= g_knob_last then
                if remote.is_item_enabled(item_index) then
                    if item_index < g_knob_first then
                        if grabbed_ctrls[item_index - g_fader_first] then
                            ctrl_targets[item_index - g_fader_first] = grabbed_ctrls[item_index - g_fader_first]
                        else
                            if gLastDeviceName == remote.get_item_text_value(g_device_name) then
                                ctrl_targets[item_index - g_fader_first] = remote.get_item_value(item_index)
                            end
                        end
                    else
                        if g_user_page_active then
                            if grabbed_user[item_index - g_knob_first] then
                                ctrl_targets[item_index - g_fader_first] = grabbed_user[item_index - g_knob_first]
                            else
                                if gLastDeviceName == remote.get_item_text_value(g_device_name) then
                                    ctrl_targets[item_index - g_fader_first] = remote.get_item_value(item_index)
                                end
                            end
                        else
                            if grabbed_ctrls[item_index - g_fader_first] then
                                ctrl_targets[item_index - g_fader_first] = grabbed_ctrls[item_index - g_fader_first]
                            else
                                if gLastDeviceName == remote.get_item_text_value(g_device_name) then
                                    ctrl_targets[item_index - g_fader_first] = remote.get_item_value(item_index)
                                end
                            end
                        end
                    end
                    if not ctrl_targets[item_index - g_fader_first] then
                        ctrl_targets[item_index - g_fader_first] = remote.get_item_value(item_index)
                    end
                    ctrl_mutes[ctrl_targets[item_index - g_fader_first]] = muted
                    if g_model_is_iX then
                        if item_index == g_fader_last then
                            update_ctrl_mutes(ch16, ctrl_targets[g_fader_last - g_fader_first], g_last_iX_fader_value)
                            if ctrl_mutes[ctrl_targets[g_fader_last - g_fader_first]] ~= gLastMuteStatus then
                                sysEx_event = sysDisplaySoftTakeOverStatus(ctrl_targets[g_fader_last - g_fader_first])
                                gLastMuteStatus = ctrl_mutes[ctrl_targets[g_fader_last - g_fader_first]]
                            end
                        end
                    end
                else
                    ctrl_targets[item_index - g_fader_first] = 0
                end
            elseif item_index >= g_cc_first and item_index <= g_cc_last then
                local cc = item_index - g_cc_first
                if remote.is_item_enabled(item_index) then
                    cc_values[cc] = remote.get_item_value(item_index)
                    local now_ms = remote.get_time_ms()
                    if cc ~= g_last_ctrl or now_ms - g_last_input_time > 100 then
                        if now_ms - g_last_input_time > 100 then
                            cc_mutes[cc] = muted
                        end
                    end
                end
            elseif item_index == g_track_name then
                g_track_is_changing = remote.get_time_ms();
                g_user_page_active = false
                if gInstrumentMode then
                    setDefaultUserLEDStatus(k_on)
                else
                    if g_last_default_user_led_status then
                        setDefaultUserLEDStatus(k_off)
                    end
                end
                mute_all_ctrls()
                if g_model_is_iX then
                    update_ctrl_mutes(ch16, ctrl_targets[g_fader_last - g_fader_first], g_last_iX_fader_value)
                    if ctrl_mutes[ctrl_targets[g_fader_last - g_fader_first]] ~= gLastMuteStatus then
                        sysEx_event = sysDisplaySoftTakeOverStatus(ctrl_targets[g_fader_last - g_fader_first])
                        gLastMuteStatus = ctrl_mutes[ctrl_targets[g_fader_last - g_fader_first]]
                    end
                end
            elseif item_index == g_device_name then
                if remote.is_item_enabled(item_index) then
                    gActiveMapping = true;
                    local mode = remote.get_item_mode(item_index)
                    gPadBank = 0
                    if mode == 3 then
                        drum_is_active = true
                        if (not g_model_is_iX or g_model_is_lxmini) and not g_pads_in_sal_mode then
                            sysEx_event = set_pads_sal_mode(k_on)
                        end
                    else
                        drum_is_active = false
                        if g_pads_in_sal_mode and gPadMode ~= pd_scenes then
                            gPadMode = pd_notes
                        end
                        if (not g_model_is_iX or g_model_is_lxmini) and g_pads_in_sal_mode then
                            sysEx_event = set_pads_sal_mode(k_off)
                        end
                    end
                else
                    gActiveMapping = false;
                    drum_is_active = false
                    if (not g_model_is_iX or g_model_is_lxmini) and g_pads_in_sal_mode and gPadMode ~= pd_scenes then
                        sysEx_event = set_pads_sal_mode(k_off)
                    end
                end
            elseif item_index == g_default then
                g_update_page_mappings = remote.get_time_ms()
            elseif item_index == g_document_name then
                gInitializeLoopData = remote.get_time_ms()
            end
        else
            if item_index >= g_fader_first and item_index <= g_knob_last then
                local value = remote.get_item_value(item_index)
                local now_ms = remote.get_time_ms()
                if item_index - g_fader_first ~= g_last_ctrl or now_ms - g_last_input_time > 100 then
                    if now_ms - g_last_input_time > 100 then
                        ctrl_mutes[item_index - g_fader_first] = muted
                    end
                end
                if item_index >= g_button_first or item_index <= g_button_last then
                    led_button_states[item_index - g_button_first] = remote.get_item_value(item_index)
                end
            end
            if item_index >= g_mute_first and item_index <= g_mute_last then
                mixChannel_mutes[item_index - g_mute_first] = 0
                if remote.is_item_enabled(item_index) then
                    mixChannel_mutes[item_index - g_mute_first] = remote.get_item_value(item_index)
                end
            elseif item_index >= g_solo_first and item_index <= g_solo_last then
                mixChannel_solos[item_index - g_solo_first] = 0
                if remote.is_item_enabled(item_index) then
                    mixChannel_solos[item_index - g_solo_first] = remote.get_item_value(item_index)
                end
            end
        end
    end
end

function remote_deliver_midi()
    local ret_events = {}
    if startup then
        if not mixer_null_off_sent then
            sysEx_event = sysStartup(glob_elm.mix_null, 0)
            mixer_null_off_sent = true
        elseif not inst_null_off_sent then
            sysEx_event = sysStartup(glob_elm.ins_null, 0)
            inst_null_off_sent = true
        elseif not port_setup_sent then
            sysEx_event = sysStartup(glob_elm.usb_set, 2)
            port_setup_sent = true
        elseif not gm_dev_inquiry_sent then
            sysEx_event = sysDevInquiry()
            gm_dev_inquiry_sent = true
        else
            if (not g_model_is_iX or g_model_is_lxmini) and drum_is_active then
                sysEx_event = set_pads_sal_mode(k_on)
            end
            startup = false
        end
    end
    if gInitializeLoopData then
        local now_ms = remote.get_time_ms()
        if now_ms > gInitializeLoopData + 2000 then
            initialize_loop_presets()
        end
        gInitializeLoopData = false
    end
    if g_clips_led_status_msg then
        table.insert(ret_events, g_clips_led_status_msg)
        g_clips_led_status_msg = nil
    end
    if g_scenes_led_status_msg then
        table.insert(ret_events, g_scenes_led_status_msg)
        g_scenes_led_status_msg = nil
    end
    if g_update_R_locator then
        local now_ms = remote.get_time_ms()
        if now_ms >= g_update_R_locator + (gBeatsPerBar / 3840 / 4) * (60 / currentTempo()) * 1000 then
            sysEx_event = sysDevInquiry()
        end
    end
    if gSendShiftCCForGrab then
        table.insert(ret_events, midiCCvalue(16, ccShift, 1))
    end
    gSendShiftCCForGrab = false;
    if sysEx_event and not ret_events[1] then
        table.insert(ret_events, sysEx_event)
        sysEx_event = nil
    end
    if drum_is_active and gPadMode ~= pd_scenes then
        local force_update = false
        if ShiftMode then
            if not gPadShiftSent then
                displayPadShiftState()
            end
        else
            if g_pad_color_update_timer then
                local now_ms = remote.get_time_ms()
                if now_ms >= g_pad_color_update_timer + 10 then
                    g_update_pad_colors = kNumPads
                    gPadMode = pd_notes
                    force_update = true
                    g_pad_color_update_timer = nil
                end
            end
            if gPadBank ~= gPadBankLast then
                if gPadBank > 0 then
                else
                end
                gPadBankLast = gPadBank
            end
            local start = 0
            local stop = 16
            local offset = gPadBank * 8
            local pad_is_in_solo = false
            for i = start, stop do
                if pad_solos[i] and pad_solos[i] > 0 then
                    pad_is_in_solo = true
                    break
                end
            end
            for i = start, kNumPads - 1 do
                if not drum_triggers[i + offset] then
                    drum_pad_colors[i + offset] = padColor.off_yellow
                else
                    if not g_track_is_changing and (pad_states[i + offset] ~= pad_states_last[i + offset]) then
                        if send_midi_pad_note_on(i + offset) then
                            table.insert(ret_events, send_midi_pad_note_on(i + offset))
                        end
                        pad_states_last[i + offset] = pad_states[i + offset]
                        pad_is_in_solo = false
                        return ret_events
                    end
                    if pad_is_in_solo then
                        if pad_solos[i + offset] and pad_solos[i + offset] > 0 then
                            drum_pad_colors[i + offset] = padColor.green_yellow
                        else
                            drum_pad_colors[i + offset] = padColor.red_yellow
                        end
                    else
                        if pad_mutes[i + offset] and pad_mutes[i + offset] > 0 then
                            drum_pad_colors[i + offset] = padColor.red_yellow
                        else
                            drum_pad_colors[i + offset] = padColor.orange_yellow
                        end
                    end
                end
                if gPadBank == 1 then
                    pad_colors[i] = drum_pad_colors[i + offset]
                else
                    pad_colors[i] = drum_pad_colors[i]
                end
            end
            pad_is_in_solo = false
        end
    end
    if gPadMode == pd_scenes then
        if ShiftMode then
            resetPadColor()
            pad_colors[gLoopBank] = padColor.green_yellow
            g_update_pad_colors = kNumPads
        else
            for i = start, kNumPads - 1 do
                if i == gLastActiveScene then
                    if isRecording() then
                        pad_colors[i] = padColor.red_yellow
                    elseif isPlaying() then
                        pad_colors[i] = padColor.green_yellow
                    else
                        pad_colors[i] = padColor.yellow_green
                    end
                else
                    pad_colors[i] = padColor.yellow_green
                end
            end
        end
    end
    for i = start, kNumPads - 1 do
        if pad_colors[i] ~= pad_colors_last[i] then
            if not g_update_pad_colors then
                g_update_pad_colors = 1
            else
                g_update_pad_colors = g_update_pad_colors + 1
            end
        end
    end
    if g_update_pad_colors and not ret_events[0] then
        if gSalModeWasSet then
            local time_since_pad_mode_msg = remote.get_time_ms()
            if time_since_pad_mode_msg < gSalModeWasSet + 60 then
                return ret_events
            else
                gSalModeWasSet = nil
            end
        end
        if g_update_pad_colors > 1 then
            table.insert(ret_events, sysSetPadColor(true))
        else
            table.insert(ret_events, sysSetPadColor())
        end
        g_update_pad_colors = nil
        return ret_events
    end
    if gPadMode ~= gPadModeLast then
        send_midi_pad_mode()
        gPadModeLast = gPadMode
    end
    if g_device == "Mixer" then
        if gMixerMode then
            for i = 0, kNumMixChannels do
                if led_button_states[i] ~= led_button_states_last[i] then
                    if send_led_button_state(i) then
                        table.insert(ret_events, send_led_button_state(i))
                    end
                    led_button_states_last[i] = led_button_states[i]
                    return ret_events
                end
                led_button_colors[i] = padColor.off_yellow
                if mixChannel_solos[i] and mixChannel_solos[i] > 0 then
                    led_button_colors[i] = padColor.green_red
                end
                if mixChannel_mutes[i] and mixChannel_mutes[i] > 0 then
                    led_button_colors[i] = padColor.red_green
                end
                if led_button_colors[i] ~= led_button_colors_last[i] then
                    if not g_update_led_button_colors then
                        g_update_led_button_colors = 1
                    else
                        g_update_led_button_colors = g_update_led_button_colors + 1
                    end
                end
            end
            if g_update_led_button_colors and not ret_events[0] then
                if sysEx_event then
                    table.insert(ret_events, sysEx_event)
                    sysEx_event = nil
                end
                g_update_led_button_colors = nil
                return ret_events
            end
        end
    end
    if g_default_led_status_msg then
        table.insert(ret_events, g_default_led_status_msg)
        g_default_led_status_msg = nil
    end
    if g_user_led_status_msg then
        table.insert(ret_events, g_user_led_status_msg)
        g_user_led_status_msg = nil
    end
    if g_update_page_mappings then
        local now_ms = remote.get_time_ms()
        if now_ms >= g_update_page_mappings + 300 then
            for i = 0, g_knob_last - g_knob_first do
                if g_user_page_active then
                    if grabbed_user[i] then
                        ctrl_targets[i + g_knob_first - g_fader_first] = grabbed_user[i]
                    else
                        ctrl_targets[i + g_knob_first - g_fader_first] = remote.get_item_value(i + g_knob_first)
                    end
                else
                    if grabbed_ctrls[i + g_knob_first - g_fader_first] then
                        ctrl_targets[i + g_knob_first - g_fader_first] = grabbed_ctrls[i + g_knob_first - g_fader_first]
                    else
                        ctrl_targets[i + g_knob_first - g_fader_first] = remote.get_item_value(i + g_knob_first)
                    end
                end
                if ctrl_targets[i + g_knob_first - g_fader_first] ~= ctrl_targets_last[i + g_knob_first - g_fader_first] then
                    ctrl_mutes[ctrl_targets[i + g_knob_first - g_fader_first]] = muted
                end
                ctrl_targets_last[i + g_knob_first - g_fader_first] = ctrl_targets[i + g_knob_first - g_fader_first]
            end
            g_update_page_mappings = nil
        end
    end
    if g_track_is_changing then
        local now_ms = remote.get_time_ms()
        if now_ms >= g_track_is_changing + 200 then
            g_track_is_changing = nil
            set_parameter_targets_on_track_change()
            if gInstrumentMode then
                setDefaultUserLEDStatus(k_on)
            else
                if g_last_default_user_led_status then
                    setDefaultUserLEDStatus(k_off)
                end
            end
        end
    end
    return ret_events
end
