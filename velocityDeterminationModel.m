function v_rel = velocityDeterminationModel(t_sim, y_eci, const, spaceWeatherData, dcm, velocityModel)
%% Input: 
%   t_sim:..............Simulation Time + epoch (s)
%   y_eci:..............State Vector in ECI (km & km/s)
%   const:..............EGM2008 & WGS84 constants (R_earth (km), mu_earth(1/s), J2)
%   spaceWeatherData:...Pre-loaded Space Weather since 1957 (Kp and Ap index)
%   dcm:................ECI to ECEF change matrix
%   velocityModel:......Velocity Model to be used
%% Output: 
%   v_rel:..............Relative Velocity Vector in ECI

%% General Used Variables Def
r_eci = y_eci(1:3);
v_eci = y_eci(4:6);

w_ecef = [0;0;const.w_earth];
w_eci = dcm' * w_ecef;
v_atmos = cross(w_eci, r_eci); % km/s

if velocityModel == 1 || velocityModel == 0
%% No Wind Model
% We consider there is no wind
    v_wind = [0;0;0];

%% Horizontal Wind Model 14 (HWM14) (0-500km)
elseif velocityModel == 2
    %% ECEF to GEODETIC
    r_ecef = dcm * r_eci; 
    [latitude, longitude, altitude_km] = funcecef2geodetic(r_ecef, const);
    altitude = altitude_km*1000; % m

    %% ap 3-hour index
    dayOfYear = day(t_sim, 'dayofyear');
    UTseconds = hour(t_sim)*3600 + minute(t_sim)*60 + second(t_sim);

    dt = dateshift(t_sim,'start','day');
    idx1 = find(spaceWeatherData.DATE == dt, 1, 'last');
    magneticIndex = magIdxFunction(t_sim, spaceWeatherData, idx1);

    %% Calculation using the HWM function of Aerospace Tools from Matlab
    v_wind_NED_array = atmoshwm(latitude, longitude, altitude, 'apindex', magneticIndex(2), 'model', 'total',  'day', dayOfYear, 'seconds', UTseconds,'version', '14'); % NED
    vw_ned = [v_wind_NED_array(1)/1000; % from m/s to km/s
                  v_wind_NED_array(2)/1000; % from m/s to km/s
                  0];
    
    %% Transformation Matrix from NED to ECEF
    rmned2ecef = [-sind(latitude)*cosd(longitude), -sind(longitude), -cosd(latitude)*cosd(longitude);
                  -sind(latitude)*sind(longitude),  cosd(longitude), -cosd(latitude)*sind(longitude);
                            cosd(latitude),                0,              -sind(latitude)];
    vw_ecef = rmned2ecef * vw_ned;
    
    %% Transformation Matrix from ECEF to ECI
    v_wind = dcm' * vw_ecef;
end
%% Final addition of the relative velocity
v_rel = v_eci - (v_atmos + v_wind); % km/s

end