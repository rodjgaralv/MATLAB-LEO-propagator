function dy = orbitDynamics(t, y, const, satData, spaceWeatherData, userInput)
%% Input: 
%   t:..................Simulation Time (s)
%   y:..................State Vector in ECI (km & km/s)
%   const:..............EGM2008 & WGS84 constants (R_earth (km), mu_earth(1/s), J2)
%   satData:............Ballistic Coeficient (satData.B)
%   spaceWeatherData:...Pre-loaded Space Weather since 1957 (Kp and Ap index)
%   userInput:..........Velocity and Atmospheric Models to be used
%% Output: 
%   dy:.................Derivated State Vector
%% General values used
r_eci = y(1:3);
v_vec = y(4:6);
r = norm(r_eci);
epoch = satData.Epoch;
t_sim = epoch + seconds(t);

%% ECI to ECEF Matrix
[yr, mnth, dy] = ymd(t_sim);
[hr, min, sec] = hms(t_sim);
UTCvec = [yr, mnth, dy, hr, min, sec];

dcm = dcmeci2ecef('IAU-76/FK5', UTCvec);

%% Calculations
    
% We obtain the keplerian acceleration of our unperturbated system.
a = -const.mu_earth*r_eci/(r^3);
    
% We call the diferent perturbation functions:
%
% For the Geopotential, we will only take into account the J2 perturbation
% as it is the most influential perturbation out of them all
a_GeoP = perturbationGeopotential(r_eci, dcm, const);

a_Drag = perturbationAtmosDrag(t_sim, y, const, satData, ...
                                    spaceWeatherData, dcm, yr, userInput);

% Here we will add the perturbations into one perturbated acc. vector:
a_Pert1 = a_GeoP(1) + a_Drag(1);
a_Pert2 = a_GeoP(2) + a_Drag(2);
a_Pert3 = a_GeoP(3) + a_Drag(3);
a_Pert = [a_Pert1; a_Pert2; a_Pert3]; 

a_Cowell = a + a_Pert;
    
% We define our dy (dr = v; dv = a)
dy = [v_vec; a_Cowell];

end