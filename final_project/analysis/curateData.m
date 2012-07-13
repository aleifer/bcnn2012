% This is a script that scans through data in each folder under ../Data.
% It uses the data stored in ".abf" format in each folder along with the
% "M" variable stored as a separate .mat file.  The output is a matlab
% variable named 'data' with the following structure:

% data(j).vpixel : velocity in pixels/s of stimulus
% data(j).theta : angle. Zero degrees is in H1 direction
% data(j).x : x-coordinate of stimulus center. (1,1) is centered in upper
%               left quadrant.  (1,2) is lower left. (2,2) is lower right.
% data(j).y : y-coordinate of stimulus center
% data(j).time : vector of time points
% data(j).voltages : vector of measured voltages

analysisDirectory = pwd;
addpath(analysisDirectory);

folders(1).directory = '../data/fly_2_run1/ascii/';
folders(1).runs = [12711016:12711177];

folders(2).directory = '../data/fly_3_run1/ascii/';
folders(2).runs = [12711190:12711314];

spatialFreq=.02; %cycles/pixel

for i=1:length(folders)
    cd(folders(i).directory);
    clear M;
    load('../rundata'); % puts the correct M in the workspace
        % M{:,1} = x-coords
        % M{:,2} = y-coords
        % M{:,3} = theta
        % M{:,4} = velocity in cyclespersecond
        % M{:,5} = duration of stimulus
        % M{:,6} = spatial frequency cycles/pixel
        % M{:,7} = white fraction (0 to 1)
        data = struct([]);
    for j=1:length(folders(i).runs)
        fileToRead = [num2str(folders(i).runs(j)) '.atf'];
        if ~exist(fileToRead,'file')
            disp(['missing file ' fileToRead])
        else
             DELIMITER = '\t';
             HEADERLINES = 10;
             newData = importdata(fileToRead, DELIMITER, HEADERLINES);
             audioTag = newData.data(:,3);
             dataIndex = getIndexFromAudio(audioTag);
            
            data(dataIndex).x = M{dataIndex,1};
            data(dataIndex).y = M{dataIndex,2};
            data(dataIndex).theta = M{dataIndex,3};
            data(dataIndex).vpixel = M{dataIndex,4}/spatialFreq;
            
             data(dataIndex).t = newData.data(:,1);
             data(dataIndex).voltage = newData.data(:,2);
             
             data(dataIndex).runNumber = j; % linear counter for run
              counter(j) = dataIndex;
        end
    end
    save('../data','data');
    cd(analysisDirectory);
end
        
        
