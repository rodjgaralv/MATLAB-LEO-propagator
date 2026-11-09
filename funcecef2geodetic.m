function [lat, lon, h_ellp] = funcecef2geodetic(r, const)
%% Input: 
%   r:..................Position Vector in ECEF
%   const:..............EGM2008 & WGS84 constants (R_earth (km), R_earthPolar (km))
%% Output: 
%   h_ellp:.............Altitude over the Earth Ellipsoid
%   lon:................Geodetic Longitude
%   lat:................Geodetic Latitude

%% Data Preparation
i = r(1);
j = r(2);
k = r(3);

%% Geodetic Longitude
lon = atan2d(j, i);

%% Geodetic Latitude - Borkowski Method
delta = sqrt(i^2+j^2);
a = const.R_earth;
b = sign(k)*const.R_earthPolar;

% Cuadratic Pol. Preparation
E = (b*k - (a^2 - b^2))/(a*delta);
F = (b*k + (a^2 - b^2))/(a*delta);
P = 4*(E*F + 1)/3;
Q = 2*(E^2 - F^2);
D = P^3 + Q^2;
if D > 0
    v = nthroot(sqrt(D) - Q, 3) - nthroot(sqrt(D) + Q, 3);
else
    v = 2*sqrt(-P)*cos(1/3*acos(Q/(P*sqrt(-P))));
end
G = 0.5*(sqrt(E^2 + v) + E);
t = sqrt(G^2 + (F - v*G)/(2*G - E)) - G;

lat = atand(a*(1 - t^2)/(2*b*t));

%% Ellipsoidal Height
h_ellp = (delta - a*t)*cosd(lat) + (k - b)*sind(lat);

end