function rho = ModelNRLMSISE00(t_sim, r_ecef, const, spaceWeatherData, yr)
%% Input: 
%   t_sim:..............Simulation Time + epoch (s)
%   r_ecef:.............Position Vector in ECEF (km)
%   const:..............EGM2008 & WGS84 constants
%   spaceWeatherData:...Pre-loaded Space Weather since 1957 (Kp and Ap index)
%   yr:.................Year of t_sim
%% Output: 
%   rho:................Resulting density (Anomalous Oxygen added)
%% General Used Variables Def
UTCseconds = hour(t_sim)*3600 + minute(t_sim)*60 + second(t_sim);
dayOfYear = day(t_sim, 'dayofyear');

%% ECEF to GEODETIC
[latitude, longitude, altitude_km] = funcecef2geodetic(r_ecef, const);
altitude = altitude_km*1000; % m

%% Space Weather Data Initial Treatment
dt = dateshift(t_sim,'start','day');
idx1 = find(spaceWeatherData.DATE == dt, 1, 'last');

%% Solar Flux Data
f107Daily = spaceWeatherData{(idx1-1), 25}; % sfu
f107Average = spaceWeatherData{idx1, 26}; % sfu

%% Magnetic Index Information
magneticIndex = magIdxFunction(t_sim, spaceWeatherData, idx1);
flags = ones(1,23);
flags(9) = -1;

%% NRLMSISE-00
% We finally use the matlab function to calculate rho
[~, rho_vec] = atmosnrlmsise00(altitude, latitude, longitude, yr, dayOfYear, UTCseconds, f107Average, f107Daily, magneticIndex, flags, 'Oxygen');

rho = rho_vec(6); % kg/m3

end