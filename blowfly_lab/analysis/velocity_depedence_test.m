% A craniotamy was performed to access the right brain of a blowfly, and
% horizontal motion was presented to the left eye of the blowfly.  Motion
% associated with the H1 neuron should produce a signal for
% backward->forward motion near the left eye, which corresponds to a
% positive velocity in our convention.  The first 6 data files correspond
% to first presenting flies with forward stimuli, and then presenting them
% with reverse stimuli.  The rate is decreased monotonically (and roughly
% linearly) from run to run.  The final run corresponds to switching the
% order in which stimuli are presented.


%% Collect electrical recording data and store in MATLAB structure

% all of these runs have the same stimulus pattern with varying drum
% velocities
data{1}.file = '../Data/12702001.abf';
data{1}.velocity = 9.5; %meausred in volts

data{2}.file = '../Data/12702002.abf';
data{2}.velocity = 7.5; %meausred in volts

data{3}.file = '../Data/12702003.abf';
data{3}.velocity = 5.5; %meausred in volts

data{4}.file = '../Data/12702004.abf';
data{4}.velocity = 3.5; %meausred in volts

data{5}.file = '../Data/12702005.abf';
data{5}.velocity = 1.5; %meausred in volts

data{6}.file = '../Data/12702006.abf';
data{6}.velocity = 0.5; %meausred in volts

data{7}.file = '../Data/12702006.abf';
data{7}.velocity = -2.5; %meausred in volts [swapped directions]

% time window to get baseline reading
timeBaseline = [0.001 0.201];
% time window to determine rate of firing during first drum movment
timeForward = [.4 .6];
% time window to determine rate of firing during second drum movement
timeReverse = [1 1.2];

%voltage threshold for spike classification
voltageThreshold = -0.05; %volts.  spikes must go below this

%determines spike rates for each run using thresholding
for i=1:length(data)
    [d si h] = abfload(data{i}.file);
    time = si*1e-6*(0:size(d,1)-1);
    for j = 1:size(d,3) % loop through the individual sweeps in this measurement
        spikes = d(:,2,j);
        spikesBinary = zeros(size(spikes));
        spikesBinary(spikes < voltageThreshold) = 1;
        
        baselineIndices = ceil([interp1(time, 1:length(time), timeBaseline(1))...
                            interp1(time, 1:length(time), timeBaseline(2))]);
        forwardIndices = ceil([interp1(time, 1:length(time), timeForward(1))...
                            interp1(time, 1:length(time), timeForward(2))]);
        reverseIndices = ceil([interp1(time, 1:length(time), timeReverse(1))...
                            interp1(time, 1:length(time), timeReverse(2))]);
                        
        numberBaseline = sum(spikesBinary(baselineIndices(1):baselineIndices(2)));
        numberForward = sum(spikesBinary(forwardIndices(1):forwardIndices(2)));
        numberReverse = sum(spikesBinary(reverseIndices(1):reverseIndices(2)));
                            
        
        data{i}.baselineRate(j) = numberBaseline/range(timeBaseline);
        data{i}.forwardRate(j) = numberForward/range(timeForward);
        data{i}.reverseRate(j) = numberReverse/range(timeReverse);
    end
    
    %So far we had gotten rates for the individual forward/back sweeps in
    %each run. Now let's aggregate all the sweeps in a given run and get
    %statistics on that.
    data{i}.avgBaselineRate=mean(data{i}.baselineRate);
    data{i}.avgForwardRate=mean(data{i}.forwardRate);
    data{i}.avgReverseRate=mean(data{i}.reverseRate);
    
end

    