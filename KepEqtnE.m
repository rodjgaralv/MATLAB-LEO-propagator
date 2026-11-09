function E = KepEqtnE(satData)
%% Input: 
%   t_sim:..............Simulation Time (s)
%   satData:............Satellite COE data (Mean Anomaly and Eccentricity)
%% Output: 
%   E:..................Eccentric Anomaly
%%
tolerance = 1e-12;
M = satData.MeanAnomaly;
e = satData.Eccentricity;

% We define the starting value of our Eccentric Anomaly (En0):
if ((M>-pi) && (M<0))
    En0 = M - e;
elseif M>pi
    En0 = M - e;
else
    En0 = M + e;
end

% Newton-Raphson Iteration:
while 1
    En1 = En0 + (M - En0 + e*sin(En0))/(1 - e*cos(En0));
    
    % This if checks wether we have reached an acceptable value (tolerance)
    % or not; if not, it changes our En0 to continue looping.
    if abs(En1-En0) <= tolerance
        break;
    else
        En0 = En1;
    end
end

% Thus we find our Eccentric Anomaly Value
E = En1;
end
