%% Data Loading 

Data=abfload('../Data/12704014.abf');
DrumPos=Data(:,1,:);
H1Volt=Data(:,2,:);
TraialNum=size(Data,3);
%% Data Thresholding  
DrumPos=squeeze(DrumPos);

H1Volt=squeeze(H1Volt);
H1Volt(H1Volt>-0.03)=0;
H1Volt=abs(H1Volt);
TimeBinNum=100;

SpikeTimeAv=zeros(1,TimeBinNum);
c=0;
for i=1:TraialNum
	DrumPosSm=smooth(DrumPos(:,i),1000);
    [~,DrumPeakTrig]=findpeaks(DrumPosSm,'minpeakheight',5);
    SweepNum=length(DrumPeakTrig)-1;
    [~,SpikeTime]=findpeaks(H1Volt(:,i));
    
    
    for j=1:SweepNum
    TimeLength=DrumPeakTrig(j+1)-DrumPeakTrig(j);
    TimeBin=TimeLength/TimeBinNum;
    
    Bins=DrumPeakTrig(j):TimeBin:DrumPeakTrig(j+1);
    
    SpikeDist=histc(SpikeTime,Bins);
    SpikeTimeAv=SpikeTimeAv+SpikeDist(:,1:TimeBinNum);
    c=c+1;
    end



end

SpikeTimeAv=SpikeTimeAv./c;

figure;
plot(SpikeTimeAv);
