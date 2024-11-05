
%% General Inputs
global TargetYear_global;
TargetYear_global = 2050;
global BaseYear;
BaseYear = 2019;
ScenarioNumber = 19; % For 2035 - water saving
Years = TargetYear_global-BaseYear+1; %השנים שבין שנת הבסיס לשנת המטרה

%% Food lost
% The assumption was that 33% of the food manufactured is lost
global current_food_lost_global;
current_food_lost_global = 1/3;  

%% Waste incinaration values 
WasteToElectricity = 0.807; % How much waste needed to burn to get 1 kWh of electricity
IncinarationEmissionCoefficient = 1.01; % Emission coefficient of waste incineration

%% Transition to buses and trains 
TransitionToBus = 0.5;
TransitionToTrain = 1- TransitionToBus;

%% PV Data
% The maximum theoretical efficiency of a solar cell using a single p-n junction to collect power from the cell where the only loss mechanism is radiative recombination in the solar cell.
LowerBoundForArea = 6; %% according to shockley-queisser limit
PVType = 'Dual';

%% Number of rides per day we determine
global RidesPerDay_global;
RidesPerDay_global = 4;

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

% for SensitivityAnalysis (in runningSteps) - Needs to be Changed!!!!!!!!!!!!!!
PopulationGrowth = {0, 0.45, 0.9};
ElectricityPerCapita = {0, 0.2, 0.41};
DesalinatedWater = {0,1.32,2.64};

%% population data
PopulationStartYear = readtable(Data,'Sheet','Population','Range','L17:L17','ReadVariableNames',false);
PopulationStartYear = PopulationStartYear / 1000000;

GrowthRate = readtable(Data,'Sheet','Population','Range','I35:I35','ReadVariableNames',false);
GrowthRate = 1 + GrowthRate;

population  = array2table(zeros(4,Years));
RowNames = {'Num','Years', 'Israel population', 'Palestinian Authority population'};
pop.Properties.RowNames = RowNames;

% Filling the Data to every year (By option A in the excel sheet)
for i =1:Years
    population(1,i) = {i};
    population(2,i) = {i+BaseYear-1};
    population(3,i) = {PopulationStartYear*GrowthRate^(i-1)};
    population(4,i) = {0*0^(i-1)}; % No palestinian in beer sheva..

end

%%
beep;