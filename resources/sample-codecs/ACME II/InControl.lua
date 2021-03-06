function remote_init(manufacturer, model)
	if model=="In Control II" then
		local items={
			{name="Keyboard", input="keyboard"},
			{name="Pitch Bend", input="value", min=0, max=16383},
			{name="Modulation", input="value", min=0, max=127},
			{name="Fader 1", input="value", output="value", min=0, max=127},
			{name="Fader 2", input="value", output="value", min=0, max=127},
			{name="Fader 3", input="value", output="value", min=0, max=127},
			{name="Fader 4", input="value", output="value", min=0, max=127},
			{name="Encoder 1", input="delta", output="value", min=0, max=10},
			{name="Encoder 2", input="delta", output="value", min=0, max=10},
			{name="Encoder 3", input="delta", output="value", min=0, max=10},
			{name="Encoder 4", input="delta", output="value", min=0, max=10},
			{name="Button 1", input="button", output="value"},
			{name="Button 2", input="button", output="value"},
			{name="Button 3", input="button", output="value"},
			{name="Button 4", input="button", output="value"},
		}
		remote.define_items(items)
	else
		local items={
			{name="Keyboard", input="keyboard"},
			{name="Pitch Bend", input="value", min=0, max=16383},
			{name="Modulation", input="value", min=0, max=127},
			{name="Fader 1", input="value", min=0, max=127},
			{name="Fader 2", input="value", min=0, max=127},
			{name="Fader 3", input="value", min=0, max=127},
			{name="Fader 4", input="value", min=0, max=127},
			{name="Encoder 1", input="delta"},
			{name="Encoder 2", input="delta"},
			{name="Encoder 3", input="delta"},
			{name="Encoder 4", input="delta"},
			{name="Button 1", input="button"},
			{name="Button 2", input="button"},
			{name="Button 3", input="button"},
			{name="Button 4", input="button"},
		}
		remote.define_items(items)
	end

	local inputs={
		{pattern="b? 40 xx", name="Fader 1"},
		{pattern="b? 41 xx", name="Fader 2"},
		{pattern="b? 42 xx", name="Fader 3"},
		{pattern="b? 43 xx", name="Fader 4"},
		{pattern="e? xx yy", name="Pitch Bend", value="y*128 + x"},
		{pattern="b? 01 xx", name="Modulation"},
		{pattern="9? xx 00", name="Keyboard", value="0", note="x", velocity="64"},
		{pattern="<100x>? yy zz", name="Keyboard"},
		{pattern="b? 50 <???y>x", name="Encoder 1", value="x*(1-2*y)"},
		{pattern="b? 51 <???y>x", name="Encoder 2", value="x*(1-2*y)"},
		{pattern="b? 52 <???y>x", name="Encoder 3", value="x*(1-2*y)"},
		{pattern="b? 53 <???y>x", name="Encoder 4", value="x*(1-2*y)"},
		{pattern="b? 60 ?<???x>", name="Button 1"},
		{pattern="b? 61 ?<???x>", name="Button 2"},
		{pattern="b? 62 ?<???x>", name="Button 3"},
		{pattern="b? 63 ?<???x>", name="Button 4"},
	}
	remote.define_auto_inputs(inputs)

	if model=="In Control II" then
		local outputs={
			{name="Fader 1", pattern="b0 40 xx"},
			{name="Fader 2", pattern="b0 41 xx"},
			{name="Fader 3", pattern="b0 42 xx"},
			{name="Fader 4", pattern="b0 43 xx"},
			{name="Encoder 1", pattern="b0 50 0x", x="enabled*(value+1)"},
			{name="Encoder 2", pattern="b0 51 0x", x="enabled*(value+1)"},
			{name="Encoder 3", pattern="b0 52 0x", x="enabled*(value+1)"},
			{name="Encoder 4", pattern="b0 53 0x", x="enabled*(value+1)"},
			{name="Button 1", pattern="b0 60 0<000x>"},
			{name="Button 2", pattern="b0 60 0<000x>"},
			{name="Button 3", pattern="b0 60 0<000x>"},
			{name="Button 4", pattern="b0 60 0<000x>"},
		}
		remote.define_auto_outputs(outputs)
	end
end

function remote_probe(manufacturer,model)
	if model=="In Control II" then
		return {
			request="f0 7e 7f 06 01 f7",
			response="f0 7e 7f 06 02 56 66 66 01 02 ?? ?? ?? ?? f7"
		}
	else
		return {
			request="f0 7e 7f 06 01 f7",
			response="f0 7e 7f 06 02 56 66 66 01 01 ?? ?? ?? ?? f7"
		}
	end
end
