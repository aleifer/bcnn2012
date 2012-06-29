function z = get_z(STA, stimulus)
% Takes a single feature and returns the convolution of that feature
% (time-reversed) with a stimulus.  It is assumed that the feature vector
% occurs precisely before the spike.

kernal = fliplr(STA); % kernal for "linear" part of transfer function
kernal_padded = [zeros(1,length(kernal)) kernal]; % pad with zeros to make sure the response is causal;

z = conv(stimulus, kernal_padded); % effective stimulus. Stimulus projected onto relevant direction of state space
z = z(length(kernal)+1:length(kernal)+length(stimulus)); % make z the same length of stim.  the padding will ensure that the irrelevant part gets chopped off.
end