import("stdfaust.lib");

cc = library("midi_controls.dsp");

saw = os.sawtooth(cc.freq) * cc.modulation;
sine = os.osc(cc.freq) * (1 - cc.modulation);

noiseEnvelope = en.adsr(0.01, 0.2, 0, 0, cc.gate);

noise = no.noise * cc.modulation * noiseEnvelope;

process = saw + sine + noise;
