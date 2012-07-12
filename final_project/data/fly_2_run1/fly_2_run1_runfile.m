%This is a a long series of experiments that will extract tuning curves for
% H1's response to angle and velocity from visual stimuli systematically
% presented to different areas of the fly's field of view.
%
% This depends heavily on the psychophysics toolbox
% http://psychtoolbox.org/HomePage
%
% Note: Stimulus will be applied to the fly's left eye
%
% Andrew Leifer
% leifer@princeton.edu


addpath('../patterns');

%Parameters

DEBUG=false;

%Stim duration (in seconds)
stimDuration=10;
pauseDuration=7;

%Number of repetations per unique stimuli
numReps=1;


%Velocity stimuli space
velBounds=[0 10];
velNumSteps=15;

%Angle stimuli space
thetaPoints=[180 185 175 190 170  270 90 315 45 0];


%Chose theta for the velocity tuning curve
thetaBase=180;

%Chose velocity for theta tuning curve
velBase=5;


%Other Parameters for the grating
spatialFreq=.02; %cycles/pixel

%Fraction of the pattern that is white
whiteFraction = 0.5;

%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Code
%%%%%%%%%%%%%%

numSquares=9;

%Breakout the stimuli space
thetaNumSteps=length(thetaPoints);
velPoints=linspace(velBounds(1),velBounds(2),velNumSteps);

%Calculate the number of unique stimuli
% (Note here are assumption is that we will explore angle dependence at a
% constat velocity, and velocity dependence at a constant angle)

numStimuli=(thetaNumSteps+ velNumSteps)*numSquares;
totalStimDuration=stimDuration.*numStimuli*numReps;
totalExpDuration=(stimDuration+pauseDuration).*numStimuli*numReps;
disp(['Stimuli presentation should take ' num2str(totalStimDuration/60)...
    ' minutes. (' num2str(totalStimDuration/60/60)  'hours )']);
disp(['Entire experiment (including pauses) should take ' num2str(totalExpDuration/60)...
    ' minutes. (' num2str(totalExpDuration/60/60)  'hours )']);



%Find the center's of a checkerboard numSquares by numSquares 
xcntrs=[1 1.5 2 1 1.5 2 1 1.5 2];
ycntrs = [1 1 1 1.5 1.5 1.5 2 2 2];






%Total number of stimuli (including repetations & spatial variations)
bigN=numStimuli*numReps; 

%Define a matrix for all unique stimuli in an arbitrary order
% Each column will correspond to a parameter for the stimuli
% Each row will be a unique stimuli

%The columns correspond to:
% xcenter, ycenter, gaussian_sigma,..
%    movieDurationSecs, angle, cyclespersecond, f, isEndBlack
numcols=7;
VELCOL=4;
XCOL=1;
YCOL=2;
THETACOL=3;
DURATIONCOL=5;
SPATIALFREQCOL=6;
WHITECOL = 7;


clear M;


row=1;
%Generate velocity tuning curve stimuli (theta is constant)
for v=velPoints
    for k=1:numSquares
      
        M{row,VELCOL}=v; %Set the velocity
        M{row,THETACOL}=thetaBase;
        M{row,XCOL}=xcntrs(k);
        M{row,YCOL}=ycntrs(k);
        M{row,DURATIONCOL}=stimDuration;
        M{row,SPATIALFREQCOL}= spatialFreq;
        M{row,WHITECOL}=whiteFraction;
        row=row+1;

    end
end


%Generate velocity tuning curve stimuli (theta is constant)
for theta=thetaPoints
    for k=1:numSquares
      
        M{row,VELCOL}=velBase; %Set the velocity
        M{row,THETACOL}=theta;
        M{row,XCOL}=xcntrs(k);
        M{row,YCOL}=ycntrs(k);
        M{row,DURATIONCOL}=stimDuration;
        M{row,SPATIALFREQCOL}= spatialFreq;
        M{row,WHITECOL}=whiteFraction;
        row=row+1;

    end
end



if DEBUG
 figure; imagesc(M);
end

%Get a random number for the 
S=rng(1389057);
p = randperm(numStimuli);


for k=1:numStimuli
    outputBeeps(p(k));
    disp(['Applying stimuli ' num2str(k) ' of ' num2str(numStimuli) ' corresponding to row ' num2str(p(k)) '.']);
    M(p(k),1)
    generateStim(M{p(k),:});
    pause(pauseDuration);
end