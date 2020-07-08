import("stdfaust.lib");

pulse_level = vgroup("Pulse[0]", hslider("Level[0]", 1, 0, 1, .01));
pulse = component("oscillators/pulse.dsp") * pulse_level;

triangle_level = vgroup("Triangle[1]", hslider("Level[0]", 1, 0, 1, .01));
triangle = component("oscillators/triangle.dsp") * triangle_level;

saw_level = vgroup("Saw[2]", hslider("Level[0]", 1, 0, 1, .01));
saw = component("oscillators/saw.dsp") * saw_level;

total_level = pulse_level + triangle_level + saw_level;

process = pulse + triangle + saw : /(total_level + .001);
