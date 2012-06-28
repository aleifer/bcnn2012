%Load in spike times for cell 1 of training
load('../data/cell1_train_spks.mat')


bincenters=0:.01:2;
counts=histc(diff(s),bincenters);;

figure; plot(bincenters,counts)