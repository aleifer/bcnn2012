%Andrew Leifer
%leifer@princeton.edu
%With Vivek Venkatachalam


%% Load Data

%load in stimulus for training
load('../data/stim_long_1hr.mat')
stim=s;
clear s;

cell_number = 1; % 1-3 for the different data sets
%Load in spike times for cell 1 of training
load(['../data/cell' num2str(cell_number) '_train_spks.mat'])
spikes=s;
clear s;


%% Calculate Spike-Triggered Average [problem 4]
STAlength=.5; %seconds

stimSampleRate=length(stim)/60/60; %number of samples per second for 1 hour of stimulus


%Convert from the spike time stamp to an index for the vector of stimuli
%values
spikeIndices=ceil(100*spikes);
spikeIndices(spikeIndices<100)=[]; %hack to prevent convolving with negative indices

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

%% Make LN model [Problem 5]
z = get_z(STA, stim);

spikeIndices=ceil(100*spikes);
z_spikes = z(spikeIndices); % z values for times with spikes

%OK. So Let's come up with a scheme to bin the rates

%Quanatization vector for spike rates
spike_rate_quant=[];

%goal here is to get a vector containing the number of spikes in a 20ms sample
%window.

%To do this we are going to do some tricks. First we will take the
%cumulutive sum and interpolate that function onto the edges of the bins we
%are interested in. Then we can take the difference between cumulutive of
%spikes on the bin edges and that should yield the number spikes in each
%bin. Which, when divided by the time of each bin yields a rate.
BINWIDTH=.01; % seconds
time_edges = 0:BINWIDTH:3600; % in seconds

spikes_per_bin = zeros(1,length(time_edges)-1);
for i=1:length(spikes)
    j = ceil(spikes(i)/BINWIDTH); % index of bin to increment
    spikes_per_bin(j) = spikes_per_bin(j)+1;
end

rate_centers = min(spikes_per_bin):max(spikes_per_bin);
p_rate = hist( spikes_per_bin, rate_centers); %distribution of rates
p_rate = p_rate/length(spikes_per_bin); % normalize


[p_z z_centers] = hist(z,200); % distribution of z-values
p_z = p_z/length(z); %normalize

p_z_given_spikes = hist(z_spikes,z_centers); % distribution of z values conditional on spiking
p_z_given_spikes = p_z_given_spikes / length(z_spikes); % normalize

p_spike_given_z = get_p_spike_given_z(z_centers, p_z, p_z_given_spikes, p_spike); % use Bayes' rule to find p_spike_given_z


%% Testing how well our LN model works [Problem 6]

%Load in spike times for cell specified at the top of this file
LOAD_DATA = load(['../data/cell' num2str(cell_number) '_test_spks.mat']);
s = LOAD_DATA.s; % spike times for all the runs (concatenated)


%Chop the trials at the reset from 30s to 0s
chopPoints=find(diff(s)<0);
chopPoints=[1 chopPoints length(s)];


for k=1:length(chopPoints)-1
    spikeEvents{k}= s(chopPoints(k):chopPoints(k+1));
end

%Now we need to bin the individual trials
binSize=.01;

bins = 0:binSize:30; %10 ms bins
spikesPerTime = zeros(length(spikeEvents),length(bins));

for k=1:length(spikeEvents)
    spikesPerTime(k,:)= histc(spikeEvents{k},bins);
end

spike_rate = interp1(z_centers, p_spike_given_z, z);

%Load stimulus data
LOAD_DATA = load(['../data/stim_repeat_30s.mat']);
test_stimulus = LOAD_DATA.s;
z_stim = get_z(STA, test_stimulus);

