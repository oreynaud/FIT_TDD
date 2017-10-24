function signal_ogse=dtime_sphere_OGSEPGSE_impulsed(p, omegalist, graddur, glut, Deltalist, deltalist)

% get n roots of x*J'(x,3/2)-0.5*J(x,3/2)=0
% we simplify using J'(x,3/2)=0.5*(J(x,1/2)-J(x,5/2)) and divide by 0.5
rt = newtzero(@(x)(x.*(besselj(1/2,x)-besselj(5/2,x))-besselj(3/2,x)),1);
rt = rt(rt>0); %keeep only positive values
rt=rt(1:end);

% inputs
f  =abs(p(1)); % fraction
R  =abs(p(2));%*1e-6;
Df =abs(p(3));%*1e-10;
Dfx=abs(p(4));
beta=abs(p(5));

% definitions
gamma=2.675E+08; 
gamma2=gamma^2;
TE=70e-3;
R2=R^2;
Df2=Df^2;
alpham=rt/R;
alpham2=alpham.^2;
dtno=length(omegalist);

% new variables according to (Xu et al, MRM 2009)
lambda = (rt/R).*(rt/R); % array (size=number of roots)
lambda2 = lambda.*lambda; % array (same size)
rt2 = rt.*rt; % array (same size)
bn = 2./(lambda.*(rt2-2)); % array
tau = TE/2;

for i=1:dtno

   delta=deltalist(i);
   g=glut(i);
   g2=g^2;
   
   % =================================================================== %
   % Muray & Cotts (1968) - PGSE & spheres
   tauM=Deltalist(i);
   D1 = alpham2 .* ( alpham2 * R2 - 2 );
   N1 = 2 * delta ./ ( alpham2 * Df );
   N21= 2 + exp( -alpham2 * Df * (tauM - delta) );
   N22= 2 * exp( -alpham2 * Df * delta );
   N23= 2 * exp( -alpham2 * Df * tauM );
   N24= exp( -alpham2 * Df * ( tauM + delta ) );
   D2 = ( alpham2 * Df ) .* ( alpham2 * Df );
   atten_pgse(i)=2*(gamma2)*(g2)*sum(1./D1.*(N1-((N21-N22-N23+N24)./(D2))));
   % =================================================================== %

   % =================================================================== %
   % Xu, 2009 - OGSE & spheres
   om = 2*pi*omegalist (i);
   om2 = om^2;
   sigma = graddur(i);
   tau= sigma + 1.5/omegalist(i); % % % mod  
   globfac = bn .* lambda2 * Df2 ./ (( lambda2 * Df2 + om2 ).^2);
   A1 = (lambda2 * Df2 + om2) ./ ( lambda * Df);
   B1 = sigma / 2 + ( sin( 2 * om * sigma ) / ( 4 * om ) );
   A2 = -1 + exp( -lambda * Df * sigma ) + exp( -lambda * Df * tau );
   A3 = 0.5 .* exp( -lambda .* Df .* (tau+sigma) );
   A4 = 0.5 .* exp( -lambda .* Df .* (tau-sigma) );
   atten_sphere(i)=2*(gamma2)*(g2)*sum(globfac.*(A1.*B1+A2-A3-A4));
   % =================================================================== %
    
end

% Two compartment model: PGSE  ========================================= %
bpgse=(gamma^2*(glut.^2).*(deltalist.^2)).*(Deltalist-deltalist/3);
signal_pgse=f*exp(-atten_pgse)+(1-f)*exp(-bpgse.*Dfx);
% ====================================================================== %

% Two compartment model: OGSE ========================================== %
b = (gamma2) .* (glut.*glut) .* graddur ./ ( 4 .* (pi^2) .* (omegalist.^2) );
signal_ogse=f*exp(-atten_sphere)+(1-f)*exp(-b.*(Dfx+beta.*omegalist));

% replace f=0 by PGSE
signal_ogse(1:4:end)=signal_pgse(1:4:end);