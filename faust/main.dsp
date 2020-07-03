declare name "Perfect First Synth";
declare author "Andrey Ozornin";
declare copyright "Aesthetics Engineering";
declare version "0.01";
declare license "BSD";
declare options "[midi:on][style:poly][nvoices:12]";

import("stdfaust.lib");

cc = library("midi_controls.dsp");

envelope = component("envelope.dsp");

oscillators = component("oscillators.dsp") * envelope;

process = oscillators : component("filters.dsp");
