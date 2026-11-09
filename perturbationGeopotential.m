function a = perturbationGeopotential(r_eci, dcm, const)
%% Input: 
%   r_eci:..............Position Vector in ECI (km & km/s)
%   dcm:................ECI to ECEF change matrix
%   const:..............EGM2008 & WGS84 constants (R_earth (km), mu_earth(1/s), J2)
%% Output: 
%   a:..................Acceleration Vector of the Geopotential Perturbation
%% ECI to ECEF Change
r_ecef = dcm * r_eci;

%% J2 Perturbation
r = norm(r_ecef);
x = r_ecef(1);
y = r_ecef(2);
z = r_ecef(3);

C1 = (3/2) * const.J2 * const.mu_earth * (const.R_earth^2) / (r^5);
C2 = 5 * (z^2) / (r^2);
    
% We calculate the acc. for each cartesian axis:
aJ2_x = -C1 * x * (1 - C2);
aJ2_y = -C1 * y * (1 - C2);
aJ2_z = -C1 * z * (3 - C2);

a_ecef = [aJ2_x; aJ2_y; aJ2_z];

%% ECEF to ECI acc. vec. Change
a = dcm' * a_ecef;

end