import("stdfaust.lib");

cc = library("../midi_controls.dsp");

triangle_level_attack = vgroup("Triangle", hslider("Attack[1]", .001, .001, 1, .001));
triangle_level_decay = vgroup("Triangle", hslider("Decay[2]", 1, 0.1, 1, .001));
triangle_level_sustain = vgroup("Triangle", hslider("Sustain[3]", 1, .001, 1, .001));
triangle_level_release = vgroup("Triangle", hslider("Release[4]", .001, .001, 1, .001));

triangle_level_envelope = en.adsr(
    triangle_level_attack,
    triangle_level_decay,
    triangle_level_sustain,
    triangle_level_release,
    cc.gate
);

triangle_osc = os.triangle(cc.freq) * triangle_level_envelope;

process = triangle_osc;
