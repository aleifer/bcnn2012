function outputBeeps(n)
% This sends a number to the audio jack encoded as a binary signal of 
% Where 1 is one, and 0 is one/hafl..
DEBUG=true;

Fs = 2000;      % Samples per second
nSeconds = 2;   % Duration of the sound
x=linspace(0,1,round(nSeconds*Fs));
y=zeros(size(x));

toneFreq = 500;  % Tone frequency, in Hertz

carrier= sin(linspace(0,nSeconds*toneFreq*2*pi,round(nSeconds*Fs)));




%amplitude for zero and one
amp1=1;
amp0=0.5;

bitDuration=.1; %in seconds

numSamplesPerBit=round(bitDuration*Fs); %No spacing

%Create a binary string showing the number n
str = dec2bin(n);

xindx=1;


for k=1:length(str) % for each character int eh string
    if strcmp(str(k),'1') %one
        y(xindx:xindx+numSamplesPerBit)=amp1;
        xindx=xindx+numSamplesPerBit; %increment xindx coutner
    else % zero
        y(xindx:xindx+numSamplesPerBit)=amp0;
        xindx=xindx+numSamplesPerBit; %increment xindx coutner
    end
    
    %Add pause
        y(xindx:xindx+numSamplesPerBit)=0;
        xindx=xindx+numSamplesPerBit; %increment xindx coutner
end
sound(y.*carrier,Fs);  % Play sound at sampling rate Fs

if DEBUG
    figure; plot(x,y.*carrier)
end