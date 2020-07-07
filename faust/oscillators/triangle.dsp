import("stdfaust.lib");

cc = library("../midi_controls.dsp");

triangle_level_attack = hslider("Oscillators/Triangle/Attack", .001, .001, 1, .001);
triangle_level_decay = hslider("Oscillators/Triangle/Decay", 1, 0.1, 1, .001);
triangle_level_sustain = hslider("Oscillators/Triangle/Sustain", 1, .001, 1, .001);
triangle_level_release = hslider("Oscillators/Triangle/Release", .001, .001, 1, .001);

triangle_level_envelope = en.adsr(
    triangle_level_attack,
    triangle_level_decay,
    triangle_level_sustain,
    triangle_level_release,
    cc.gate
);

// triangle_osc = os.triangle(cc.freq) * triangle_level_envelope;
triangle_osc = os.triangle(cc.freq);

process = triangle_osc;
