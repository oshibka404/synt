#!/bin/bash

(
    cd faust;
    faust2api -ios -nvoices 12 -nozip -target ../ios/Runner/DSP main.dsp
)
