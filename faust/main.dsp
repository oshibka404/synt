// TODO: separate into modules

declare name "Perfect First Synth";
declare author "Andrey Ozornin";
declare copyright "Aesthetics Engineering";
declare version "0.01";
declare license "BSD";
declare options "[midi:on][style:poly][nvoices:12]";

import("stdfaust.lib");

// MIDI params
gate = button("gate");
gain = hslider("gain", 0.42, 0, 1, 0.01);
baseFreq = hslider("freq", 440, 20, 20000, 1);
bend = hslider("bend[midi:pitchwheel]", 1, 0, 10, 0.01);
freq = baseFreq * bend : si.polySmooth(gate,0.9,1);

// Oscillators
saw = os.sawtooth(freq) * vslider("osc/saw/level", 0.6, 0, 1, 0.01);
square = os.square(freq) * vslider("osc/square/level", 0.4, 0, 1, 0.01);
noise = no.noise * vslider("osc/noise/level", 0.2, 0, 1, 0.01);

envelope = en.adsr(0.1, 0.3, 0.4, 0.3, gate) * gain;

oscillators = (saw + square + noise) / 3 * envelope;

// Filters
hpf = fi.resonhp(
    vslider("filters/hp/freq", 100, 20, 20000, 1),
    vslider("filters/hp/q", .5, 0, 1, .01),
    vslider("filters/hp/gain", .5, 0, 1, .01)
);

lpf = fi.resonlp(
    vslider("filters/lp/freq", 1000, 20, 20000, 1),
    vslider("filters/lp/q", .5, 0, 1, .01),
    vslider("filters/lp/gain", .5, 0, 1, .01)
);

filters = hpf : lpf;

process = oscillators : filters;
