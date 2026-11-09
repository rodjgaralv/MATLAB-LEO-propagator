%% Custom Run - Data File

alt = 600; % km
satData0.SemimajorAxis = const.R_earth + alt; % km
satData0.Eccentricity = 0.0014;
satData0.Semiparameter = satData0.SemimajorAxis * (1 - satData0.Eccentricity^2);
satData0.Inclination = deg2rad(53); % rad
satData0.RightAscensionOfAscendingNode = deg2rad(200); % rad
satData0.ArgumentOfPeriapsis = deg2rad(348); % rad
satData0.MeanAnomaly = deg2rad(12); % rad
satData0.EccentricAnomaly = KepEqtnE(satData0); % rad
satData0.TrueAnomaly = 2*atan2(sqrt((1+satData0.Eccentricity)/(1-satData0.Eccentricity))*tan(satData0.EccentricAnomaly/2),1); % rad
satData0.B = 0.021;

satData0.Epoch = datetime(2024, 05, 10, 00, 00, 00, 'TimeZone', 'UTC');