function [AllButOneScenariosTable] = AllButOneChangesByScenarios(Data, ScenarioNumber, Years, S, varargin)
% S is the vector of changes precentages

global BaseYear;
global current_food_lost_global; % The assumption was that 33% of the food manufactured is lost 

%% Bring to current situation - 2020
YearsAfterAnalysis = 2020 - BaseYear; % changed from 4 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% these data needs to be changed by the scenario we decide (taken from "The Three Scenarion- column "BAU"
%PopulationGrowth = 0.0484;
RenewableEnergies = 0.06;
NaturalGas = 0.68;
EV = 0.06;
electricity_production_by_renewable_resources = 0.3;

%% Init
% input object that helps manage the function inputs
q = inputParser;
% Add an optional parameters to the input. If there is none of them the defult is "False"
addOptional(q,'OnlyOne',false);
addOptional(q,'MileStones',false);
% Check what the actual inputs the user gave, and assign it to the q object
parse(q,varargin{:});

%% Prep
% Define the current situation of the "Distribution Of Electricity
% Consumption Sources (%)" from the "ElectricityConsumption" sheet.
CurrentEnergyConsumptionFromRenewableEnergies = Data.InitialPercentage(3);
CurrentEnergyConsumptionFromNaturalGas = Data.InitialPercentage(2);

% Define the scenarios parameters inputs 
RowNames = {'Population Growth', 'Increased Electricity Per Capita', 'Increase in Desalinared Water', 'Reducing Beef Consumption', 'Preventing Food Loss', 'Change In Energy Consumption From Renewable Energies', 'Electricity Production by Natural Gas','Electricity Saving','Fuel for Energy','Recycled Waste', 'Burning Waste', 'Reduction Of Mileage', 'Transition To Public Transportation', 'Transition to Electric Car', 'Transition to Electric Van', 'Transition to Electric Truck', 'Transition to Electric Bus','18', 'Water Saving', 'Vegetarians'};
ChangesNumRows = numel(RowNames); %% Lidor changes
ColumnNames = ones(1, Years);
AllButOneScenariosTable = array2table(zeros(length(S), Years), 'RowNames', RowNames);
%%ConsumptionChanges = array2table(zeros(sum(Type == "Consumption"), Years),'RowNames', RowNames(Type == 'Consumption'));
for i = 1:width(ColumnNames)
    ColumnNames(i) = (BaseYear-1)+i; 
end
ColumnNames = string(ColumnNames);
AllButOneScenariosTable.Properties.VariableNames = ColumnNames;
%%ConsumptionChanges.Properties.VariableNames = ColumnNames;

%% choose measures
% what is it????!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
ChooseSteps = 6 ;
%{ 
% in comma for running faster
if(ScenarioNumber == 0)
ChooseSteps = choiceList('Select a scenario','Choose one of the scenarios and follow the instructions.', {'Population Growth','Electricity Per Capita','Desalinated Water','Beef Consumption','Food Loss', 'All'}); 
    if(ChooseSteps==6)
        ChooseSteps = 1:1:length(S);
    else
        if(ChooseSteps(1) < 0)
            Delete = ChooseSteps(1);
            ChooseSteps = 1:1:length(S);
            ChooseSteps(-1*Delete) = [];
        end
    end

    for i = 1:height(AllButOneScenariosTable)
        if (~ismember(i,ChooseSteps))
            S(i) = 0;
        end
    end
    
end

%}

if(ScenarioNumber ~= 0 && q.Results.OnlyOne == true)
    ChooseSteps = [ScenarioNumber];
elseif(ScenarioNumber ~= 0 && q.Results.OnlyOne == false)
    Delete = ScenarioNumber;
    ChooseSteps = 1:1:length(S);
    ChooseSteps(Delete) = [];
end

% Specific Changes
MilesTonesTable = array2table(zeros(ChangesNumRows, Years));
% MilesTonesTable{6,14} = 0.3;
% MilesTonesTable{7,14} = 0.7;

if(q.Results.MileStones == true)
for i = 1:height(AllButOneScenariosTable)
    if(~ismember(i, ChooseSteps))
        continue;
    end
    defvalues = cell(1, Years);
    defvalues(:) = {'0'};
    formatspec = 'Milestones in Measure %s';
    title = sprintf(formatspec, RowNames{1,i});
    dims = [1 35];
    prompt = {'Enter year then value'};
    answer = inputdlg(prompt,...
        title', dims, defvalues, 'on');
    answer = answer{1};
     if(strcmp(answer, '0'))
         continue;
     else     
        user_val = strsplit(answer, ', ');
        temp = zeros(1, length(user_val));
        for j = 1:length(temp)
            temp(j) = str2double(user_val{j});
        end
        for j = 1:2:length(temp)
            MilesTonesTable{i,temp(j)-(BaseYear-1)} = temp(j+1); 
        end  
     end
     disp('');
%     pmt = "Choose Change Type:" + newline + "Step" + newline + "Linear" + newline + "Exponential";
%     Types{i} = inputdlg(pmt, 'Growth Type', [1 35]);
end
end

%% Consumption
% put the change in consumption by parameter to every year, until the target year
AllButOneScenariosTable{1,:} = CalcChangeVector(MilesTonesTable{1,:}, Years, S(1));
AllButOneScenariosTable{2,:} = CalcChangeVector(MilesTonesTable{2,:}, Years, S(2));
AllButOneScenariosTable{3,:} = CalcChangeVector(MilesTonesTable{3,:}, Years, S(3), 'Type', 'Linear','Growth', false);
AllButOneScenariosTable{8,:} = CalcChangeVector(MilesTonesTable{8,:}, Years, S(8), 'Growth', false);
AllButOneScenariosTable{9,:} = CalcChangeVector(MilesTonesTable{9,:}, Years, S(9), 'Growth', false);
AllButOneScenariosTable{12,:} = CalcChangeVector(MilesTonesTable{12,:}, Years, S(12), 'Growth', false);
AllButOneScenariosTable{13,:} = CalcChangeVector(MilesTonesTable{13,:}, Years, S(13), 'Growth', false);
AllButOneScenariosTable{19,:} = CalcChangeVector(MilesTonesTable{19,:}, Years, S(19), 'Growth', false);
AllButOneScenariosTable{20,:} = CalcChangeVector(MilesTonesTable{20,:}, Years, S(20), 'Growth', false);


%% Supply 
% Reducing beef consumption
AllButOneScenariosTable{4,:} = CalcChangeVector(MilesTonesTable{4,:}, Years, S(4) ,'Growth', false);
FoodPercentageActuallyConsumed = current_food_lost_global-S(5); 
% Preventing food lost
AllButOneScenariosTable{5,:} = CalcChangeVector(MilesTonesTable{5,:}, Years, FoodPercentageActuallyConsumed, 'Growth', false);
%electricity production by renewable resources
MilesTonesTable{6, 1} = CurrentEnergyConsumptionFromRenewableEnergies;
AllButOneScenariosTable{6,1} = CurrentEnergyConsumptionFromRenewableEnergies;
% AllButOneScenariosTable{6,Years-5} = (AllButOneScenariosTable{6,Years}-AllButOneScenariosTable{6, 1})/2; %% according to iea - in 2025 we need to be halfway
% MilesTonesTable{6,Years-5} = (AllButOneScenariosTable{6,Years}-AllButOneScenariosTable{6, 1})/2;
% The change in electricity production by renewable resources by the scenario
MilesTonesTable{6,Years} = S(6);

% Put the value of the current year RenewableEnergies that we define in the head of this code
MilesTonesTable{6,YearsAfterAnalysis} = RenewableEnergies;

AllButOneScenariosTable{6,:} = CalcChangeVector(MilesTonesTable{6,:}, Years, S(6));

% 2020 value - defind in the head of this code (renewable resources)
MilesTonesTable{6,14} = electricity_production_by_renewable_resources;

% reduce 1 from every year renewable resources value, why?!!!!!!!!!!!!!!!!!!!!
for i = 1:Years
    AllButOneScenariosTable{6, i} = AllButOneScenariosTable{6, i} - 1;
end

MilesTonesTable{7, 1} = CurrentEnergyConsumptionFromNaturalGas;
% AllButOneScenariosTable{6,Years-5} = (AllButOneScenariosTable{6,Years}-AllButOneScenariosTable{6, 1})/2; %% according to iea - in 2025 we need to be halfway
% MilesTonesTable{6,Years-5} = (AllButOneScenariosTable{6,Years}-AllButOneScenariosTable{6, 1})/2;
MilesTonesTable{7,Years} = S(7); % The last value (2050 value)
MilesTonesTable{7,YearsAfterAnalysis} = NaturalGas; % 2020 value- defined in the head of this code
% Calculate the value of change in electricity by natural gas  to all years
AllButOneScenariosTable{7,:} = CalcChangeVector(MilesTonesTable{7,:}, Years, S(7));

% Again reduce 1 from every year gas resource value, why?!!!!!!!!!!!!!!!!!!!!
for i = 1:Years
    AllButOneScenariosTable{7, i} = AllButOneScenariosTable{7, i} - 1;
end

% In the same way we define the value of recycled waste and burning waste change to the last year (2050)
AllButOneScenariosTable{10,:} = CalcChangeVector(MilesTonesTable{10,:}, Years, S(10));
AllButOneScenariosTable{11,:} = CalcChangeVector(MilesTonesTable{11,:}, Years, S(11));

% The value of 2020
MilesTonesTable{14,YearsAfterAnalysis} = EV; 

% Calculate the value of electric private vehicle change to the all years
AllButOneScenariosTable{14,:} = CalcChangeVector(MilesTonesTable{14,:}, Years, S(14));

% Again reduce 1 from every year electric private vehicle value, why?!!!!!!!!!!!!!!!!!!!!
for i = 1:Years
    AllButOneScenariosTable{14, i} = AllButOneScenariosTable{14, i} - 1;
end

% electric van vehicle
AllButOneScenariosTable{15,:} = CalcChangeVector(MilesTonesTable{15,:}, Years, S(15));
for i = 1:Years
    AllButOneScenariosTable{15, i} = AllButOneScenariosTable{15, i} - 1;
end

% electric truck vehicle
AllButOneScenariosTable{16,:} = CalcChangeVector(MilesTonesTable{16,:}, Years, S(16));
for i = 1:Years
    AllButOneScenariosTable{16, i} = AllButOneScenariosTable{16, i} - 1;
end

% electric bus vehicle
AllButOneScenariosTable{17,:} = CalcChangeVector(MilesTonesTable{17,:}, Years, S(17));
for i = 1:Years
    AllButOneScenariosTable{17, i} = AllButOneScenariosTable{17, i} - 1;
end

% water saving- why?!!!!!!!!!!!!!!!!!! I think because it (the consumption through the years) doesn't changed
AllButOneScenariosTable{18,:} = 1;



%% Specific Changes
if(q.Results.OnlyOne == false && ScenarioNumber ~= 0)
switch ScenarioNumber
    case 1
        AllButOneScenariosTable{1,:} = 1;
        AllButOneScenariosTable{3,:} = 1;
    case 2
        AllButOneScenariosTable{2,:} = 1;
    case 3
    case 4
        AllButOneScenariosTable{4,:} = 1;
    case 5
        AllButOneScenariosTable{5,:} = 1;
    case 6
        AllButOneScenariosTable{7,:} = AllButOneScenariosTable{6,:};
        AllButOneScenariosTable{6,:} = CurrentEnergyConsumptionFromRenewableEnergies;
    case 7
        AllButOneScenariosTable{7,:} = CurrentEnergyConsumptionFromNaturalGas;
        for i = 1:Years
            if(AllButOneScenariosTable{6,i} > (1-CurrentEnergyConsumptionFromNaturalGas))
                AllButOneScenariosTable{6,i} = (1-CurrentEnergyConsumptionFromNaturalGas);
            end    
        end    
    case 8
        AllButOneScenariosTable{8,:} = 1;
    case 9
        AllButOneScenariosTable{9,:} = 1;
    case 10
        AllButOneScenariosTable{10,:} = 1;
    case 12
        AllButOneScenariosTable{12,:} = 1;
    case 13
        AllButOneScenariosTable{13,:} = 1;
    case 14
        AllButOneScenariosTable{14,:} = 0;
    case 15
        AllButOneScenariosTable{15,:} = 0;
    case 16
        AllButOneScenariosTable{16,:} = 0;
    case 17
        AllButOneScenariosTable{17,:} = 0;
    case 19
        AllButOneScenariosTable{19,:} = 1;
    otherwise
end
elseif(q.Results.OnlyOne == true)
    ZerosLines = [14 15 16 17];
    flag = false;
    for j = 1:height(AllButOneScenariosTable)
        if(j==1 && j==ScenarioNumber)
            flag = true;
        elseif(j==ScenarioNumber && j~=3)
            continue;
        elseif(j==6)
            AllButOneScenariosTable{6,:} = CurrentEnergyConsumptionFromRenewableEnergies;
        elseif(j==7)
            AllButOneScenariosTable{7,:} = CurrentEnergyConsumptionFromNaturalGas;
        elseif(ismember(j,ZerosLines) == true)
            AllButOneScenariosTable{j,:} = 0;
        else
            if(flag == true && j == 3)
                % is the population grow allows theincreade in desalination
                continue;
            else
                AllButOneScenariosTable{j,:} = 1;
            end    
        end
    end

end
end
%% other functions

function PercentVector = CalcChangeVector(MileStoneVector, Years, S, varargin)
p = inputParser;
% The type of calculation (default is 'Exponential').
addOptional(p,'Type','Exponential');
% Whether the calculation involves growth (default is true).
addOptional(p,'Growth',true);
parse(p,varargin{:});

% The function checks the chosen calculation type:
%If the type is 'Exponential', it calls the Exponential function.
%If the type is 'Linear', it calls the Linear function.
%If the type is 'Step', it calls the Step function.
%If an invalid type is provided, it returns a vector of zeros with a length equal to Years.
if(strcmp(p.Results.Type, 'Exponential'))
    PercentVector = Exponential(MileStoneVector, Years, S, p.Results.Growth);
elseif(strcmp(p.Results.Type, 'Linear'))
    PercentVector = Linear(MileStoneVector, Years, S, p.Results.Growth);
elseif(strcmp(p.Results.Type, 'Step'))
    PercentVector = Step(MileStoneVector, Years, S, p.Results.Growth);
else
    PercentVector = zeros(1,Years);
end
end

% exponential
function [PercentVector] = Exponential(MileStoneVector, Years, S, Growth)
PercentVector = ones(1,Years);
if Growth == 1
    PercentVector(Years) = 1+S;
    MileStoneVector(Years) = S;
else
    PercentVector(Years) = 1-S;
    MileStoneVector(Years) = -1*S;
end
StartYear = 1;
for i = 1:length(MileStoneVector)
    if(MileStoneVector(i) ~= 0)
        EndYear = i;
        GrowthVector = GrowthVectorCalc(StartYear, EndYear, MileStoneVector(i), MileStoneVector(StartYear));
        for j = 1:length(GrowthVector)
            PercentVector(StartYear+j-1) = GrowthVector(j);
        end
        StartYear = i;
    end
end
end

function GrowthVector = GrowthVectorCalc(StartYear, EndYear, EndYearVal, StartYearVal)
%The function takes four parameters:
%StartYear: The year the calculation starts.
%EndYear: The year the calculation ends.
%EndYearVal: The value at the end year.
%StartYearVal: The value at the start year.

%%The function calculates the length of the period between the start and end years, including both.
Period = EndYear-StartYear+1; 

%A vector named GrowthVector is created and filled with ones, with a length equal to the period.
%The first value in the vector is set to 1+StartYearVal
%The last value in the vector is set to 1+EndYearVal
GrowthVector = ones(1, Period);
GrowthVector(1) = 1 + StartYearVal;
GrowthVector(Period) = 1 + EndYearVal;

%The last value is stored in FutureValue.
FutureValue = GrowthVector(Period);

%The growth rate is calculated by taking the nth root of the ratio between the future value and the initial value, divided by the number of years minus one.
Rate = nthroot(FutureValue/GrowthVector(1),Period-1);

% A loop fills the GrowthVector, where each value is calculated based on the starting value and the 
% growth rate. Each value is determined by multiplying the starting value by the growth rate raised 
% to the power of (i-1).
for i = 1:Period
    GrowthVector(i) = GrowthVector(1)*((Rate)^(i-1));
end
end


%Step
function [PercentVector] = Step(MileStoneVector, Years, S, Growth)
PercentVector = ones(1,Years);
if Growth == 1
    PercentVector(Years) = 1+S;
    MileStoneVector(Years) = S;
else
    PercentVector(Years) = 1-S;
    MileStoneVector(Years) = -1*S;
end
StartYear = 1;
for i = 1:length(MileStoneVector)
    if(MileStoneVector(i) ~= 0)
        EndYear = i;
        GrowthVector = StepCalc(StartYear, EndYear, MileStoneVector(i));
        for j = 1:length(GrowthVector)
            PercentVector(StartYear+j-1) = GrowthVector(j);
        end
        StartYear = i;
    end
end
end

function GrowthVector = StepCalc(StartYear, EndYear, EndYearVal)
Period = EndYear-StartYear+1;
GrowthVector = ones(1, Period)+EndYearVal;
end

%linear
function [PercentVector] = Linear(MileStoneVector, Years, S, Growth)
PercentVector = ones(1,Years);
if Growth == 1
    PercentVector(Years) = 1+S;
    MileStoneVector(Years) = S;
else
    PercentVector(Years) = 1-S;
    MileStoneVector(Years) = -1*S;
end
MileStoneVector(Years) = S;
StartYear = 1;
for i = 1:length(MileStoneVector)
    if(MileStoneVector(i) ~= 0)
        EndYear = i;
        GrowthVector = LinearCalc(StartYear, EndYear, MileStoneVector(i),MileStoneVector(StartYear));
        for j = 1:length(GrowthVector)
            PercentVector(StartYear+j-1) = GrowthVector(j);
        end
        StartYear = i;
    end
end
end

function GrowthVector = LinearCalc(StartYear, EndYear, EndYearVal,StartYearVal)
    Period = EndYear-StartYear+1;
    GrowthVector = ones(1, Period);
    GrowthVector(1) = 1 + StartYearVal;
    GrowthVector(Period) = 1+EndYearVal;
    if(EndYearVal > StartYearVal)
        Rate = (EndYearVal-StartYearVal)/(Period-1);
    else
        Rate = -1*(StartYearVal-EndYearVal)/Period;
    end
    for i = 1:Period
        GrowthVector(i) = GrowthVector(1)+Rate*(i-1);
    end
end
