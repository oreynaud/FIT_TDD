# FIT_TDD
here is the script used in Time-dependent diffusion MRI in cancer: tissue modeling and applications (Reynaud, Frontiers 2017) to estimate fitting accuracy when fitting time-dependent diffusion and various frameworks such as POMACE, IMPULSED, or simply OGSE data.

simply run "main_script" on matlab to plot figure 6A,B,C,D from the paper, obtained from 2500 iterations and SNR=120.

Alternatively you can re-run each analysis by typing:
script_accuracy_OGSE;
script_accuracy_POMACE;
script_accuracy_IMPULSED; % modify to choose which tumor cell lime to mimic (default is HCT116)
