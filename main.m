% main.m

rng_type = input('Choose the type of random number generator (e.g., ''rand'', ''lcg''): ', 's');

if strcmp(rng_type, 'rand') || strcmp(rng_type, 'lcg')
    % Define the parameters
    min_value = 15;         % Minimum value of the range
    max_value = 30;         % Maximum value of the range
    min_value_iat = 1;      % Minimum value of the range
    max_value_iat = 8;      % Maximum value of the range
    sequence_length = 6;    % Length of the sequence

    % Generate service times, probabilities, CDFs, and random number ranges for three wash bays
    [service_times, probabilities, cdfs, rn_ranges] = Random_Service_Time(min_value, max_value, sequence_length, rng_type);
    
    % Generate inter-arrival times, probabilities, CDFs, and random number ranges
    [inter_arrival_times, ia_probabilities, ia_cdf, ia_rn_ranges] = Inter_Arrival_Time(min_value_iat, max_value_iat, sequence_length, rng_type);
    
    % Generate car wash service types, probabilities, CDFs, and random number ranges
    [service_types, st_probabilities, st_cdf, st_rn_ranges] = Car_Wash_Service_Type();

    % Prompt the user to input the number of cars
    num_cars = input('Enter the number of cars: ');

    % Generate the sequence of car numbers and their attributes
    wash_bay = Generate_Car_Numbers(num_cars, rng_type);
    
    % Calculate and display the big table for each car
    [total_waiting_time, num_cars_with_waiting_time, total_inter_arrival_time, total_arrival_time, total_time_spent_in_system, ...
     total_service_time_WB1, total_service_time_WB2, total_service_time_WB3, num_cars_served_WB1, num_cars_served_WB2, num_cars_served_WB3, total_simulated_time_WB1, total_simulated_time_WB2, total_simulated_time_WB3] = ...
     calculate_car_wash_table(num_cars, wash_bay, service_times, rn_ranges, inter_arrival_times, ia_rn_ranges, service_types, st_rn_ranges);

    % Calculate and display the averages and probabilities
    calculate_averages(num_cars, total_waiting_time, num_cars_with_waiting_time, total_inter_arrival_time, total_arrival_time, ...
                       total_time_spent_in_system, total_service_time_WB1, total_service_time_WB2, total_service_time_WB3, ...
                       num_cars_served_WB1, num_cars_served_WB2, num_cars_served_WB3, total_simulated_time_WB1, total_simulated_time_WB2, total_simulated_time_WB3);

else 
    disp('the type should be "rand" or "lcg" ');
end