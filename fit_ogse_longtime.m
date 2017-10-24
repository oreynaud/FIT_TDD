function signal_ogse=fit_ogse_longtime(p,f2sphere)
        
% intergradient duration, gardient duration and amplitude
graddur=[12.1 14 16.2]*1e-3;%is used for graddur and Deltalist
deltalist=[3 3 3]*1e-3;
glutsphere2=[0.3814 0.3023 0.2401]; 

% b=400/200/0;
graddur=[graddur graddur graddur];
deltalist=[deltalist deltalist deltalist];
glutsphere2=[glutsphere2 glutsphere2*sqrt(200/400) glutsphere2*0];

% reorganize inputs
p(3)=p(3)*1e-9; % p(3) = D0
p(2)=p(2)*1e-6;
p(1)=min(p(1),0.99); % f < 1, ECS > 0
D20=p(5)*1e-9; % D20=D0_PBS
D20=min(D20,3e-9);
D10=(p(3)-(1-p(1))*D20)/p(1); %from D0=f*D10+ecs*D20 -> D10=(D0-ECS*D20)/(1-ECS)
D10=max(D10,0);
D2=p(4)*1e-9;
D2=min(D2,D20);

p(3)=D10;
p(4)=D2;

signal_ogse=dtime_sphere_OGSEPGSE(p,f2sphere,graddur,glutsphere2,graddur,deltalist);