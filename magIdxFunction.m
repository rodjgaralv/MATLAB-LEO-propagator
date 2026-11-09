function magneticIndex = magIdxFunction(t_sim, spaceWeatherData, idx1)
%% Input: 
%   t_sim:..............Simulation Time (s)
%   spaceWeatherData:...Pre-loaded Space Weather since 1957 (Kp and Ap index)
%   idx1:...............Date in which the simulation takes place
%% Output: 
%   magneticIndex:......1x7 Matrix whith the diferent Ap index requiered by the atmoshwm & atmosnrlmsise00 functions
%% Space Allocation
magneticIndex = zeros(1, 7);

%% Daily magnetic index Ap
magneticIndex(1) = spaceWeatherData{idx1, 21};

%% 3-hour AP for current time, 3 hours before current time, 6 hours before 
% current time and 9 hours before current time

i = 2;
for j = 0:3:9
    t_eval = t_sim - hours(j);
    
    date_eval = dateshift(t_eval, 'start', 'day');

    idx1 = find(spaceWeatherData.DATE == date_eval, 1, 'last');
    idx2 = 13 + floor(hour(t_eval)/3);

    magneticIndex(i) = spaceWeatherData{idx1, idx2};
    i = i + 1;
end
clear i j
%% Average of eight 3-hour AP indices from 12 to 33 hours before current time
Ap_avg12To33 = 0;

for j = 12:3:33
    t_eval = t_sim - hours(j);
    
    date_eval = dateshift(t_eval, 'start', 'day');

    idx1 = find(spaceWeatherData.DATE == date_eval, 1, 'last');
    idx2 = 13 + floor(hour(t_eval)/3);

    Ap_avg12To33 = Ap_avg12To33 + spaceWeatherData{idx1, idx2};
end
magneticIndex(6) = Ap_avg12To33/8;

%% Average of eight 3-hour AP indices from 36 to 57 hours before current time
Ap_avg36To57 = 0;

for j = 36:3:57
    t_eval = t_sim - hours(j);
    
    date_eval = dateshift(t_eval, 'start', 'day');

    idx1 = find(spaceWeatherData.DATE == date_eval, 1, 'last');
    idx2 = 13 + floor(hour(t_eval)/3);

    Ap_avg36To57 = Ap_avg36To57 + spaceWeatherData{idx1, idx2};
end
magneticIndex(7) = Ap_avg36To57/8;

end