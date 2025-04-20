function calculate_averages(num_cars, total_waiting_time, num_cars_with_waiting_time, total_inter_arrival_time, total_arrival_time, ...
                            total_time_spent_in_system, total_service_time_WB1, total_service_time_WB2, total_service_time_WB3, ...
                            num_cars_served_WB1, num_cars_served_WB2, num_cars_served_WB3, total_simulated_time_WB1, total_simulated_time_WB2, total_simulated_time_WB3)

    % Calculate average waiting time
    if total_waiting_time > 0
        average_waiting_time = total_waiting_time / num_cars_with_waiting_time; % Compute average waiting time if there is any waiting time
    else
        average_waiting_time = 0; % Set average waiting time to 0 if there is no waiting time
    end

    % Calculate average inter-arrival time
    if num_cars > 1
        average_inter_arrival_time = total_inter_arrival_time / (num_cars - 1); % Compute average inter-arrival time if there is more than one car
    else
        average_inter_arrival_time = 0; % Set average inter-arrival time to 0 if there is only one or no car
    end

    % Calculate average arrival time
    if num_cars > 1
        average_arrival_time = total_arrival_time / num_cars; % Compute average arrival time if there is more than one car
    else
        average_arrival_time = 0; % Set average arrival time to 0 if there is only one or no car
    end

    % Calculate average time spent in the system per car
    if num_cars > 0
        average_time_spent_in_system = total_time_spent_in_system / num_cars; % Compute average time spent in the system per car if there is at least one car
    else
        average_time_spent_in_system = 0; % Set average time spent in the system to 0 if there are no cars
    end

    % Calculate probability that a car owner has to wait in the queue
    if num_cars > 0
        probability_waiting = num_cars_with_waiting_time / num_cars; % Compute probability of waiting if there is at least one car
    else
        probability_waiting = 0;  % Default to 0 if there are no cars
    end

    % Calculate average service time per wash bay
    if num_cars_served_WB1 > 0
        average_service_time_WB1 = total_service_time_WB1 / num_cars_served_WB1; % Compute average service time for Wash Bay 1 if there were cars served
    else
        average_service_time_WB1 = 0;  % Set to zero if no cars were served by Wash Bay 1
    end

    if num_cars_served_WB2 > 0
        average_service_time_WB2 = total_service_time_WB2 / num_cars_served_WB2; % Compute average service time for Wash Bay 2 if there were cars served
    else
        average_service_time_WB2 = 0;  % Set to zero if no cars were served by Wash Bay 2
    end

    if num_cars_served_WB3 > 0
        average_service_time_WB3 = total_service_time_WB3 / num_cars_served_WB3; % Compute average service time for Wash Bay 3 if there were cars served
    else
        average_service_time_WB3 = 0;  % Set to zero if no cars were served by Wash Bay 3
    end
    
    % Calculate percentage of time each wash bay was busy 
    if total_simulated_time_WB1 > 0 
        percentage_time_WB1_busy = (total_service_time_WB1 / total_simulated_time_WB1) * 100; 
    else 
        percentage_time_WB1_busy = 0; 
    end 
    
    if total_simulated_time_WB2 > 0 
        percentage_time_WB2_busy = (total_service_time_WB2 / total_simulated_time_WB2) * 100; 
    else 
        percentage_time_WB2_busy = 0; 
    end
    
    if total_simulated_time_WB3 > 0
        percentage_time_WB3_busy = (total_service_time_WB3 / total_simulated_time_WB3) * 100; 
    else 
        percentage_time_WB3_busy = 0; 
    end

    

    % Display the average waiting time
    fprintf('Average Waiting Time of Car Owners: %.2f\n', average_waiting_time);
    fprintf('Average Inter-Arrival Time: %.2f\n', average_inter_arrival_time);
    fprintf('Average Arrival Time: %.2f\n', average_arrival_time);
    fprintf('Average Time Spent in the System per Car: %.2f\n', average_time_spent_in_system);
    % Display the probability of waiting
    fprintf('Probability that a car owner has to wait in the queue: %.2f\n', probability_waiting);
    % Display average service time per wash bay
    fprintf('Average Service Time for Wash Bay 1: %.2f\n', average_service_time_WB1);
    fprintf('Average Service Time for Wash Bay 2: %.2f\n', average_service_time_WB2);
    fprintf('Average Service Time for Wash Bay 3: %.2f\n', average_service_time_WB3);
    fprintf('Percentage of Time WB1 was Busy: %.2f%%\n', percentage_time_WB1_busy);
    fprintf('Percentage of Time WB2 was Busy: %.2f%%\n', percentage_time_WB2_busy);
    fprintf('Percentage of Time WB3 was Busy: %.2f%%\n', percentage_time_WB3_busy);

end
