import("stdfaust.lib");

cc = library("../midi_controls.dsp");

pulse_level_attack = vgroup("Pulse", hslider("Attack[1]", .001, .001, 1, .001));
pulse_level_decay = vgroup("Pulse", hslider("Decay[2]", .5, 0.1, 1, .001));
pulse_level_sustain = vgroup("Pulse", hslider("Sustain[3]", .3, .001, 1, .001));
pulse_level_release = vgroup("Pulse", hslider("Release[4]", .001, .001, 1, .001));

pulse_level_envelope = en.adsr(
    pulse_level_attack,
    pulse_level_decay,
    pulse_level_sustain,
    pulse_level_release,
    cc.gate
);

pulse_duty = vgroup("Pulse", hslider("Duty", .5, .01, 1, .01));

pulse_osc = os.pulsetrain(cc.freq, pulse_duty) * pulse_level_envelope;

process = pulse_osc;
