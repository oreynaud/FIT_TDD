% load list of OGSE frequencies
flist=[225 200 180 160 140 125 100 88 75 65 140/6 140/9 140/17 140/31];
flist=[flist flist flist]; % b=0/200/400

% generate synthetic signal in short time regime
f_SV=flist([1:8 15:22 29:36]); % extract f at short time only
signal_SV=fit_ogse_shorttime([1.72 0.57],f_SV); % best fit from S/V paper

% generate synthetic signal in long time regime (only OGSE)
f_3P=flist([8:10 22:24 36:38]); % extract f WITHOUT PGSE
truth_3P=[0.56 4.8 1.72 2.06 2.7]; % best fit for GL261 from POMACE paper
signal_3P=fit_ogse_longtime(truth_3P,f_3P);

% combine signal
F_true(1:8)=signal_SV(1:8); F_true(11:18)=signal_SV(9:16);  F_true(21:28)=signal_SV(17:24);
F_true(9:10)=signal_3P(2:3);F_true(19:20)=signal_3P(5:6);   F_true(29:30)=signal_3P(8:9);

% remove PGSE from flist
flist=[225 200 180 160 140 125 100 88 75 65]; flist=[flist flist flist];

% SNR level and number of noise iterations, counter initialization
Nnoise=3000;
SNR_list=120;
c=0;
parm_list_ogse=zeros(5,Nnoise,length(SNR_list));

for j=1:length(SNR_list)
for k=1:Nnoise

% generate noisy data with proper SNR level
noise=randn(1,30)/SNR_list(j);
F=F_true+noise;

% ====== Short time regime (2 parms to fit) =========
dat_SV=F([1:8 11:18 21:28]); % extract signal in short time regime (f >= 88 Hz)

% fit
[a1,a2,a3,a4,a5]=nlinfit(f_SV,dat_SV,@fit_ogse_shorttime,[1.7;0.6]); % fit SV
D0=a1(1);SV=a1(2); % stores results
% ===================================================

% ======= Long time regime (3 parms to fit) =========
dat_3P=F([8:10 18:20 28:30]); % extract signal in long time regime (f =< 88 Hz)

% guess uses previous D0 estimation from short time 
% D0,ecs is fixed to 2.7 um2/ms.
guess=[truth_3P(1) truth_3P(2) D0 truth_3P(4) 2.7];

% fit
 try
[a12,a22,a32,a42,a52]=nlinfitsome([false,false,true,false,true],f_3P,dat_3P,@fit_ogse_longtime,guess);
 catch
a12=[nan nan nan nan nan]; % replaces fit errors with nan
 end

c=c+1;
waitbar(c/Nnoise/length(SNR_list));

% stores best fit for each noise iteration and SNR level
parm_list_ogse(:,k,j)=a12;

end
end

% save all fit results in matlab format
save('Accuracy_SNR120_OGSE.mat', 'parm_list_ogse');