import("stdfaust.lib");

// Additive synthesizer

cc = library("midi_controls.dsp");

hAttackSlider = hslider("Settings/Harmonics/Attack", 1, 0.1, 10, .1);
hDecaySlider = hslider("Settings/Harmonics/Decay", 1, 0.1, 10, .1);
hSustainSlider = hslider("Settings/Harmonics/Sustain", 1, .01, 1, .01);
hReleaseSlider = hslider("Settings/Harmonics/Release", 1, .01, 1, .01);

sine(f) = os.osc(f) * (1 - cc.modulation);

nHarmonics = 8;

nthAttack(n) = hAttackSlider * (1 - cc.gain) / n + .001;
nthDecay(n) = hDecaySlider / n;
nthSustain(n) = hSustainSlider / n;
nthRelease(n) = hReleaseSlider / n;

nthEnvelope(n) = en.adsr(nthAttack(n), nthDecay(n), nthSustain(n), nthRelease(n), cc.gate) : si.smoo;
nthHarmonic(n) = sine(cc.freq * n) * nthEnvelope(n);

process = sum(i, nHarmonics, nthHarmonic(i+1)) / nHarmonics;
