%Load in spike times for cell 1 of training
load('../data/cell1_train_spks.mat')

%number of spikes
N=length(s);

%lambda is the mean spike rate
lambda=N/s(end);



binwidth=.001;
bincenters=0:binwidth:2;
counts=histc(diff(s),bincenters);

%Probability of an interspike interval is the number of counts per bin
%divided by N
pISI=counts./N; 


figure; plot(bincenters,pISI)
xlabel('Time of Interval (s)')
ylabel('Probability of Spike')

hold on;
plot(bincenters,lambda.*exp(-lambda*bincenters).*binwidth,'r')
title('PDF of Inter Spike Interval Cell 1 Train Spikes')
xlim([0 .4])
text(.2,.05, ['\lambda=' num2str(mean(diff(s))) ', var=' num2str(var(diff(s)))]);
    