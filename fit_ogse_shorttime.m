function signal=fit_ogse_shorttime(p,f2sphere)

% inputs
D0=p(1);
SV=p(2);

% correction for number of oscillations
c  = [0.8064    0.7664    0.7496    0.7404    0.7345]; % coeffs for N=1:5
c2 = [c(1) c(2) c(2) c(2) c(3) c(3) c(4) c(5)]; % for the waveforms used in (Reynaud et al, MRM 2016)
c2 = c2(end:-1:1);c2=[c2 c2 c2];

% b-values
b1=[0.4001 0.3913 0.3965 0.4001 0.4073 0.4001 0.4098 0.4120];
b2=b1/2; b3=b1*0; b=[b1 b2 b3];

% diffusion and signal
F=D0.*(1-(c2).*SV./3.*sqrt(D0./(2.*pi.*f2sphere).*1000));
signal=exp(-b.*F);