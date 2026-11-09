
% Obtaining TLE Data from .tle document:

tleArch = dir(fullfile('TLEfolder', '*.tle'));

if isempty(tleArch)
    error(['Error: No file was found"', 'TLEfolder', '".']);
else
    directory = fullfile(tleArch(1).folder, tleArch(1).name);
    satData0 = tleread(directory);   
end

satDataOg = satData0;

% Convert deg angles to rad:
satData0.Inclination                   = deg2rad(satData0.Inclination);
satData0.RightAscensionOfAscendingNode = deg2rad(satData0.RightAscensionOfAscendingNode);
satData0.ArgumentOfPeriapsis           = deg2rad(satData0.ArgumentOfPeriapsis);
satData0.MeanAnomaly                   = deg2rad(satData0.MeanAnomaly);

% CAUTION! tleread() function makes the Mean Motion orbits per second
% instead of the original value of rev/day, meaning, the units for the M.M.
% are degrees/second (as found in a Matlab error forum) meaning we must
% change from deg/sec to rad/sec, we use the prebuilt Matlab function for
% this.
satData0.MeanMotion = deg2rad(satData0.MeanMotion);

% satData0.BStar is the inverse of the Ballistic Coef. used for SGP-4 [kg/m2]

if satData0.BStar < 0
    % A negative B* will create a problem with the drag acc. making it gain
    % energy, thus, we'll use a normal value for the debris with the focus
    % on not to break the model
    BC = 0.01; % Ballistic Coef. [m2/kg]
    %error('Error: B* had a negative value. B aproximated to 0.01.');
else
    BC = (2 / 0.15696615) * satData0.BStar; % Ballistic Coef. [m2/kg]
end

satData0.B = BC;

 % We solve the Kepler Equation to obtain the Eccentric Anomaly (E) for
% this, we will use the Newton Method (Newton-Raphson Iteration).
satData0.EccentricAnomaly = KepEqtnE(satData0);

% Now we calculate the True Anomaly (nu) from the Eccentric Anomaly.
satData0.TrueAnomaly = 2*atan2(sqrt((1+satData0.Eccentricity)/...
        (1-satData0.Eccentricity))*tan(satData0.EccentricAnomaly/2),1);

% Lastly, we calculate the value of the Semimajor Axis (a) and the
% Semiparameter (p)
satData0.SemimajorAxis = (const.mu_earth/satData0.MeanMotion^2)^(1/3);
satData0.Semiparameter = satData0.SemimajorAxis*(1-satData0.Eccentricity^2);