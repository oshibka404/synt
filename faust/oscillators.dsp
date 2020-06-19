import("stdfaust.lib");

cc = library("midi_controls.dsp");

saw = os.sawtooth(cc.freq) * vslider("osc/saw/level", 0.6, 0, 1, 0.01);
sine = os.osc(cc.freq) * vslider("osc/sin/level", 0.4, 0, 1, 0.01);
noise = no.noise * vslider("osc/noise/level", 0.2, 0, 1, 0.01);

process = (saw + sine + noise) / 3;