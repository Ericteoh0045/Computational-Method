function wash_bay = Generate_Car_Numbers(num_cars, rng_type)
    % Generate a sequence of integers from 1 to num_cars
    car_numbers = 1:num_cars;  % Create an array of car numbers

    % Generate wash bay table with additional columns for RN Service Time and RN Service Type
    wash_bay = zeros(num_cars, 5);  % Initialize a matrix to store car numbers and random values
    wash_bay(:, 1) = car_numbers;  % First column: Car numbers

    % First row inter-arrival time is 0
    wash_bay(1, 2) = 0;  % Set the inter-arrival time of the first car to 0

    % Generate random inter-arrival times (between 1 and 1000) for remaining rows
    for i = 2:num_cars
        wash_bay(i, 2) = floor(rand * 1000) + 1;  % Generate and assign random inter-arrival times
    end

    if strcmp(rng_type, 'lcg')
        % Generate random RN Service Time (between 1 and 1000) for all rows
        for i = 1:num_cars
            wash_bay(i, 3) = floor(rand * 1000) + 1;  % Generate and assign random service times using LCG
        end
    else
        % Generate random RN Service Time (between 1 and 100) for all rows
        for i = 1:num_cars
            wash_bay(i, 3) = floor(rand * 100) + 1;  % Generate and assign random service times using default RNG
        end
    end

    % Generate random RN Service Type (between 1 and 100) for all rows
    for i = 1:num_cars
        wash_bay(i, 4) = floor(rand * 100) + 1;  % Generate and assign random service types
    end
    
    % Initialize arrival time column with zeros (5th column) 
    wash_bay(:, 5) = 0;

    % Determine the maximum width needed for car numbers, inter-arrival times, RN Service Time, and RN Service Type
    max_car_width = max(ceil(log10(wash_bay(:, 1) + 1)));  % Calculate the width for car numbers
    max_time_width = max(ceil(log10(wash_bay(:, 2) + 1)));  % Calculate the width for inter-arrival times
    max_st_width = max(ceil(log10(wash_bay(:, 3) + 1)));  % Calculate the width for service times
    max_stype_width = max(ceil(log10(wash_bay(:, 4) + 1)));  % Calculate the width for service types
    
end
