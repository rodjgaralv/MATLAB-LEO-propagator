function data = rv2coe(yf, const)
%% Input: 
%   yf:.................Final State Vector
%   const:..............EGM2008 & WGS84 constants (R_earth (km), mu_earth(1/s), J2)
%% Output: 
%   data:...............Satellite COE data

data = struct();

r_vec = yf(1:3);
v_vec = yf(4:6);
r = norm(r_vec);
v = norm(v_vec);
mu = const.mu_earth;

% We define our angular momentum vector:
h_vec = cross(yf(1:3), yf(4:6));
h = norm(h_vec);

% We find the vector pointing to the node, if 0, orbit is equatorial. It is
% the cross product between h_vec and the unitary K vector.
n_vec = cross([0;0;1], h_vec);
n = norm(n_vec);

% Now we shall find the eccentricity vector:
e_vec = ((v^2 - mu/r)*r_vec - dot(r_vec,v_vec)*v_vec)/mu;
data.Eccentricity = norm(e_vec);


% For the semimajor axis & Semiparameter, we start by the calculation of 
% the specific mechanical energy.
xi = v^2/2 -  mu/r;
data.SemimajorAxis = -mu/(2*xi);
data.Semiparameter = data.SemimajorAxis*(1-data.Eccentricity^2);

% Now we calculate the Inclination:
data.Inclination = acos(h_vec(3)/h);

% Now the RAAN:
data.RightAscensionOfAscendingNode = acos(n_vec(1)/n);
if n_vec(2) < 0
    data.RightAscensionOfAscendingNode = 2*pi - data.RightAscensionOfAscendingNode;
end

% Now the Argument of Periapsis:
data.ArgumentOfPeriapsis = acos(dot(n_vec, e_vec)/(n*data.Eccentricity));
if e_vec(3) < 0
    data.ArgumentOfPeriapsis = 2*pi - data.ArgumentOfPeriapsis;
end

% Now the True Anomaly:
data.TrueAnomaly = acos(dot(e_vec, r_vec)/(data.Eccentricity*r));
if dot(r_vec, v_vec) < 0
    data.TrueAnomaly = 2*pi - data.TrueAnomaly;
end

% We now convert all the rad angles to deg:
data.Inclination                    = rad2deg(data.Inclination);
data.RightAscensionOfAscendingNode  = rad2deg(data.RightAscensionOfAscendingNode);
data.ArgumentOfPeriapsis            = rad2deg(data.ArgumentOfPeriapsis);
data.TrueAnomaly                    = rad2deg(data.TrueAnomaly);
end