import("stdfaust.lib");

syncOn = checkbox("po_sync_enabled");

metronome = button("po_sync_pulse") : ba.impulsify;

po_sync(i_left, i_right) = i_left * (1 - syncOn) + syncOn * metronome, i_right + (i_left) * syncOn;

process = po_sync;
