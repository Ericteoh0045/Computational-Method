function [service_times, probabilities, cdf, random_number_ranges] = Random_Service_Time(min_value, max_value, sequence_length, rng_type)
    % Fixed parameters for LCG
    a = 1664525;
    c = 1013904223;
    m = 2^32;

    % Preallocate cell arrays to hold the data for each wash bay
    service_times = cell(1, 3);
    probabilities = cell(1, 3);
    cdf = cell(1, 3);
    random_number_ranges = cell(1, 3);

    fprintf('\n')
    disp(' WB.ST = Wash Bay Service Time')
    disp(' WB.ST.Prob = Wash Bay Service Time Probability')
    disp(' WB.ST.CDF = Wash Bay Service Time Cumulative Distribution Function')
    disp(' WB.ST.Range = Wash Bay Service Time Range')
    fprintf('\n')

    for wash_bay = 1:3
        % Generate a random seed for each wash bay
        seed = rand;

        % Generate a random floating-point number between 0 and 1
        if strcmp(rng_type, 'lcg')
            random_float = lcg(seed, a, c, m, 1);
        else
            random_float = rand();
        end

        % Scale this number to the desired range and convert it to an integer
        initial_value = floor(random_float * (max_value - sequence_length + 1 - min_value + 1)) + min_value;

        % Generate the sequence of consecutive integers
        service_time = initial_value : initial_value + sequence_length - 1;

    % Generate random probabilities and normalize them
    if strcmp(rng_type, 'lcg')
        random_probabilities = lcg(seed, a, c, m, sequence_length);
    else
        random_probabilities = rand(1, sequence_length);
    end

        % Ensure that no probability is less than 0.01
        min_prob = 0.01;
        random_probabilities(random_probabilities < min_prob) = min_prob;

        probabilities_wb = random_probabilities / sum(random_probabilities);

        % Manually round probabilities to three decimal places
        probabilities_wb = round(probabilities_wb * 1000) / 1000;

        % Ensure the sum of the rounded probabilities is 1 by adjusting the last element
        probabilities_wb(end) = 1 - sum(probabilities_wb(1:end-1));

        % Calculate the cumulative distribution function (CDF)
        cdf_wb = cumsum(probabilities_wb);

        % Ensure that CDF ends exactly at 1
        cdf_wb(end) = 1;

        % Calculate the random number ranges based on the CDF
        rn_range_wb = cell(sequence_length, 1); % Use cell array instead of strings
        for i = 1:sequence_length
            if i > 1
                range_start = floor(cdf_wb(i-1) * 1000) + 1;
            else
                range_start = 1;
            end
            range_end = floor(cdf_wb(i) * 1000);
            rn_range_wb{i} = sprintf('%d to %d', range_start, range_end);
        end

        % Store the results in the cell arrays
        service_times{wash_bay} = service_time;
        probabilities{wash_bay} = probabilities_wb;
        cdf{wash_bay} = cdf_wb;
        random_number_ranges{wash_bay} = rn_range_wb;

        % Display the table for the current wash bay
        fprintf('Wash Bay %d\n', wash_bay);
        fprintf('---------------------------------------------------\n');
        fprintf(' WB%d.ST | WB%d.ST.Prob | WB%d.ST.CDF | WB%d.ST.Range\n', wash_bay, wash_bay, wash_bay, wash_bay);
        fprintf('---------------------------------------------------\n');
        for i = 1:sequence_length
            fprintf(' %-6d | %-11.3f | %-10.3f | %s\n', service_time(i), probabilities_wb(i), cdf_wb(i), rn_range_wb{i});
        end
        fprintf('---------------------------------------------------\n\n');
    end
end
