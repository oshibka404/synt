import("stdfaust.lib");

cc = library("../midi_controls.dsp");

pulse_level_attack = hslider("Oscillators/Pulse/Attack", .001, .001, 1, .001);
pulse_level_decay = hslider("Oscillators/Pulse/Decay", .5, 0.1, 1, .001);
pulse_level_sustain = hslider("Oscillators/Pulse/Sustain", .3, .001, 1, .001);
pulse_level_release = hslider("Oscillators/Pulse/Release", .001, .001, 1, .001);

pulse_level_envelope = en.adsr(
    pulse_level_attack,
    pulse_level_decay,
    pulse_level_sustain,
    pulse_level_release,
    cc.gate
);

pulse_duty = hslider("Oscillators/Pulse/Duty", .5, .01, 1, .01);

// pulse_osc = os.pulsetrain(cc.freq, pulse_duty) * pulse_level_envelope;
pulse_osc = os.pulsetrain(cc.freq, pulse_duty);


process = pulse_osc;
