declare name "Perfect First Synth";
declare author "Andrey Ozornin";
declare copyright "Aesthetics Engineering";
declare version "0.01";
declare license "BSD";
declare options "[midi:on][style:poly][nvoices:12]";

import("stdfaust.lib");

cc = library("midi_controls.dsp");

global_envelope = component("global_envelope.dsp");

oscillators = component("oscillators.dsp");

process = oscillators * global_envelope : component("filters.dsp");
