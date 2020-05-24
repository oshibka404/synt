#!/bin/bash

(
    cd faust;
    faust2api -ios -nozip -target ../ios/Runner/DSP main.dsp
)
