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
pauseDuration=7;

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



%Other Parameters for the grating
spatialFreq=.05; %cycles/pixel
gaussianSigma=50; %Size of grating mask
isEndBlack=1; %Add blacmk scren at end


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





%Total number of stimuli (including repetations & spatial variations)
bigN=numStimuli*numReps; 

%Define a matrix for all unique stimuli in an arbitrary order
% Each column will correspond to a parameter for the stimuli
% Each row will be a unique stimuli

%The columns correspond to:
% xcenter, ycenter, gaussian_sigma,..
%    movieDurationSecs, angle, cyclespersecond, f, isEndBlack
numcols=8;
VELCOL=6;
XCOL=1;
YCOL=2;
THETACOL=5;
SIGMACOL=3;
DURATIONCOL=4;
SPATIALFREQCOL=7;
ISENDBLACKCOL=8;

M=zeros([bigN numcols]);

M(:,SIGMACOL)= gaussianSigma;
M(:,DURATIONCOL)=stimDuration;
M(:,SPATIALFREQCOL)= spatialFreq;
M(:,ISENDBLACKCOL)=isEndBlack;


row=1;
%Generate velocity tuning curve stimuli (theta is constant)
for v=velPoints
    for k=1:numSquares
      
        M(row,VELCOL)=v; %Set the velocity
        M(row,THETACOL)=thetaBase;
        M(row,XCOL)=xcntrs(k);
        M(row,YCOL)=ycntrs(k);
        row=row+1;

    end
end


%Generate velocity tuning curve stimuli (theta is constant)
for theta=thetaPoints
    for k=1:numSquares
      
        M(row,VELCOL)=velBase; %Set the velocity
        M(row,THETACOL)=theta;
        M(row,XCOL)=xcntrs(k);
        M(row,YCOL)=ycntrs(k);
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
    disp(['Applying stimuli ' num2str(k) ' of ' num2str(numStimuli) ' corresponding to row ' num2str(p(k)) '.']);
    M(p(k),1)
end
