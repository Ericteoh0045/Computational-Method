function [inter_arrival_times, probabilities, cdf, random_number_ranges] = Inter_Arrival_Time(min_value_iat, max_value_iat, sequence_length, rng_type)
    % Fixed parameters for LCG
    a = 1664525;     % Multiplier for LCG
    c = 1013904223;  % Increment for LCG
    m = 2^32;        % Modulus for LCG
    seed = rand;     % Initial seed value using built-in rand

    % Generate a random floating-point number between 0 and 1
    if strcmp(rng_type, 'lcg')
        random_float = lcg(seed, a, c, m, 1);  % Use LCG for random number
    else
        random_float = rand();                 % Use built-in rand function
    end
    
    % Scale this number to the desired range and convert it to an integer
    % Calculate the initial value for the inter-arrival times sequence
    initial_value = floor(random_float * (max_value_iat - sequence_length + 1 - min_value_iat + 1)) + min_value_iat;
    
    % Generate the sequence of consecutive integers
    % Create a sequence of inter-arrival times
    inter_arrival_times = initial_value : initial_value + sequence_length - 1;
    
    % Generate random probabilities
    if strcmp(rng_type, 'lcg')
        random_probabilities = lcg(seed, a, c, m, sequence_length);  % Use LCG
    else
        random_probabilities = rand(1, sequence_length);             % Use built-in rand function
    end
    
    % Ensure that no probability is less than 0.003 and the first probability is not too low or too high
    min_prob = 0.01;  % Minimum probability
    max_prob = 0.999; % Maximum probability
    random_probabilities(random_probabilities < min_prob) = min_prob; % Set lower bound
    if random_probabilities(1) < min_prob || random_probabilities(1) > max_prob
        random_probabilities(1) = rand() * (max_prob - min_prob) + min_prob; % Adjust first probability
    end
    
    % Normalize the probabilities so they sum to 1
    probabilities = random_probabilities / sum(random_probabilities);
    
    % Manually round probabilities to three decimal places
    probabilities = round(probabilities * 1000) / 1000;
    
    % Ensure the sum of the rounded probabilities is 1 by adjusting the last element
    probabilities(end) = 1 - sum(probabilities(1:end-1));
    
    % Calculate the cumulative distribution function (CDF)
    cdf = cumsum(probabilities);
    
    % Ensure that CDF ends exactly at 1
    cdf(end) = 1;
    
    % Calculate the random number ranges based on the CDF
    random_number_ranges = cell(sequence_length, 1); % Use cell array instead of strings
    for i = 1:sequence_length
        if i > 1
            range_start = floor(cdf(i-1) * 1000) + 1; % Start of range
        else
            range_start = 1; % First range starts at 1
        end
        range_end = floor(cdf(i) * 1000); % End of range
        random_number_ranges{i} = sprintf('%d to %d', range_start, range_end); % Store range as string
    end
    
    fprintf('\n')
    disp(' IAT = Inter-Arrival Time')
    disp(' IAT.Prob = Inter-Arrival Time Probability')
    disp(' IAT.CDF = Inter-Arrival Time Cumulative Distribution Function')
    disp(' IAT.Range = Inter-Arrival Time Range')
    fprintf('\n')
    
    % Display the inter-arrival time table
    disp('---------------------------------------')
    disp('IAT | IAT.Prob | IAT.CDF  | IAT.Range')
    disp('---------------------------------------')
    for i = 1:sequence_length
        fprintf('%-2d  | %.3f    | %.3f    | %s\n', inter_arrival_times(i), probabilities(i), cdf(i), random_number_ranges{i});
    end
    disp('---------------------------------------')
    fprintf('\n');
end
