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



%Parameters

DEBUG=true;

screenWidth = 1280;
screenHeight=1024;

%Stim duration (in seconds)
stimDuration=10;
pauseDuration=10;

%Number of repetations per unique stimuli
numReps=1;

%How Many Locations (square root of?)
sqrtNumSquares=4;

%Velocity stimuli space
velBounds=[0 10];
velNumSteps=15;

%Angle stimuli space
thetaPoints=[180 185 175 190 170  270 90 315 45 0];


%Chose theta for the velocity tuning curve
thetaBase=180;

%Chose velocity for theta tuning curve
velBase=5;

%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Code
%%%%%%%%%%%%%%

numSquares=sqrtNumSquares^2;

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
n=(1:2:(sqrtNumSquares*2)); %Don't know why this works, but it does.
xcntrs=repmat(n.* screenWidth./(2*length(n)),...
    [sqrtNumSquares 1]);
ycntrs=repmat([n.* screenHeight./(2*length(n))]',...
    [1 sqrtNumSquares]);
if DEBUG
    figure;
        plot(screenWidth,screenHeight,'^r');
    hold on;
    plot(xcntrs,ycntrs,'o');
    xlim([0 screenWidth])
    ylim([0 screenHeight])
end



%Define a matrix for all unique stimuli in an arbitrary order
% Each column will correspond to a parameter for the stimuli
% Each row will be a unique stimuli

M=[];

%Generate velocity tuning curve stimuli (theta is constant)


for k=1:numSquares
    
end


