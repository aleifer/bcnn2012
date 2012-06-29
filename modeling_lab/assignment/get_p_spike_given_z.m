function output = get_p_rate_given_z(z_centers, p_z_dist, p_z_given_rate_dist, p_rate)
% finds the probability of seeing a rate at a specified value of z using
% Bayes' rule.  
% 
% p_z_dist should be the probability of getting a given value of z
% z_centers are the corresponding bin centers for p_z
%
% p_z_given_rate_dist is the conditional distribution of getting a specific
% value of z conditional on a spike rate
%
% p_rate is the absolute probability of getting a spike rate in a given time
% unit

output = zeros(size(z_centers));

for i=1:length(z_centers)
    z = z_centers(i);
    p_z = interp1(z_centers, p_z_dist, z);
    p_z_given_rate = interp1(z_centers, p_z_given_rate_dist, z);
    output(i) = p_z_given_rate * p_rate / p_z; % use Bayes' rule
end

output(isnan(output))=0;

end