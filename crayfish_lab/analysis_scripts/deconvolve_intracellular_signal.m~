%% load data
[d si] = abfload('../data/12620004.abf'); % first row of d is extracellular n3, second row is intracellular muscle
% units of d: mV
d = d';
time_per_point = si*1e-6; % in seconds
t = [0:1:(size(d,2)-1)]*time_per_point; % in seconds
intra = d(2,:); % from muscle
extra = d(1,:); % from nerve

%% remove drift in intracellular signal [likely due to some electrochemistry or charging]
highpass_time = 10; %seconds
a = time_per_point/highpass_time;

pad_length = 1e6;
intra_padded = padarray(intra,pad_length);
intra_highpass = filter([1-a a-1],[1 a-1],intra);
intra_highpass = intra_highpass(pad_length+1:end-pad_length);


figure(1); plot(t,intra,t,intra_highpass);
