clear

% At a fixed location, say the center, the abf files for different 
% angles are stored in a directory called 'theta_tuning'
cd '~/Documents/MATLAB/theta_tuning'
A=dir('*.abf')


% Cell h stores the desired column, for example a,  of each of the 
%recorded data in array form. *transposed!
% At this stage, unnecessary part of the data could be 
%sliced out as h{i}(low:up)
h={}
for i=1:length(A)
    [a,b,c]=abfload(A(i).name);
    h{i}=a';
end
  


% Suppose 'v_tr' is the threshold value observed to remove the noise
% from our actual response and count H-1 spikes.
v_tr=100;
g=[];
for j=1:length(h)
    g(j)=sum(h{j}>v_tr);    
end

% normalization
g/sum(g)



%'Theta_set' is the array storing our theta values. Horizontal
% orientation i.e 0 degree being the reference, sample angles in 
% the clockwise and counterclockwise direction are used.
Theta_set = [0,30] % for instance
plot(g,Theta_set,'.')


% g an array of spike counts for different theta values
% plotting g in a histogram will be as follows:
zz=[]
for j=1:length(g)
    zz(length(zz)+1:g(j)+length(zz))=Theta_set(j)

end

histfit(zz, length(zz)*2)






