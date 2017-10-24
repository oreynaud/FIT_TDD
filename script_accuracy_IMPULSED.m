% generate frequency list (Jiang et al, MRM 2016)
f=[0 50 100 150]; f=[f f f f f]; % list of frequencies (x number of b-values)

% best parameters for HCT116 tumors (Jiang et al, MRM 2016 - table 2)
p=[0.46 13.51/2 1.53 0.75 2.36]; 

% generate synthetic tumor signal
F_true=fit_impulsed(p,f);

% SNR level and number of noise iterations, counter initialization
Nnoise=3000;
parm_list_impulsed=zeros(5,Nnoise);
c=0;

for i=1:Nnoise

% generate noisy signal with proper SNR level    
Fx=F_true+randn(1,length(F_true))*F_true(end)/120; 

c=c+1;waitbar(c/(Nnoise))

guess=p; % start from the ground truth

% lower / upper bounds for lsqcurvefit
lb=[0;0;0;0;0];
ub=[1;10;3;3;20];

try
    % fit with lsqcurvefit as in (Jiang et al, MRM 2016)
    a1 = lsqcurvefit(@fit_impulsed,guess,f,Fx,lb,ub);
catch
    a1 = [nan;nan;nan;nan;nan]; % replace fit errors with nan
end

parm_list_impulsed(:,i)=a1;
fprintf('\n Fit %i of %i is done!\n', i, Nnoise);

end 

save ('Accuracy_SNR120_IMPULSED.mat','parm_list_impulsed')