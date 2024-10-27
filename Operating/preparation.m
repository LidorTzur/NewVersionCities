
TargetYear = 2050;
global BaseYear;
BaseYear = 2019;
ScenarioNumber = 19; % For 2035 - make modolar!!!!!!!!!!!!!!!!!!!!!!!!!!!
Years = TargetYear-BaseYear+1; %השנים שבין שנת הבסיס לשנת המטרה

% Upload the Scenarios table
ScenariosAndValues = readtable("The Three Scenarios.xlsx",'Sheet','Scenarios','Range','A1:J21','ReadRowNames',true,'ReadVariableNames',true);

ReadValues;
TechnologicalImprovements;  

RowNames = {'Population Growth', 'Increase In Electricity Per Capita', 'Increase in Desalinated Water', 'Reducing Beef Consumption', 'Preventing Food Loss', 'Change In Energy Consumption From Renewable Energies', 'Electricity Production by Natural Gas','Electricity Saving', 'Waste Minimization','Recycle Waste', '11', 'Reducing Mileage', 'Transition To Public Transportation', 'Transition to Electric Car', 'Transition to Electric Van', 'Transition to Electric Truck', 'Transition to Electric Bus','18', 'Water Saving', 'Vegetarians'};
AllButOneAnalysis = array2table(zeros(height(ScenariosAndValues),9));
AllButOneAnalysis.Properties.RowNames = RowNames;
AllButOneAnalysis.Properties.VariableNames = {'Emissions', 'Emissions - Global', 'Emissions - Local', 'Water', 'Water - Global', 'Water - Local', 'Area', 'Area - Global', 'Area - Local'};
OnlyOneAnalysis = array2table(zeros(height(ScenariosAndValues),9));
OnlyOneAnalysis.Properties.RowNames = RowNames;
OnlyOneAnalysis.Properties.VariableNames = {'Emissions', 'Emissions - Global', 'Emissions - Local', 'Water', 'Water - Global', 'Water - Local', 'Area', 'Area - Global', 'Area - Local'};

% for SensitivityAnalysis (in runningSteps)
PopulationGrowth = {0, 0.45, 0.9};
ElectricityPerCapita = {0, 0.2, 0.41};
DesalinatedWater = {0,1.32,2.64};

%% population data
population  = array2table(zeros(4,Years));
RowNames = {'Num','Years', 'Israel population', 'Palestinian Authority population'};
pop.Properties.RowNames = RowNames;

% Update- we need to put this as a modolar input!!!!!!!!!!!!!!!!!!!!
for i =1:Years
    population(1,i) = {i};
    population(2,i) = {i+2018};
    population(3,i) = {0.209687*1.004427^(i-1)};
    population(4,i) = {0*0^(i-1)}; % No palestinian in beer sheva..

end

%%
beep;