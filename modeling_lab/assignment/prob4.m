%Andrew Leifer
%leifer@princeton.edu
%With Vivek Venkatachalam

%Load in spike times for cell 1 of training
load('../data/cell1_train_spks.mat')
spikes=s;
clear s;

%load in stimulus for training
load('../data/stim_long_1hr.mat')
stim=s;
clear s;

STAlength=.5; %seconds

stimSampleRate=length(stim)/60/60; %number of samples per second for 1 hour of stimulus


%Convert from the spike time stamp to an index for the vector of stimuli
%values
spikeIndices=ceil(100*spikes);
spikeIndices(spikeIndices<100)=[];



%Define a vector that counts up from -n to zero where n is the number of
%samples in the STA Window +1
n=STAlength*stimSampleRate;

vec=-n:0;
extendedVec=repmat(vec,[length(spikeIndices),1] );
M=extendedVec+repmat(spikeIndices',[1 n+1]);


%Look up stimulus value in a window behind each spike point;
stimAlignedToSpike=stim(M);

%STA is just the average
STA=mean(stimAlignedToSpike);
plot( (-length(STA)+1:0)/stimSampleRate, STA);

title('Spike-Triggered Average from Training Set Cell 1');
xlabel('Time Lag (s)')
ylabel('Stimulus');

