%% ----------------------------INITIALIZATION-----------------------------

% Q: Clear Results
promtClear = 'Clear results? (y/n) ';
clearResults = input(promtClear, "s");
if clearResults == 'y'
    clear; clc;
elseif clearResults ~= 'n' 
    error('Clear Results recieved an invalid response');
end

run structures.m;
run constants.m;
run userInputs.m;

%% ----------------------------------COE----------------------------------
if userInput.CustomRun == 'n'
    % We read the TLE data of our LEO Satellite and find the Orbital 
    % Elements asociated to it
    run tleRead.m;
else
    run simData.m
end

%% --------------------------------COE2RV---------------------------------
% Based on the Vallado's proposed algorithm in Fundamentals of
% Astrodynamics and Applications.
if userInput.CustomRun == 'n'
    y0 = coe2rvSGP4(directory);
else
    y0 = coe2rv(satData0, const);
end

%% -----------------------------PROPAGATION-------------------------------
% We define an Orbit Dynamics function where the acceleration suffered by 
% our satellite will be calculated, using Cowell's formulation to add the
% differente perturbated accelerations to our system.

% Simulation Time Definition
if userInput.simDur1 == 1 || userInput.simDur2 == 1
    T = userInput.simDur3*(2*pi*(norm(y0(1:3))/norm(y0(4:6)))); % orbits
elseif userInput.simDur2 == 2
    T = userInput.simDur3; % seconds
elseif userInput.simDur1 == 2 || userInput.simDur2 == 3
    T = userInput.simDur3*3600; % hours
elseif userInput.simDur1 == 3 || userInput.simDur2 == 4
    T = userInput.simDur3*86400; % days
end

t_span = 0:15:T;

% We obtain the Space Weather Data 
spaceWeatherData = readtable('SW-All.csv');
spaceWeatherData.DATE.TimeZone = 'UTC';

options = odeset('RelTol', 1e-12, 'AbsTol', 1e-12);
[t, y] = ode45(@(t,y) orbitDynamics(t, y, const, satData0, ...
                spaceWeatherData, userInput), t_span, y0, options);

% Finally, we obtain our final r & v vectors
yf = y(end,:);
rf = yf(1:3);
vf = yf(4:6);

%% --------------------------------RV2COE---------------------------------

% With our newly calculated rf and vf, we want to know the COE of our end
% position for our satelite.
% Based on the Vallado's proposed algorithm in Fundamentals of
% Astrodynamics and Applications.
satDataf = rv2coe(yf, const);

disp('Simulation ended');

%% --------------------------------OUTPUT---------------------------------
% We save our work in a .txt
if userInput.SaveRun == 'y'
    run outputTXT.m
end
