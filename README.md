# README
## Running with Octave
To run this locally, install octave on your machine.

If you're running Mac OS, this is as straightforward:
1. Install homebrew: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
2. Install octave: `brew install octave`

After you've finished installing octave, you can navigate to this folder and run `octave runner.m`.

## Running with Matlab
Import these files into your Matlab environment. Run `runner.m` as a script.

### Providing data and getting results.
Add your datasets into the `data/` folder. 
These will be combined into unique combinations of these datasets, computed, and deposited into the `output/` folder.

## Attribution
Code for the `kstest_2s_2d` function is taken from [this paper](https://www.sciencedirect.com/science/article/abs/pii/S0012821X1830699X).

The `dimcell` function is attributed in the file proper.