% This is code to analyze spikes from blowfish H1 in response to the vision 
% stripe stimuli 

% Andy, Vivek and Frederico, BCNN 2012 Princeton, University 4 July


% one .abf data file has several runs. We call each .abf data file a 
% "recording"
stripeDesc{1}='1 increasing vertically-sized stripe band on gray background.';
stripeDesc{2}='2 horizontal stripes that increase vertically as you go across horizontally (and the vertical sum of the stripe has the same area as the previous stripe)';
stripeDesc{3}='3 horizontal stripes that increase vertically as you go across horizontally (and the vertical sum of the stripe has the same area as the previous stripe)';


recording(1).file = '../Data/12704000.abf';
recording(1).stripeID = 1; 

recording(2).file = '../Data/12704001.abf';
recording(2).stripeID = 2; 

recording(3).file = '../Data/12704002.abf';
recording(3).stripeID = 3; 

for i=1:length(recording)
    [d si h] = abfload(recording(i).file);
    data{i}=d;
end