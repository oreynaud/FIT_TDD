% load list of OGSE frequencies
flist=[225 200 180 160 140 125 100 88 75 65 140/6 140/9 140/17 140/31];
flist=[flist flist flist]; % b=0/200/400

% generate synthetic signal in short time regime
f_SV=flist([1:8 15:22 29:36]); % extract f at short times only
signal_SV=fit_ogse_shorttime([1.72 0.57],f_SV); % best fit from S/V paper

% generate synthetic signal in long time regime
f_3P=flist([8:14 22:28 36:42]); % extract f (including PGSE)
truth_3P=[0.56 4.8 1.72 2.06 2.7]; % best fit for GL261 from POMACE paper
signal_3P=fit_pomace_longtime(truth_3P,f_3P);

% combine signal
F_true(1:8)=signal_SV(1:8);F_true(15:22)=signal_SV(9:16);F_true(29:36)=signal_SV(17:24);
F_true(9:14)=signal_3P(2:7);F_true(23:28)=signal_3P(9:14);F_true(37:42)=signal_3P(16:21);

% SNR level and number of noise iterations, counter initialization
Nnoise=3000;
c=0;
SNR_list=120;
parm_list_pomace=zeros(5,Nnoise,length(SNR_list));


for j=1:length(SNR_list)
for k=1:Nnoise

% generate noisy data with proper SNR level
noise=randn(1,42)/SNR_list(j);
F=F_true+noise;

% ====== Short time regime (2 parms to fit) ========
dat_SV=F([1:8 15:22 29:36]); % extract signal in short time regime (f >= 88 Hz)

% fit
[a1,a2,a3,a4,a5]=nlinfit(f_SV,dat_SV,@fit_ogse_shorttime,[1.7;0.6]); % fit SV
D0=a1(1);SV=a1(2); % store results
% ==================================================

% ======= Long time regime (3 parms to fit) ========
dat_3P=F([8:14 22:28 36:42]); % extract signal in long time regime (f =< 88 Hz)

% guess uses previous D0 estimation from short time 
% D0,ecs is fixed to 2.7 um2/ms.
guess=[truth_3P(1) truth_3P(2) D0 truth_3P(4) 2.7];

 try
[a12,a22,a32,a42,a52]=nlinfitsome([false,false,true,false,true],f_3P,dat_3P,@fit_pomace_longtime,guess);
 catch
a12=[nan nan nan nan nan]; % replace fit errors with nan
 end

c=c+1;
waitbar(c/Nnoise/length(SNR_list));
parm_list_pomace(:,k,j)=a12;

end
end

save('Accuracy_SNR120_POMACE.mat','parm_list_pomace');