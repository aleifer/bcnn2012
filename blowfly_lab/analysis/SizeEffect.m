%% Data Loading 
Id='00';
Data=abfload(['../Data/127040' Id '.abf']);

DrumPos=Data(:,1,:);
H1Volt=Data(:,2,:);
TraialNum=size(Data,3);
%% Data Thresholding  
DrumPos=squeeze(DrumPos);

H1Volt=squeeze(H1Volt);
H1Volt(H1Volt>-0.03)=0;
H1Volt=abs(H1Volt);

%% Spike Average

TimeBinNum=100;
c=0;
for i=1:TraialNum
	% Data Chunking
    DrumPosSm=smooth(DrumPos(:,i),1000);
    [~,DrumPeakTrig]=findpeaks(DrumPosSm,'minpeakheight',5);
    SweepNum=length(DrumPeakTrig)-1;
    
    [~,SpikeTime]=findpeaks(H1Volt(:,i));
    
    % Stimulus Triggered Spiking
    for j=1:SweepNum
    c=c+1;
        TimeLength=DrumPeakTrig(j+1)-DrumPeakTrig(j);
    TimeBin=TimeLength/TimeBinNum;
    
    Bins=DrumPeakTrig(j):TimeBin:DrumPeakTrig(j+1);
    
    SpikeDistProv(c,:)=histc(SpikeTime,Bins);
    
    
    end



end
SpikeDist=zeros(c,TimeBinNum);
SpikeDist=SpikeDistProv(1:c,1:100);

%% Save and Plot

name=(['H1SizeEff' Id]);
save(name,'SpikeDist');
SpikeTimeAv=mean(SpikeDist);
SpikeTimeVar=std(SpikeDist);
figure;
plot(SpikeTimeAv,'r','LineWidth',2);
hold on;
Err=SpikeTimeAv-SpikeTimeVar;
plot(Err,'--r','LineWidth',1);
Err=SpikeTimeAv+SpikeTimeVar;
plot(Err,'--r','LineWidth',1);
hold off;
