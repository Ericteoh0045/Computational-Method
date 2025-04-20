function [service_types, st_probabilities, st_cdf, st_rn_range] = Car_Wash_Service_Type()
    % Define car wash service types
    service_types = {'Basic Wash  ', 'Deluxe Wash ', 'Premium Wash'}; %service_types is a array initial with three elements: 'Basic Wash ', 'Deluxe Wash ', and 'Premium Wash'.
    num_types = length(service_types); %length(3),because there are three elements in the service_types array and assign to num_types
    
    % Generate random probabilities and ensure none are zero
    random_probabilities = rand(1, num_types); %generate one random probability for each service type
    random_probabilities(random_probabilities == 0) = 0.01;
    
    % Normalize probabilities
    st_probabilities = random_probabilities / sum(random_probabilities);
    
    % Manually round probabilities to two decimal places
    st_probabilities = round(st_probabilities * 100) / 100;
    
    % Ensure no probability is 0.00 by adjusting any that rounds to zero
    st_probabilities(st_probabilities == 0) = 0.01;
    
    % Re-normalize to ensure the sum is 1
    st_probabilities = st_probabilities / sum(st_probabilities);
    
    % Adjust the last element to ensure the sum is exactly 1
    st_probabilities(end) = 1 - sum(st_probabilities(1:end-1));
    
    % Calculate the cumulative distribution function (CDF)
    st_cdf = cumsum(st_probabilities);
    
    % Ensure that CDF ends exactly at 1
    st_cdf(end) = 1;
    
    % Calculate the random number ranges based on the CDF
    st_rn_range = cell(num_types, 1); % Use cell array instead of strings
    for i = 1:num_types
        if i > 1
            range_start = floor(st_cdf(i-1) * 100) + 1;
        else
            range_start = 1;
        end
        range_end = floor(st_cdf(i) * 100); %example:range_start = 1,range_end = floor(0.18 * 100) = 18
        st_rn_range{i} = sprintf('%d - %d', range_start, range_end); %example:st_rn_range{1} = 1 - 18
    end
    
    fprintf('\n')
    disp(' Service Type = Car Wash Service Type')
    disp(' Prob = Car Wash Service Type Probabitlty')
    disp(' CDF = Car Wash Service Type Cumulative Distribution Function')
    disp(' Range = Car Wash Service Type Range')
    fprintf('\n')
    
    % Display the car wash service type table
    disp('-----------------------------------------')
    disp('Service Type  | Prob | CDF  | Range')
    disp('-----------------------------------------')
    for i = 1:length(service_types)
        fprintf(' %-12s | %.2f | %.2f | %s\n', service_types{i}, st_probabilities(i), st_cdf(i), st_rn_range{i});
    end
    disp('-----------------------------------------')
    fprintf('\n');
end
