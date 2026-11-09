function a =  perturbationAtmosDrag(t_sim, y_eci, const, satData, ...
                                    spaceWeatherData, dcm, yr, userInput)
%% Input: 
%   t_sim:..............Simulation Time + epoch (s)
%   y_eci:..............State Vector in ECI (km & km/s)
%   const:..............EGM2008 & WGS84 constants (R_earth (km), mu_earth(1/s), J2)
%   satData:............Ballistic Coeficient (satData.B)
%   spaceWeatherData:...Pre-loaded Space Weather since 1957 (Kp and Ap index)
%   dcm:................ECI to ECEF change matrix
%   yr:.................Year of t_sim
%   userInput:..........Velocity and Atmospheric Models to be used
%% Output: 
%   a:..................Acceleration Vector of the Atmospheric Perturbation
%% General Used Variables Def
r_ecef = dcm*y_eci(1:3);
i = norm(y_eci(1:3))-const.R_earth;

%% Determination of velocity vector
v_rel = velocityDeterminationModel(t_sim, y_eci, const, ... 
                                    spaceWeatherData, dcm, ...
                                     userInput.velocityModel); % km/s

%% Determination of density
if userInput.atmosModel == 1
    % Exponential Model (0-1000 km)
    if i < 1000
        rho = ModelExponential(r_ecef, const); % kg/m3
    else
        error('Exponential Model failed (h outside limits)');
    end
 elseif userInput.atmosModel == 2
    % NRLMSISE00 Model (90-1000 km)
    if i < 1000
        rho = ModelNRLMSISE00(t_sim, r_ecef, const, spaceWeatherData, yr); % kg/m3
    else
        error('NRLMSISE00 Model failed (h outside limits)');
    end
end

a = -0.5*rho*satData.B*norm(v_rel)*v_rel*1000; % km/s2

end