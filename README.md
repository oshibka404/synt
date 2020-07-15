# Synt
A powerful tool to make music even for those having little to no background.

## Main principles
- "Do what I mean": instead of blindly execute whatever user *does*, do what they *intend* to do.
- Allow [luxury of ignorance](http://www.catb.org/~esr/writings/cups-horror.html). Don't make users read manuals and learn stuff. They don't have to.
- Work out-of-the box to fulfill expectations of the majority.
- Having all the necessary things to go through essentials of sound design from scratch
- Producing pleasant sounds out-of-the-box

Mobile first (Currently supports only iOS).

## Technical stuff
DSP written in Faust an compiled to native iOS API with faust2api.
UI is made using Flutter and communicates with DSP via Dart/C++ interop.

### Build process
1. run `./build.sh` from the root of the repository. It will build necessary C++ files for DSP
2. `flutter run`

## Plans
### MVP essentials
- Multi-touch surface
- Several oscillators: differents waveforms, noise
- Filtering
- Param modulation by gyroscope and accelerometer

### Strong plans
- Whatever the users ask for
- Android support
- LFO
- Effects: echo, reverb

### Dreams
- Stand-alone Mac aupport
- Stand-alone Linux support
- Web support
- VST, AU
- Granular synthesis
- FM synthesis
