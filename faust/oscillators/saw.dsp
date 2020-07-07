import("stdfaust.lib");

cc = library("../midi_controls.dsp");

saw_level_attack = hslider("Oscillators/Saw/Attack", .001, .001, 1, .001);
saw_level_decay = hslider("Oscillators/Saw/Decay", .3, 0.1, 1, .001);
saw_level_sustain = hslider("Oscillators/Saw/Sustain", .2, .001, 1, .001);
saw_level_release = hslider("Oscillators/Saw/Release", .001, .001, 1, .001);

saw_level_envelope = en.adsr(
    saw_level_attack,
    saw_level_decay,
    saw_level_sustain,
    saw_level_release,
    cc.gate
);

saw_osc = os.sawtooth(cc.freq) * saw_level_envelope;

process = saw_osc;
