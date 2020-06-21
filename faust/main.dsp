// TODO: separate into modules

declare name "Perfect First Synth";
declare author "Andrey Ozornin";
declare copyright "Aesthetics Engineering";
declare version "0.01";
declare license "BSD";
declare options "[midi:on][style:poly][nvoices:12]";

import("stdfaust.lib");

cc = library("midi_controls.dsp");

attack = (1 - cc.modulation) / 4 + 0.01; // .26s for pure sine and 0.01 for pure saw

envelope = en.adsr(attack, 0.3, 0.5, 0.1, cc.gate) * cc.gain;

oscillators = component("oscillators.dsp") * envelope;

process = oscillators : component("filters.dsp");
