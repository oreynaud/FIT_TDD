function data_ogse=fit_impulsed(p,f2sphere)

% intergradient duration, gradient duration and amplitude
graddur=16.2*ones(size(f2sphere))./f2sphere.*225; % omega inversely proportional to Delta
deltalist=graddur; % only matters for PGSE
glutsphere2=0.004*ones(size(f2sphere)); % dont care about b-values here, 0.04 goes to small omega (7 Hz)

% for PGSE (f=0)
graddur(1:4:end)=48*1e-3;deltalist(1:4:end)=4*1e-3;glutsphere2(1:4:end)=0.1935;

% for OGSE - max bvalues 2|2|1.32|0.6
glutsphere2(2)=glutsphere2(2)*sqrt(20/8.4566); % f=50 Hz
glutsphere2(3)=glutsphere2(3)*sqrt(13.2/1.0571); % f=100 Hz
glutsphere2(4)=glutsphere2(4)*sqrt(6/0.3132); % f=150 Hz

% f must be = [0:50:150 0:50:150 0:50:150 0:50:150]
glutsphere2(5)=glutsphere2(1)*sqrt(1.5/2);glutsphere2(9)=glutsphere2(1)*sqrt(1/2);glutsphere2(13)=glutsphere2(1)*sqrt(0.5/2);glutsphere2(17)=glutsphere2(1)*sqrt(0/2);
glutsphere2(6)=glutsphere2(2)*sqrt(1.5/2);glutsphere2(10)=glutsphere2(2)*sqrt(1/2);glutsphere2(14)=glutsphere2(2)*sqrt(0.5/2);glutsphere2(18)=glutsphere2(2)*sqrt(0/2);
glutsphere2(7)=glutsphere2(3)*sqrt(1/1.32);glutsphere2(11)=glutsphere2(3)*sqrt(0.66/1.32);glutsphere2(15)=glutsphere2(3)*sqrt(0.33/1.32);glutsphere2(19)=glutsphere2(3)*sqrt(0/1.32);
glutsphere2(8)=glutsphere2(4)*sqrt(0.45/0.6);glutsphere2(12)=glutsphere2(4)*sqrt(0.3/0.6);glutsphere2(16)=glutsphere2(4)*sqrt(0.15/0.6);glutsphere2(20)=glutsphere2(4)*sqrt(0/0.6);

% reorganizing inputs
p(4)=min(p(4)*1e-9,3e-9);
p(3)=p(3)*1e-9;
p(2)=p(2)*1e-6;
p(1)=min(p(1),0.99);
p(5)=p(5)*1e-12;

data_ogse = dtime_sphere_OGSEPGSE_impulsed(p,f2sphere,graddur,glutsphere2,graddur,deltalist);