import("stdfaust.lib");

cc = library("midi_controls.dsp");

attackSlider = hslider("Settings/ADSR/Attack", .01, 0.01, 10, .1); // modulation decreases attack
decaySlider = hslider("Settings/ADSR/Decay", 1, 0.1, 10, .1);
sustainSlider = hslider("Settings/ADSR/Sustain", .5, .01, 1, .01);
releaseSlider = hslider("Settings/ADSR/Release", .5, .01, 1, .01);

// process = en.adsr(
//     attackSlider,
//     decaySlider,
//     sustainSlider,
//     releaseSlider,
//     cc.gate
// ) * cc.gain : si.smoo;

process = cc.gain * cc.gate : si.smoo;
