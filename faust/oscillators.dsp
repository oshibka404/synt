import("stdfaust.lib");

pulse_level = hslider("Oscillators/Pulse/Level", 1, 0, 1, .01);
pulse = component("oscillators/pulse.dsp") * pulse_level;

triangle_level = hslider("Oscillators/Triangle/Level", 1, 0, 1, .01);
triangle = component("oscillators/triangle.dsp") * triangle_level;

saw_level = hslider("Oscillators/Saw/Level", 1, 0, 1, .01);
saw = component("oscillators/saw.dsp") * saw_level;

total_level = pulse_level + triangle_level + saw_level;

process = pulse + triangle + saw : /(total_level + .001);
