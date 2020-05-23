#!/bin/bash

rm -rf temp
mkdir temp
cp faust/* temp/
cd temp
faust2api -ios -nozip main.dsp
rm -rf ../ios/Runner/DSP
mkdir ../ios/Runner/DSP
mv ./DspFaust.cpp ../ios/Runner/DSP
mv ./DspFaust.h ../ios/Runner/DSP
mv ./README.md ../ios/Runner/DSP
cd ..
rm -rf temp

