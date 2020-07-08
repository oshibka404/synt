import("stdfaust.lib");

// Filters

lpf = vgroup("Filter[3]", fi.resonlp(
    vslider("Cutoff", 3000, 20, 20000, 1),
    vslider("Q Factor", .5, 0, 1, .01),
    vslider("Filter gain", .5, 0, 1, .01)
));

process = lpf; // hpf : lpf;
