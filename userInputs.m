%% Atmos. Model
promt1 = 'Atmospheric Model:\n 1 - Exponential\n 2 - NRLMSISE00\nInput: ';
userInput.atmosModel = input(promt1);
if isbetween(userInput.atmosModel, 1, 2) ~= 1
    error('Atmospheric Model outside limits (1 to 2)');
end

%% Velocity Model
promt2 = 'Velocity Model:\n 1 - Co-rotational\n 2 - HWM14\n Input: ';
userInput.velocityModel = input(promt2);
if isbetween(userInput.velocityModel, 1, 2) ~= 1
    error('Velocity Model outside limits (1 or 2)');
end

%% Simulation Duration

promt3 = 'Customized or pre-established simulation duration?\n 1 - 1 orbit\n 2 - 24 hours\n 3 - 30 days\n 4 - Customized\n Input: ';
userInput.simDur1 = input(promt3);
if isbetween(userInput.simDur1, 1, 4) ~= 1
    error('Outside limits (1 to 4)');
end

if userInput.simDur1 == 3 && userInput.atmosModel == 2
    if userInput.velocityModel ~= 3
        warning('Expected Simulation Run Time of 10 or more minutes');
    else
        warning('Expected Simulation Run Time of 20 or more minutes');
    end
end

if userInput.simDur1 == 4
    promt4 = 'Introduce the desired unit of time:\n 1 - Orbits\n 2 - Seconds\n 3 - Hours\n 4 - Days\n Input: ';
    userInput.simDur2 = input(promt4);
    if isbetween(userInput.simDur2, 1, 4) ~= 1
        error('Outside limits (1 to 4)');
    end

    promt5 = 'Introduce the desired amout of the unit of choice: ';
    userInput.simDur3 = input(promt5);
else
    userInput.simDur2 = 0;
    if userInput.simDur1 == 2
        userInput.simDur3 = 24;
    elseif userInput.simDur1 == 3
        userInput.simDur3 = 30;
    else
        userInput.simDur3 = 1;
    end
end

%% Q: Save Run
promtSave ='Save Run? (y/n) ';
userInput.SaveRun = input(promtSave, "s");
if userInput.SaveRun ~= 'n' &&  userInput.SaveRun ~= 'y'
    error('Save Run recieved an invalid response');
end

%% Q: Customized Run
promtCustom ='Customized Run? (y/n) ';
userInput.CustomRun = input(promtCustom, "s");
if userInput.CustomRun ~= 'n' &&  userInput.CustomRun ~= 'y'
    error('Save Run recieved an invalid response');
end