declare name "Effects Module of Perfect First Synth";
declare author "Andrey Ozornin";
declare copyright "Aesthetics Engineering";
declare version "0.01";
declare license "BSD";

import("stdfaust.lib");

po_sync = component("po_sync.dsp");

process = _ <: po_sync;
