%Andrew Leifer
%leifer@princeton.edu
%With Vivek Venkatachalam
DEBUG=false;

%% Load Data

%load in stimulus for training
load('../data/stim_long_1hr.mat')
stim=s;
clear s;

cell_number = 3; % 1-3 for the different data sets
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

%Rates are quantized into 14 bins of integer spike rate values
rate_edges = min(spikes_per_bin):max(spikes_per_bin);
p_rate = histc( spikes_per_bin, rate_edges); %distribution of rates
p_rate = p_rate/length(spikes_per_bin); % normalize


% We quantized z values into 200 bins
z_edges=linspace(min(z),max(z),200);
p_z = histc(z,z_edges); % distribution of z-values
p_z = p_z/length(z); %normalize

%% find the joind distribution.

% We need to run through the time bins of our training data and fill up the joint matrix that
% counts the number of instances of a given spike rate for a given z value.

[~,quantizedSpikeRt_indx_eachBin]=histc(spikes_per_bin,rate_edges); %Note: we are ignoring zero padding, which is OK
[~,quantizedZ_indx_eachBin]=histc(z,z_edges);
    

%initialize the joint distribution
joint_z_spikeRt=zeros(length(rate_edges),length(z_edges));

for k=1:length(spikes_per_bin)
    temp=joint_z_spikeRt(quantizedSpikeRt_indx_eachBin(k),quantizedZ_indx_eachBin(k));
    joint_z_spikeRt(quantizedSpikeRt_indx_eachBin(k),quantizedZ_indx_eachBin(k))=temp+1;  
end

%Our joint distribution of spike rates and z values in a matrix in rows and
%columns where the rows correspond to indices of spik rates, and the colums
%correspond to indices of z values, as quantized by their respective
%vectors.
joint_z_spikeRt=joint_z_spikeRt./length(spikes_per_bin); %normalize by dividing by number of bins in the simulation


%To get the probability of a rate given z, divide every column of the joint
%distribution by the probability of that z
%(each column should sum to one) (each column represents the distribution
%of spike rates for a given z value)


%probability of r given z
for k=1:size(joint_z_spikeRt,2)
 p_r_z(:,k)=joint_z_spikeRt(:,k)./p_z(k); 
end

%replace NaN's with zeros
p_r_z(isnan(p_r_z))=0;


%image conditional probability
if DEBUG
    figure; imagesc(p_r_z);
end


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


avgTestSpikeRate=mean(spikesPerTime);

%Load stimulus data
LOAD_DATA = load(['../data/stim_repeat_30s.mat']);
test_stimulus = LOAD_DATA.s;
z_stim = get_z(STA, test_stimulus);
[~,z_stim_quantized_indx]=histc(z_stim,z_edges);

%Find expected spike rate for the test z data
expectedRate=zeros(size(z_stim));
for k=1:length(z_stim)
   expectedRate(k)=dot( p_r_z(:,z_stim_quantized_indx(k)) , rate_edges);
end

figure;
plot(avgTestSpikeRate,'b');
hold on;
plot(expectedRate,'r');
%Wow it works!

%% Calculate the perecentage of the variance
err=avgTestSpikeRate(1:end-1)-expectedRate;
E=1-sum(err.^2)/sum(avgTestSpikeRate.^2);

disp(['Percentage of the varience is ' num2str(E)])
