function y0 = coe2rv(satData, const)
%% Input: 
%   satData:............Satellite COE data (Mean Anomaly and Eccentricity)
%   const:..............EGM2008 & WGS84 constants (R_earth (km), mu_earth(1/s), J2)
%% Output: 
%   y0:.................Initial State Vector in ECI
%% Local Constants Def
mu = const.mu_earth;
p = satData.Semiparameter;
nu = satData.TrueAnomaly;
e = satData.Eccentricity;
RAAN = satData.RightAscensionOfAscendingNode;
i = satData.Inclination;
ArgPer = satData.ArgumentOfPeriapsis;

%% We calculate r & v for the PQW coordinates
r_PQW = (p/(1 + e*cos(nu))) * [cos(nu); sin(nu); 0];
v_PQW = sqrt(mu/p) * [-sin(nu); e + cos(nu); 0];

%% We use rotational matrix to obtain the ijk from the pqw
function R = rot1(ang_rad)
    c = cos(ang_rad); s = sin(ang_rad);
    R = [1 0 0; 0 c s; 0 -s c];
end

function R = rot3(ang_rad)
    c = cos(ang_rad); s = sin(ang_rad);
    R = [c s 0; -s c 0; 0 0 1];
end

rotMatrix = rot3(-RAAN) * rot1(-i) * rot3(-ArgPer);

r_IJK = rotMatrix * r_PQW;
v_IJK = rotMatrix * v_PQW;


y0(1:3) = r_IJK;
y0(4:6) = v_IJK;

end