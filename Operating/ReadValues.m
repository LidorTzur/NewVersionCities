%% Create all the Sectors tables for all the years from the base to the target year
%% Read Files  - needs to convert to function
addpath("Scenarios");
addpath("CalcFunctions");
addpath("UI");
addpath("Data");

DataBase = struct();
Data = "Data.xlsx";

%% Electricity Consumption - UPDATED 
RowNames = {'Home', 'Public & Commercial', 'Industrial', 'Other', 'Transportation', 'Water Supply and Seweage Treatment', 'Total'};
% create a table in the DataBase that contain the Elictricity consumption for every year to the target year
DataBase.ElectricityConsumptionTable = array2table(zeros(7, Years),'RowNames',RowNames);
ColumnNames = cell(1,Years);
% Add the name for each year column
s1 = "KWH for "; 
for i=1:Years
    s2 = num2str(i+2018);
    ColumnNames{i} = strcat(s1, s2); 
end
DataBase.ElectricityConsumptionTable.Properties.VariableNames = cellstr(ColumnNames); % Convert the column names to string
% Read the 2019 Data from the Data File
DataBase.ElectricityConsumptionTable{1:6, 1} = table2array(readtable(Data,'Sheet','ElectricityConsumption','Range','B3:B8','ReadVariableNames',false));

% Define the Change of Electricity Industrial Consumption by 2050
IndustryElectricityConsumptionChange = readtable(Data,'Sheet','ElectricityConsumption','Range','R5:R5','ReadVariableNames',false);
DataBase.IndustryElectricityConsumptionChange = IndustryElectricityConsumptionChange{1,1}; % Save the single Datumn in the DataBase as single value

% Define the  Electricity loss Rate
ElectricityLossRatio = readtable(Data,'Sheet','ElectricityConsumption','Range','B17:B17','ReadVariableNames',false);
DataBase.ElectricityLossRatio = ElectricityLossRatio{1,1}; % Save the single Datumn in the DataBase as single value

%% Transportation Cosnumption
RowNames = {'Bus', 'Car', 'Minibus', 'Motorcycle', 'Truck', 'LCV', 'PassengerTrain','Freight Train', 'Total'};
% create a table in the DataBase that contain the Transportation KM for every year to the target year
DataBase.TransportationConsumptionTable = array2table(zeros(9, Years),'RowNames', RowNames);
% Add the name for each year column
ColumnNames = cell(1,Years);
s1 = "Annual Travel (KM) for ";
for i=1:Years
    s2 = num2str(i+2018);
    ColumnNames{i} = strcat(s1, s2);
end
DataBase.TransportationConsumptionTable.Properties.VariableNames = cellstr(ColumnNames);
DataBase.TransportationConsumptionTable{1:8, 1} = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','B3:B10','ReadVariableNames',false));
DataBase.TransportationConsumptionTable{9, 1} = sum(DataBase.TransportationConsumptionTable{1:8,1}); % Create a sum row for the table

%% Vehicle Amounts - Needs to Updates with Trains!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% This is a one-demantional array that contain columns for each year.
% Ideally each cell of it will contain a table with the year data of the number of vehicle. For now its just the first cell that contain the table (for 2019)
DataBase.VehicleAmountsCell = cell(1,Years);
RowNames = {'Quantity', 'Gasoline', 'Diesel', 'Drive Per Day', 'Drive Per Year', 'Cars Per Year'};
DataBase.VehicleAmountsCell{1} = array2table(zeros(6,6), 'RowNames', RowNames);
% Read the 2019 Data from the Data File
DataBase.VehicleAmountsCell{1}{:,:} = table2array(readtable(Data,'Sheet','TransportationConsumption','Range','B14:G19','ReadVariableNames',false));
ColNames = {'Bus','Car','Minibus','Motorcycle', 'Truck', 'LCV'};
DataBase.VehicleAmountsCell{1}.Properties.VariableNames = ColNames;

%% Food Cosnumption
% This is a one-demantional array that contain columns for each year.
% Ideally each cell of it will contain a table with the year data of the number of food. For now its just the first cell that contain the table (for 2019)
DataBase.FoodConsumptionCell = cell(1,Years);
% Define the row names to be the types of food
RowNames = table2cell(readtable(Data,'Sheet','Food','Range','A5:A68','ReadVariableNames',false))';
DataBase.FoodConsumptionCell{1} = array2table(zeros(64,4), 'RowNames', RowNames); % Create a table in the first cell for the 2019 data.
DataBase.FoodConsumptionCell{1}{:,:} = table2array(readtable(Data,'Sheet','Food','Range','B5:E68','ReadVariableNames',false));
ColNames = {'Humans and Other - Local','Animals - Local','Humans and Others - Import','Animals - Import'};
DataBase.FoodConsumptionCell{1}.Properties.VariableNames = ColNames;
% Insert the row names (types of food) to the DataBase (we could also just
% compare it to "RowNames" that we already defined...)
DataBase.FoodRowName = table2cell(readtable(Data,'Sheet','Food','Range','A5:A68','ReadVariableNames',false))';

% the maximal value possible in order to keep the area for food in Israel under 4500000 m^2.
TotalGrowthForLocalFood = readtable(Data,'Sheet','Food','Range','AJ3:AJ3','ReadVariableNames',false);
DataBase.TotalGrowthForLocalFood = TotalGrowthForLocalFood{1,1}; % Save it in the DataBase


%% water consumption
%% Need to Update- no need for water for Neighbors (or just put a zero there)!!!!!!!!!!!!!!!!!!!!!
DataBase.WaterConsumptionCell = cell(1,Years); 
RowNames = {'Agriculture', 'Marginal Water Percentage', 'Home Consumption(Urban)', 'Industry', 'Water for Nature', 'Water for Neighbors'};
% Update the first cell to be a table with 6 rows and 5 columns
DataBase.WaterConsumptionCell{1} = array2table(zeros(6,5), 'RowNames', RowNames);
% choosing brakish, treated water water and flood of 2019. and put it in the 3-5 columns of the table in the first cell
DataBase.WaterConsumptionCell{1}{:,3:5} = table2array(readtable(Data,'Sheet','Water','Range','F12:H17','ReadVariableNames',false));

% choosing drinking water for all purpuses. (Save it in another variable)
DataBase.DrinkingWater = table2array(readtable(Data,'Sheet','Water','Range','E12:E17','ReadVariableNames',false));

% precentage of desalinated water from all SHAFIRIM (all drinking water) 
DiselinatedWaterPercntage = readtable(Data,'Sheet','Water','Range','N44:N44','ReadVariableNames',false);
DataBase.DiselinatedWaterPercntage = DiselinatedWaterPercntage{1,1}; 
DiselinatedWaterPercntage = DiselinatedWaterPercntage{1,1};

% the total water from nature is all the drinkingWater X precentage of not desalinated
DataBase.WaterConsumptionCell{1}{:,1} = DataBase.DrinkingWater*(1-DiselinatedWaterPercntage);

% the total Diselinated water is all the drinkingWater X precentage of desalinated
DataBase.WaterConsumptionCell{1}{:,2} = DataBase.DrinkingWater*DiselinatedWaterPercntage;

% Basicaly this is the Drinking Water
DataBase.WaterConsumptionCell{1}{5,1} = DataBase.WaterConsumptionCell{1}{5,1}+DataBase.WaterConsumptionCell{1}{5,2};
% Water for nature doesn't get desalinated
DataBase.WaterConsumptionCell{1}{5,2} = 0;

% Give column names to the table we just built above
ColNames = {'Water From Nature', 'Diselinated Water','Brackish Water','Treated WasteWater','Flood Water'};
DataBase.WaterConsumptionCell{1}.Properties.VariableNames = ColNames;

% Read the values of Waste Treatment Emmission Coefficients
DataBase.SewegeTreatmentEmissionsCoefficitns = readtable(Data,'Sheet','Water','Range','B42:C42','ReadVariableNames',false);
DataBase.SewegeTreatmentEmissionsCoefficitns.Properties.VariableNames = {'Air Pollutants (KG\Ton)', 'GHG (KG\Ton)'};
% Read the values of Loss Ratio (Water that leaks/ evoparates from the pipes, and doesn't reach the consumer).
LossRatio = readtable(Data,'Sheet','Water','Range','J33:J33','ReadVariableNames',false);
DataBase.LossRatio = LossRatio{1,1};


%% Electricity Consumption For Water
% Read the electricity consumption as a result of water beeing desalinated,pump, moving, Seweage Treatment...
DataBase.ElectricityConsumptionForWaterCell = cell(1,1);
RowNames = {'Natural Water', 'Urban Consumption','Diselinated Water','Treated Waste Water', 'Sewege'};
DataBase.ElectricityConsumptionForWaterCell{1} = array2table(zeros(5,1), 'RowNames', RowNames);
DataBase.ElectricityConsumptionForWaterCell{1}{:,1} = table2array(readtable(Data,'Sheet','Water','Range','I33:I37','ReadVariableNames',false));
								

%% construction - Need to update by the contruction for new apartment!!!!!!!!!!!!!!!!!!!!!!!!!!!
RowNames = {'Agriculture', 'Other Public Buildings', 'Helathcare', 'Education', 'Industry and Storage', 'Transportation and Communications', 'Trade', 'Offices', 'Hosting', 'Residential', 'Total'};
% This is a one-demantional array that contain columns for each year.
DataBase.ConstructionTable = array2table(zeros(11,Years), 'RowNames', RowNames);
s1 = "Area for Construction ";
ColumnNames = cell(1,Years);
for i=1:Years
    s2 = num2str(i+2018);
    ColumnNames{i} = strcat(s1, s2);
end
DataBase.ConstructionTable.Properties.VariableNames = cellstr(ColumnNames); % Convert column names to string
% Put the values to the Base Year (first cell in the years-array)
DataBase.ConstructionTable{1:10, 1} = table2array(readtable(Data,'Sheet','Construction','Range','C3:C12','ReadVariableNames',false));
DataBase.ConstructionTable{11, 1} = sum(DataBase.ConstructionTable{1:10, 1});

% I changed it to be in the excel, so i wont be needed to chenge it for each city
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
TotalBuiltArea = readtable(Data,'Sheet','Construction','Range','R18:R18','ReadVariableNames',false);
DataBase.TotalBuiltArea = TotalBuiltArea{1,1};  % square kilometer
%DataBase.TotalBuiltArea = 2288;

%% Materials - generated waste and recycling - on hold, Need to Update!!!!!!!!!!!!!!!!!!!!!!!!!!!
WateAndRecyclingCell = cell(1,Years);
RowNames = {'Organic Products','Plastic', 'Paper', 'Cardboard', 'Diapers', 'Garden Waste', 'Textile', 'Metal', 'Glass', 'Pruned Trees','Wood', 'Oils', 'Others'};
WateAndRecyclingCell{1} =  array2table(zeros(13,8), 'RowNames', RowNames);
WateAndRecyclingCell{1}{:,:} = table2array(readtable(Data,'Sheet','Materials','Range','I4:P16','ReadVariableNames',false));
ColNames = {'Local Authorities - Waste', 'Local Authorities - Recycling', 'Industry - Waste', 'Industry - Recycling','Food Industry - Waste','Food Industry - Recycling' ,'Agriculture - Waste', 'Agriculture - Recycling'};
WateAndRecyclingCell{1}.Properties.VariableNames = ColNames;
DataBase.WateAndRecyclingCell = WateAndRecyclingCell;


%% Amounts of Fuels For Industry in tons of oil equivelent
% Need to Update the Data in the excel...!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
DataBase.AmountsOfFuelsCells = cell(1,Years); %% including mazut, kerosene and LPG for transportation
RowNames = {'Crude Oil Products - Not for Energy', 'Crude Oil For Export', 'Crude Oil Import','Crude Oil Products - For Energy', 'LPG - Home', 'LPG - Commertiel'  };
DataBase.AmountsOfFuelsCells{1} = array2table(zeros(6,7),'RowNames', RowNames);
DataBase.AmountsOfFuelsCells{1}{1,:} = table2array(readtable(Data,'Sheet','Materials','Range','P45:V45','ReadVariableNames',false));
DataBase.AmountsOfFuelsCells{1}{2,:} = table2array(readtable(Data,'Sheet','Materials','Range','P49:V49','ReadVariableNames',false));
DataBase.AmountsOfFuelsCells{1}{3,:} = table2array(readtable(Data,'Sheet','Materials','Range','P57:V57','ReadVariableNames',false));
DataBase.AmountsOfFuelsCells{1}{4,:} = table2array(readtable(Data,'Sheet','Materials','Range','P41:V41','ReadVariableNames',false));
DataBase.AmountsOfFuelsCells{1}{5,6} = table2array(readtable(Data,'Sheet','Materials','Range','R30:R30','ReadVariableNames',false));
DataBase.AmountsOfFuelsCells{1}{6,6} = table2array(readtable(Data,'Sheet','Materials','Range','R31:R31','ReadVariableNames',false));
ColNames = {'Naptha', 'Mazut','Diesel','Kerosene','Gasoline','Liquified Petroleum Gas', 'Other'};
DataBase.AmountsOfFuelsCells{1}.Properties.VariableNames = ColNames;

%% Water for food percentages (distribution of Nature Water, Diselinated Water, Brackish Water, Reclaimed Water, Flood Water)
DataBase.WaterForFoodPercentages = table2array(readtable(Data,'Sheet','Food','Range','T6:T10','ReadVariableNames',false))';

%% initial percentage (Electricity Fuels Consumption distribution in base year)
DataBase.InitialPercentage = table2array(readtable(Data,'Sheet','ElectricityConsumption','Range','B13:F13','ReadVariableNames',false));

%% Electricity Consumption Emissions In Transportation (taken from the ElectricityConsumption sheet)
% Electricity: Electricity Consumption for Electric Vehicle (kWh/KM)
DataBase.ElectricityConsumptionEmissionsInTransportation = table2array(readtable(Data,'Sheet','ElectricityConsumption','Range','I22:I25','ReadVariableNames',false)); %% all zeroes at the moment
% Electricity: Emissions Coefficeints from Battery Manufacturing (gCo2/km)
DataBase.EmissionsCoefficientsFromBatteryManufacturing = table2array(readtable(Data,'Sheet','ElectricityConsumption','Range','K22:K22','ReadVariableNames',false)); %% all zeroes at the moment

%% Calc Area For food consumption (Area from Food growth) both golbal and local
DataBase.AreaCoefficientsLocal = readtable(Data,'Sheet','Food','Range','W4:W67','ReadVariableNames',false);
DataBase.AreaCoefficientsLocal = table2array(DataBase.AreaCoefficientsLocal);
DataBase.AreaCoefficientsGlobal = readtable(Data,'Sheet','Food','Range','X4:X67','ReadVariableNames',false);
DataBase.AreaCoefficientsGlobal =table2array(DataBase.AreaCoefficientsGlobal);

%% Calc CO2E For food consumption (Emission Coefficients for KG/KG)
DataBase.FoodEmissionCoefficients = table2array(readtable(Data,'Sheet','Food','Range','L3:M66','ReadVariableNames',false));

%% Calc Construction Area Emission Coefficient, Material Waste Coefficients, Material consumption
% Waste Coefficients (KG/KG) - Materials that are leftover during the peocess of extracting minerals.
DataBase.CostructionEmissionCoefficients = table2array(readtable(Data,'Sheet','Construction','Range','A24:F24','ReadVariableNames',false));
% The required amount needed per Square Meter of contruction (KG/M^2)
DataBase.ConstructionMaterialCoefficients = table2array(readtable(Data,'Sheet','Construction','Range','A19:F19','ReadVariableNames',false));
%Material consumption table (How much Cement for construction)
% Probably will change, due to consideration of apartments construction!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
DataBase.MaterialConsumption = table2array(readtable(Data,'Sheet','Construction','Range','B41:G42','ReadVariableNames',false));
%Mortar Production Emissions Coefficients - CO2E (KG/KG)
MortarProductionCO2ECoefficient = readtable(Data,'Sheet','Construction','Range','L36:L36','ReadVariableNames',false);
DataBase.MortarProductionCO2ECoefficient = MortarProductionCO2ECoefficient{1,1};

%% Calc Consumption emissions 
% CH4 Emission Coefficients from Waste (Kg/Kg)
DataBase.ConsumptionEmissionCoefficients = table2array(readtable(Data,'Sheet','Materials','Range','X3:X15','ReadVariableNames',false));
% CH4 Emissions Coefficients from Crude Oil Refining (Kg/Ton)
DataBase.CrudeOilRefiningEmissionsCoefficients = readtable(Data,'Sheet','Materials','Range','B41:H46','ReadVariableNames',false);

%% Calc Electricity Consumption
% Emissions g/KWh of differnt types of fuels for electricity
DataBase.EmissionsFromElectricityConsumption = table2array(readtable(Data,'Sheet','ElectricityConsumption','Range','I12:P18','ReadVariableNames',true));
% Emissions from Natural Gas g/KWh from two power-plant
DataBase.ElctricityFromNatualGasCoeff = array2table(zeros(2,1));
RowNames = {'Converted', 'Combined Cycle'};
DataBase.ElctricityFromNatualGasCoeff.Properties.RowNames = RowNames;

ElctricityFromNatualGasCoeff1 = readtable(Data,'Sheet','ElectricityConsumption','Range','I29:I29','ReadVariableNames',false);
ElctricityFromNatualGasCoeff1 = ElctricityFromNatualGasCoeff1{1,1};  

ElctricityFromNatualGasCoeff2 = readtable(Data,'Sheet','ElectricityConsumption','Range','I30:I30','ReadVariableNames',false);
ElctricityFromNatualGasCoeff2 = ElctricityFromNatualGasCoeff2{1,1}; 

% Now save the two values in the ElctricityFromNatualGasCoeff table 
% I changes it instead of writing here the values!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
DataBase.ElctricityFromNatualGasCoeff{1,1}  = ElctricityFromNatualGasCoeff1;
DataBase.ElctricityFromNatualGasCoeff{2,1}  = ElctricityFromNatualGasCoeff2;

%% Calc Electricity for water
% Electricity For Water Coefficints (kwh/m^3)
DataBase.ElectricityConsumptionCoefficients = table2array(readtable(Data,'Sheet','Water','Range','B12:B17','ReadVariableNames',false));
% Distribution in uses of Urban SHAPIRIM 
DataBase.UrbanConsumptionPercentages = table2array(readtable(Data,'Sheet','Water','Range','M20:R20','ReadVariableNames',false));
% Distribution of Brackish Water to Gardening and Trade and Crafts
DataBase.RatioForBrackishWater = table2array(readtable(Data,'Sheet','Water','Range','P23:Q23','ReadVariableNames',false));

%% Calc Electricity manufacturing
DataBase.EmissionsCoefficientsForPv = readtable(Data,'Sheet','PVEmissions','Range','I8:J40','ReadVariableNames',true);
% Coefficients from mining and fuel manufacturing 
DataBase.EmissionsCoefficientsUpstreamElectricity = table2array(readtable(Data,'Sheet','ElectricityManufactureEmissions','Range','B37:G43','ReadVariableNames',false))';
% How many tons of fuel is needed for 1 kwh of electricity
DataBase.ElectrictyManufacturingCoefficients = table2array(readtable(Data,'Sheet','ElectricityManufactureEmissions','Range','B33:E33','ReadVariableNames',false));
% The Ratio between crude oil to Manufactured Fuel
CrudeOilToFuelRatio = readtable(Data,'Sheet','ElectricityManufactureEmissions','Range','R28:R28','ReadVariableNames',false);
DataBase.CrudeOilToFuelRatio = CrudeOilToFuelRatio{1,1};

%% Calc transportation consumption
% All the Emissions Coefficients for different kindes of emission
DataBase.TransportationHotEmissionsCoefficients = table2array(readtable(Data,'Sheet','TransportationConsumption','Range','K25:Q38','ReadVariableNames',false));
DataBase.TransportationColdEmissionsCoefficients = table2array(readtable(Data,'Sheet','TransportationConsumption','Range','T25:Z38','ReadVariableNames',false));
DataBase.TransportationEvaporationEmissionsWhileDriving = table2array(readtable(Data,'Sheet','TransportationConsumption','Range','AC25:AI38','ReadVariableNames',false));
DataBase.TransportationEvaporationEmissionsAfterDriving = table2array(readtable(Data,'Sheet','TransportationConsumption','Range','AL25:AR38','ReadVariableNames',false));
DataBase.TransportationEvaporationEmissionsEveryDay = table2array(readtable(Data,'Sheet','TransportationConsumption','Range','AU25:BA38','ReadVariableNames',false));
DataBase.TransportationGridingEmissions = table2array(readtable(Data,'Sheet','TransportationConsumption','Range','BD25:BJ38','ReadVariableNames',false));
% Train Emissions Coefficients (g/KM)
DataBase.PassengerTrainEmissionCoefficients = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','L55:L66','ReadVariableNames',false));
DataBase.PassengerTrainEmissionCoefficients(11, :) = []; % Deletes the 11th line (Total Pollutants)
DataBase.FreightTrainEmissionCoefficients = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','N55:N66','ReadVariableNames',false));
DataBase.FreightTrainEmissionCoefficients(11,:) = []; % Deletes the 11th line (Total Pollutants)

%% Calc transportation manufacturing
% Fuel Consumption coefficients (g/Km) for every kind of emission in transportation
RowNames = {'Hot Emissions', 'Cold Emissions', 'Evaporation Emissions', 'Evaporation Emissions - After Driving', 'Evaporation Emissions - Every Day', 'Grinding Emissiobs'};
DataBase.FuelConsumptionCoefficients = array2table(zeros(6, 7), 'RowNames', RowNames);
DataBase.FuelConsumptionCoefficients.Properties.VariableNames = {'Bus', 'Car', 'Minibus', 'Motorcycle', 'Truck', 'LCV', 'Train'};

DataBase.FuelConsumptionCoefficients{1,1:6} = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','U17:Z17','ReadVariableNames',false));
DataBase.FuelConsumptionCoefficients{2,1:6} = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','AD17:AI17','ReadVariableNames',false));
% I fixed it from AM18:AR18 to AM17:AR17 because it wasn't right- notify
% raziel!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
DataBase.FuelConsumptionCoefficients{3,1:6} = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','AM17:AR17','ReadVariableNames',false));
DataBase.FuelConsumptionCoefficients{4,1:6} = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','AV17:BA17','ReadVariableNames',false));
DataBase.FuelConsumptionCoefficients{5,1:6} = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','BE17:BJ17','ReadVariableNames',false));
DataBase.FuelConsumptionCoefficients{6,1:6} = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','BN17:BS17','ReadVariableNames',false));
% Train Fuel Consumption Coefficients (Diesel/KM) 
DataBase.TrainFuelConsumptionCoefficints = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','K73:K74','ReadVariableNames',false))';

% Soler/amount ratio - CBS Coeeficients 2011
InflationCoefficient = readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','P53:P53','ReadVariableNames',false);
DataBase.InflationCoefficient = InflationCoefficient{1,1};

% I think that we already defined it. check!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
CrudeOilToFuelRatio = readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','AC51:AC51','ReadVariableNames',false);
DataBase.CrudeOilToFuelRatio = CrudeOilToFuelRatio{1,1};
% Fuel Amounts For Transportation - Natural Gas to Fuel Refining for transportation (Ton)
NaturalGasForFuelRefining = readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','I35:I35','ReadVariableNames',false);
DataBase.NaturalGasForFuelRefining = NaturalGasForFuelRefining{1,1};

% Coefficients from mining and fuel manufacturing for Mazut only
DataBase.EmissionsCoefficientsUpstream = table2array(readtable(Data,'Sheet','FuelProductionEmissionsForTrans','Range','B50:H56','ReadVariableNames',false))'; %% array(6,7)

%% Calc Waste and recycling  
% Distributionof different materials for Export Waste For Recycling 
DataBase.ExportWasteForRecyclingPercentage = table2array(readtable(Data,'Sheet','Materials','Range','I20:I32','ReadVariableNames',false));
    
%% Calc Water for Food Consumption 
%Coefficients Water Consumption for Growing the Product m^3/ton
DataBase.WaterConsumptionCoefficientsLocal = table2array(readtable(Data,'Sheet','Food','Range','H4:H68','ReadVariableNames',false));
DataBase.WaterConsumptionCoefficientsGlobal = table2array(readtable(Data,'Sheet','Food','Range','I4:I68','ReadVariableNames',false));    

%% Waste incinaration values - Update in the excels...!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
DataBase.WasteToElectricity = 0.807;
DataBase.IncinarationEmissionCoefficient = 1.01;

%% Transition to buses and trains - Update in the excels...!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
DataBase.TransitionToBus = 0.5 
DataBase.TransitionToTrain = 1- DataBase.TransitionToBus;

%% Organic Waste Amounts - for food
% CH4 Organic Waste Emission Coefficient (kg/kg)
DataBase.OrganicWasteCoefficients = table2array(readtable(Data,'Sheet','Food','Range','H80:H80','ReadVariableNames',false));

% Organic Waste Emissions (Ton)
DataBase.OrganicWasteAmountsCell = cell(1,Years);
RowNames = {'Local Authorities', 'Food Industry', 'Agriculture'};
DataBase.OrganicWasteAmountsCell{1} = readtable(Data,'Sheet','Food','Range','H73:I76','ReadVariableNames',true);
DataBase.OrganicWasteAmountsCell{1}.Properties.RowNames = RowNames;

%% Resources - Area
DataBase.AreaForSolarEnergyCoefficients = readtable(Data,'Sheet','Area','Range','A1:E35','ReadVariableNames',true, 'ReadRowNames',true);
% We usw only PV energy in the project - maybe put this variable in a excel...!!!!!!!!!!!!!!!!!!!!!
DataBase.RenewablePercents = [1 0 0 0];
DataBase.RenewablePercents = array2table(DataBase.RenewablePercents);
DataBase.RenewablePercents.Properties.VariableNames = {'PV','Wind', 'Biomass', 'Thermo Solar'};
% I dont kmow, we need to understant it!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
DataBase.LowerBoundForArea = 6; %% according to shockley-queisser limit
DataBase.KWToKwh = readtable(Data,'Sheet','Area','Range','N39:O44','ReadRowNames',true);
DataBase.PVType = 'Dual';

%area distribution
DataBase.AreaDistribution = readtable(Data,'Sheet','Area','Range','H1:K6','ReadVariableNames',true, 'ReadRowNames',true);
% Do we need to calculate money?!!!!!!!!!!!!!!!!!!!!!!!
DataBase.AreaCostForElectricity = readtable(Data,'Sheet','Money','Range','N37:Q71','ReadVariableNames',true, 'ReadRowNames',true);

%area for food coefficient (m^2/kg)
DataBase.AreaForFoodCoefficients = readtable(Data,'Sheet','Food','Range','W3:X67','ReadVariableNames',true);

%% Money
% Setting costs (ILS\KW)
DataBase.SettingCosts = readtable(Data,'Sheet','Money','Range','A2:I36','ReadVariableNames',true, 'ReadRowNames',true);
% Operating Costs (ILS\KW)
DataBase.OperatingCosts = readtable(Data,'Sheet','Money','Range','A41:I75','ReadVariableNames',true, 'ReadRowNames',true);
% ILS/Ton Fuel Manufacturing and Fuel Transportation
DataBase.ILSPerTon = readtable(Data,'Sheet','Money','Range','L19:O23','ReadVariableNames',false, 'ReadRowNames',true);

%% read the trends in consumption for the target year (empty)- Needs to change!!!!!!!!!!!!!!!!!!
DataBase.ChnageStruct = struct;
DataBase.ChnageStruct.Electricity = readtable("The Three Scenarios.xlsx",'Sheet','ChangesInConsumptionType','Range','A2:B5','ReadRowNames',true);
DataBase.ChnageStruct.Water = readtable("The Three Scenarios.xlsx",'Sheet','ChangesInConsumptionType','Range','A8:B12','ReadRowNames',true);
DataBase.ChnageStruct.Transportation = readtable("The Three Scenarios.xlsx",'Sheet','ChangesInConsumptionType','Range','A15:B21','ReadRowNames',true);
DataBase.ChnageStruct.Food = readtable("The Three Scenarios.xlsx",'Sheet','ChangesInConsumptionType','Range','D2:E65','ReadRowNames',true);
