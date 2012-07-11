addpath('../patterns');


while true
    outputBeeps(1);
    generateVidStim(640,512,100,1,180,2);
    %pause(0.5)
    generateVidStim(640,512,100,1,0,2);
    generateVidStim(640,512,100,1,180,2);
    %pause(0.5)
    generateVidStim(640,512,100,1,0,2);
    generateVidStim(640,512,100,1,180,2);
    %pause(0.5)
    generateVidStim(640,512,100,1,0,2);
end
    
