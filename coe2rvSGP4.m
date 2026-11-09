function y0 = coe2rvSGP4(directory)
%% Input: 
%   directory:..........TLEFolder directory
%% Output: 
%   y0:.................Initial State Vector in ECI
%% We need to introduce the two lines of the TLE to the code, implying
% we cannot use the tleread function
fidi = fopen(directory, 'rt'); % We open the file in read text mode

line1TLE = '';
line2TLE = '';
while ~feof(fidi) % loop until the end of the file is reached
    OneLine = fgetl(fidi);
    if isempty(OneLine)
        continue;
    end
    if OneLine(1) == '1'
        line1TLE = OneLine;
        line2TLE = fgetl(fidi);
        break;
    end
end
fclose(fidi);

% We now read the TLE lines:
% Extract the epoch time and other parameters from the TLE lines

yy = str2double(line1TLE(19:20)); % Start of the year
if yy >= 57
    yr = 1900 + yy;
else
    yr = 2000 + yy;
end
epoch_year = datetime(yr-1, 12, 31, 0, 0, 0);
epoch_year.TimeZone = 'UTC';
epoch_days = str2double(line1TLE(21:32)); % Days elapsed in the year
epoch_1950 = datetime(1949, 12, 31, 0, 0, 0);
epoch_1950.TimeZone = 'UTC';

epoch = days(epoch_year - epoch_1950) + epoch_days; % epoch

% We need to change our units from DEG & REV/DAY to RAD & RAD/MIN, with
% this objective in mind, we define the folowing factor
xpdotp = 1440.0 / (2.0 * pi); 

xndot = str2double(line1TLE(34:43)) / (xpdotp * 1440.0); % First derivative of mean motion (RAD/MIN)
xnddot = str2double(line1TLE(45:50))*10^(str2double(line1TLE(51:52))-5) / ...
     (xpdotp * 1440.0 * 1440.0); % Second derivative of mean motion (RAD/MIN^2)
xbstar = str2double(line1TLE(54:59))*10^(str2double(line1TLE(60:61))-5); % Bstar

xinclo = deg2rad(str2double(line2TLE(9:16))); % Inclination (RAD)
xnodeo = deg2rad(str2double(line2TLE(18:25))); % Right ascension of ascending node (RAD)
xecco = str2double(['0.', line2TLE(27:33)]); % Eccentricity
xargpo = deg2rad(str2double(line2TLE(35:42))); % Argument of perigee (RAD)
xmo = deg2rad(str2double(line2TLE(44:51))); % Mean anomaly (RAD)
xno_kozai = str2double(line2TLE(53:63))/ xpdotp; % Mean motion (RAD/MIN)

addpath('SPG4folder');

% Before we call our function, we need to define some values for the
% sgp4init function so that it knows how to correctly interpret the data we
% provide:
whichconst = 72;  % WGS72
opsmode   = 'a';  % 'a' = AFSPC. It indicates we'll use the official mathematical mode
satrec = struct();
[satrec] = sgp4init(whichconst, opsmode, satrec, epoch, xbstar, xndot, xnddot, ...
         xecco, xargpo, xinclo, xmo, xno_kozai, xnodeo);


tsince = 0.0;

[~, r0, v0] = sgp4(satrec, tsince);
y0 = zeros(6,1);
y0(1:3) = r0;
y0(4:6) = v0;
y0 = transpose(y0);
rmpath('SPG4folder');
end