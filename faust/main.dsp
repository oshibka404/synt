declare name "Sample synth";
declare author "Andrey Ozornin";
declare copyright "Aesthetics Engineering";
declare version "0.01";
declare license "BSD";
import("stdfaust.lib");

gate = button("gate");
gain = nentry("gain", 0.5, 0, 1, 0.01);

process = os.sawtooth(440)*gate*gain <: _,_;