function random_numbers = lcg(seed, a, c, m, n)
    % Linear Congruential Generator (LCG)
    % seed - the initial seed value
    % a - the multiplier
    % c - the increment
    % m - the modulus
    % n - the number of random numbers to generate
    
    random_numbers = rand(1, n); % Preallocate array for random numbers
    X = seed; % Initialize the first value with the seed
    
    for i = 1:n
        X = mod(a * X + c, m);  % Generate the next random number using the LCG formula
        random_numbers(i) = X;
    end
    
    % Normalize to [0, 1]
    random_numbers = random_numbers / m; % Scale the random numbers to the range [0, 1]
end