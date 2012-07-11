Id='02';
load(['H1SizeEff' Id '.mat']);
SpikeTimeAv=mean(SpikeDist);
SpikeTimeVar=std(SpikeDist);

SpikeTimeAvSm=smooth(SpikeTimeAv)';
Jumps=diff(SpikeTimeAvSm);
Jumps(1,TimeBinNum)=SpikeTimeAvSm(1)-SpikeTimeAvSm(TimeBinNum);
[~,OffSet]=min(Jumps);
SpikeTimeAvSh=circshift(SpikeTimeAv,[0,-OffSet]);
SpikeTimeVarSh=circshift(SpikeTimeVar,[0,-OffSet]);

figure;
plot(SpikeTimeAvSh,'r','LineWidth',2);
hold on;
Err=SpikeTimeAvSh-SpikeTimeVarSh;
plot(Err,'--r','LineWidth',1);
Err=SpikeTimeAvSh+SpikeTimeVarSh;
plot(Err,'--r','LineWidth',1);
hold off;
