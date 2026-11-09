%% Density recalculation
% As the density is calculated inside the ode45, it is necesary to
% calculate its value again as it is not accesible to us
if userInput.atmosModel == 0
    ro = zeros(length(t), 1);
else
    if userInput.atmosModel == 1
        ro   = zeros(length(t), 1);
        for i = 1:length(t)
            y_i = y(i,:);
            t_i = t(i);
            r_vec = y(i, 1:3);
            t_sim = satData0.Epoch + seconds(t_i);
            [yr, mnth, dy] = ymd(t_sim);
            [hr, min, sec] = hms(t_sim);
            UTCvec = [yr, mnth, dy, hr, min, sec];
            dcm = dcmeci2ecef('IAU-76/FK5', UTCvec);
            r_ecef = dcm*r_vec';
            
            ro(i) = ModelExponential(r_ecef);
        end
        archName = ['Exponential_Run','.txt'];
    elseif userInput.atmosModel == 2
        ro = zeros(length(t), 1);
        for i = 1:length(t)
            y_i = y(i,:);
            t_i = t(i);
            r_vec = y(i, 1:3);
            t_sim = satData0.Epoch + seconds(t_i);
            [yr, mnth, dy] = ymd(t_sim);
            [hr, min, sec] = hms(t_sim);
            UTCvec = [yr, mnth, dy, hr, min, sec];
            dcm = dcmeci2ecef('IAU-76/FK5', UTCvec);
            r_ecef = dcm*r_vec';

            ro(i) = ModelNRLMSISE00(t_sim, r_ecef, spaceWeatherData, yr);
        end
        archName = ['NRLMSISE00_Run','.txt'];
    end
end

%% .txt Converter
endData = [t, y, ro];

OPdir = fullfile('OUTPUT', archName);
fid = fopen(OPdir, 'w');

for i = 1:size(endData, 1)
    fprintf(fid, '%25.15f %25.15f %25.15f %25.15f %25.15f %25.15f %25.15f %25.12e\n', endData(i, :));
end

fclose(fid);

disp('.txt created');