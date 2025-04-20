function [total_waiting_time, num_cars_with_waiting_time, total_inter_arrival_time, total_arrival_time, total_time_spent_in_system, ...
          total_service_time_WB1, total_service_time_WB2, total_service_time_WB3, num_cars_served_WB1, num_cars_served_WB2, num_cars_served_WB3, total_simulated_time_WB1, total_simulated_time_WB2, total_simulated_time_WB3] = ...
          calculate_car_wash_table(num_cars, wash_bay, service_times, rn_ranges, inter_arrival_times, ia_rn_ranges, service_types, st_rn_ranges)

    fprintf('\n')
    disp(' C.No = Car Number')
    disp(' RN.IAT = Random Number Inter-Arrival Time')
    disp(' IAT = Inter-Arrival Time')
    disp(' AT = Arrival Time')
    disp(' RN.STy = Random Number Service Type')
    disp(' SType = Service Type')
    disp(' RN.ST = Random Number Service Time')
    disp(' WB1.ST = Wash Bay 1 Service Time')
    disp(' WB1.TSB = Wash Bay 1 Time Service Begins')
    disp(' WB1.TSE = Wash Bay 1 Time Service Ends')
    disp(' WB2.ST = Wash Bay 2 Service Time')
    disp(' WB2.TSB = Wash Bay 2 Time Service Begins')
    disp(' WB2.TSE = Wash Bay 2 Time Service Ends')
    disp(' WB3.ST = Wash Bay 3 Service Time')
    disp(' WB3.TSB = Wash Bay 3 Time Service Begins')
    disp(' WB3.TSE = Wash Bay 3 Time Service Ends')
    disp(' WT = Waiting Time')
    disp(' TSIS = Time Spent In The System')
    fprintf('\n')
    
    disp('---------------------------------------------------------------------------------------------------------------------------------------------------------------')
    disp(' C.No| RN.IAT | IAT | AT | RN.STy | SType        |RN.ST   | WB1.ST | WB1.TSB | WB1.TSE | WB2.ST | WB2.TSB | WB2.TSE |  WB3.ST| WB3.TSB | WB3.TSE | WT | TSIS')
    disp('---------------------------------------------------------------------------------------------------------------------------------------------------------------')

    % Initialize variables for tracking wash bay service times
    WB_TSE = zeros(3, 1);  % Array to store the end times of the three wash bays
    WB_TSB = zeros(3, 1);  % Array to store the start times of the three wash bays
    
    % Initialize variables for average waiting time calculation
    total_waiting_time = 0;
    num_cars_with_waiting_time = 0;
    
    % Initialize variables for average inter-arrival time calculation
    total_inter_arrival_time = 0;
    
    % Initialize variables for average arrival time calculation
    total_arrival_time = 0;
    
    % Initialize variables for average time spent in system calculation
    total_time_spent_in_system = 0;
    
    % Initialize variables for average service time calculation for each wash bay
    total_service_time_WB1 = 0;
    total_service_time_WB2 = 0;
    total_service_time_WB3 = 0;
    num_cars_served_WB1 = 0;
    num_cars_served_WB2 = 0;
    num_cars_served_WB3 = 0;

    for car_no = 1:num_cars
        % Retrieve car data
        RN_IAT = wash_bay(car_no, 2);  % Random Number Inter-Arrival Time
        RN_ST = wash_bay(car_no, 3);   % Random Number Service Time
        RN_STy = wash_bay(car_no, 4);  % Random Number Service Type
        
        % Determine Inter-Arrival Time (IAT)
        if car_no == 1
            IAT = 0;  % First car has no inter-arrival time
        else
            for i = 1:length(inter_arrival_times)
                ranges = str2num(strrep(strrep(ia_rn_ranges{i}, ' to ', ' '), '-', ' '));
                if RN_IAT >= ranges(1) && RN_IAT <= ranges(2)
                    IAT = inter_arrival_times(i);
                    break;
                end
            end
        end
        
        if car_no == 1
            AT = 0;  % First car arrival time is 0
        else
            AT = wash_bay(car_no - 1, 5) + IAT;  % Arrival time is cumulative
        end

        % Determine Service Type (SType)
        for i = 1:length(service_types)
            ranges = str2num(strrep(strrep(st_rn_ranges{i}, ' - ', ' '), 'to', ' '));
            if RN_STy >= ranges(1) && RN_STy <= ranges(2)
                SType = service_types{i};
                break;
            end
        end

        % Determine Service Time for Wash Bays
        WB1_ST = 0; WB2_ST = 0; WB3_ST = 0;
        for i = 1:length(rn_ranges{1})
            ranges = str2num(strrep(strrep(rn_ranges{1}{i}, ' - ', ' '), 'to', ' '));
            if RN_ST >= ranges(1) && RN_ST <= ranges(2)
                WB1_ST = service_times{1}(i);
                break;
            end
        end
        for i = 1:length(rn_ranges{2})
            ranges = str2num(strrep(strrep(rn_ranges{2}{i}, ' - ', ' '), 'to', ' '));
            if RN_ST >= ranges(1) && RN_ST <= ranges(2)
                WB2_ST = service_times{2}(i);
                break;
            end
        end
        for i = 1:length(rn_ranges{3})
            ranges = str2num(strrep(strrep(rn_ranges{3}{i}, ' - ', ' '), 'to', ' '));
            if RN_ST >= ranges(1) && RN_ST <= ranges(2)
                WB3_ST = service_times{3}(i);
                break;
            end
        end

        % Calculate Arrival Time (AT)
        if car_no == 1
            AT = 0;  % First car arrival time is 0
        else
            AT = wash_bay(car_no - 1, 5) + IAT;  % Arrival time is cumulative
        end

        % Accumulate arrival time
        total_arrival_time = total_arrival_time + AT;

        % Initialize variables for tracking chosen wash bay
        chosen_wash_bay = 0;

        % Check the end times of all wash bays to find the appropriate one
        if AT >= WB_TSE(1)
            chosen_wash_bay = 1;
        elseif AT >= WB_TSE(2)
            chosen_wash_bay = 2;
        elseif AT >= WB_TSE(3)
            chosen_wash_bay = 3;
        else
            % All bays are busy, choose the soonest available bay
            [min_TSE, min_idx] = min(WB_TSE);
            service_start_time = min_TSE; % Use min_TSE as the service start time
            chosen_wash_bay = min_idx;
        end

        % Assign the car to the chosen wash bay and reset other bays' data
        if chosen_wash_bay == 1
            num_cars_served_WB1 = num_cars_served_WB1 + 1;
            % Update total service time for Wash Bay 1
            total_service_time_WB1 = total_service_time_WB1 + WB1_ST;
            if AT >= WB_TSE(1)
                WB1_TSB = AT;
            else
                WB1_TSB = service_start_time; % Use the service start time
            end
            WB1_TSE = WB1_TSB + WB1_ST;
            WB2_ST = 0; WB2_TSB = 0; WB2_TSE = 0;
            WB3_ST = 0; WB3_TSB = 0; WB3_TSE = 0;
            WB_TSE(1) = WB1_TSE;
            WB_TSB(1) = WB1_TSB;
        elseif chosen_wash_bay == 2
            num_cars_served_WB2 = num_cars_served_WB2 + 1;
            % Update total service time for Wash Bay 2
            total_service_time_WB2 = total_service_time_WB2 + WB2_ST;
            if AT >= WB_TSE(2)
                WB2_TSB = AT;
            else
                WB2_TSB = service_start_time; % Use the service start time
            end
            WB2_TSE = WB2_TSB + WB2_ST;
            WB1_ST = 0; WB1_TSB = 0; WB1_TSE = 0;
            WB3_ST = 0; WB3_TSB = 0; WB3_TSE = 0;
            WB_TSE(2) = WB2_TSE;
            WB_TSB(2) = WB2_TSB;
        else
            num_cars_served_WB3 = num_cars_served_WB3 + 1;
            % Update total service time for Wash Bay 3
            total_service_time_WB3 = total_service_time_WB3 + WB3_ST;
            if AT >= WB_TSE(3)
                WB3_TSB = AT;
            else
                WB3_TSB = service_start_time; % Use the service start time
            end
            WB3_TSE = WB3_TSB + WB3_ST;
            WB1_ST = 0; WB1_TSB = 0; WB1_TSE = 0;
            WB2_ST = 0; WB2_TSB = 0; WB2_TSE = 0;
            WB_TSE(3) = WB3_TSE;
            WB_TSB(3) = WB3_TSB;
        end

        % Calculate Waiting Time (WT) and Time Spent In System (TSIS)
        WT = max(0, WB_TSB(chosen_wash_bay) - AT);
        TSIS = WT + eval(['WB', num2str(chosen_wash_bay), '_ST']);
        wash_bay(car_no, 5) = AT;  % Update arrival time in the wash_bay matrix
        
        % Accumulate waiting time if greater than 0
        if WT > 0
            total_waiting_time = total_waiting_time + WT;
            num_cars_with_waiting_time = num_cars_with_waiting_time + 1;
        end
        
        % Accumulate inter-arrival time if not the first car
        if car_no > 1
            total_inter_arrival_time = total_inter_arrival_time + IAT;
        end
        
        % Accumulate time spent in system
        total_time_spent_in_system = total_time_spent_in_system + TSIS;
        
        % Calculate total simulated time for each wash bay 
        total_simulated_time_WB1 = max(WB_TSE(1)); 
        total_simulated_time_WB2 = max(WB_TSE(2)); 
        total_simulated_time_WB3 = max(WB_TSE(3)); 
        
        % Print formatted output
        fprintf(' %3d | %6d | %3d | %3d | %6d | %11s | %6d | %6d | %7d | %7d | %6d | %7d | %7d | %6d | %7d | %7d | %2d | %4d\n', ...
            car_no, RN_IAT, IAT, AT, RN_STy, SType, RN_ST, WB1_ST, WB1_TSB, WB1_TSE, WB2_ST, WB2_TSB, WB2_TSE, WB3_ST, WB3_TSB, WB3_TSE, WT, TSIS);
    end
    disp('---------------------------------------------------------------------------------------------------------------------------------------------------------------')
end
