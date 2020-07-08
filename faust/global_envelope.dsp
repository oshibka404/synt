import("stdfaust.lib");

cc = library("midi_controls.dsp");

attackSlider = vgroup("Envelope", hslider("Attack", .01, 0.01, 10, .1));
decaySlider = vgroup("Envelope", hslider("Decay", 1, 0.1, 10, .1));
sustainSlider = vgroup("Envelope", hslider("Sustain", .5, .01, 1, .01));
releaseSlider = vgroup("Envelope", hslider("Release", .5, .01, 1, .01));

process = en.adsr(
    attackSlider,
    decaySlider,
    sustainSlider,
    releaseSlider,
    cc.gate
) * cc.gain : si.smoo;
