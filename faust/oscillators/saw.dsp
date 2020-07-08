import("stdfaust.lib");

cc = library("../midi_controls.dsp");

saw_level_attack = vgroup("Saw", hslider("Attack[1]", .001, .001, 1, .001));
saw_level_decay = vgroup("Saw", hslider("Decay[2]", .3, 0.1, 1, .001));
saw_level_sustain = vgroup("Saw", hslider("Sustain[3]", .2, .001, 1, .001));
saw_level_release = vgroup("Saw", hslider("Release[4]", .001, .001, 1, .001));

saw_level_envelope = en.adsr(
    saw_level_attack,
    saw_level_decay,
    saw_level_sustain,
    saw_level_release,
    cc.gate
);

saw_osc = os.sawtooth(cc.freq) * saw_level_envelope;

process = saw_osc;
