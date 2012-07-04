%Andrew Leifer
%leifer@princeton.edu
%With Vivek Venkatachalam
%Load in spike times for cell 1 of training
load('../data/cell3_test_spks.mat')


%Chop the trials at the reset from 30s to 0s
chopPoints=find(diff(s)<0);
chopPoints=[1 chopPoints length(s)];


for k=1:length(chopPoints)-1
    spikeEvents{k}= s(chopPoints(k):chopPoints(k+1));
end

%Now we need to bin the individual trials
binSize=.005;

bins = 0:binSize:30; %10 ms bins
spikesPerTime = zeros(length(spikeEvents),length(bins));

for k=1:length(spikeEvents)
    spikesPerTime(k,:)= histc(spikeEvents{k},bins);
end

meanSpkRate=mean(spikesPerTime);
varSpkRate=var(spikesPerTime);
figure;
plot(meanSpkRate,varSpkRate,'o',[0 3],[0 3]);
title('Poisson Test Cell 3');
xlabel(['Mean Spike Rate (spikes/ ' num2str(binSize*1000) 'ms)'])
ylabel(['Variance (spikes /' num2str(binSize*1000) 'ms)'])