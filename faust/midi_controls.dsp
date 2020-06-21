import("stdfaust.lib");

gate = button("gate");
gain = hslider("gain", 0.42, 0, 1, 0.01);
baseFreq = hslider("freq", 440, 20, 20000, 1);
bend = hslider("bend[midi:pitchwheel]", 1, 0, 10, 0.01);
freq = baseFreq * bend : si.polySmooth(gate, 0.9, 1);

modulation = hslider("modulation[midi:ctrl 1]", 0, 0, 1, 0.01);
