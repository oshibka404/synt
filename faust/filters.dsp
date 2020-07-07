import("stdfaust.lib");

// Filters

lpf = fi.resonlp(
    vslider("filters/lp/freq", 3000, 20, 20000, 1),
    vslider("filters/lp/q", .5, 0, 1, .01),
    vslider("filters/lp/gain", .5, 0, 1, .01)
);

process = _; // hpf : lpf;
