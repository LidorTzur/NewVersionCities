function [population] = populationCal(PrecentegeByTheYears)

global TargetYear_global;
global BaseYear;
Years = TargetYear_global-BaseYear+1; %השנים שבין שנת הבסיס לשנת המטרה
global PopulationStartYear_global;

%% population data
% Calculate the pupolations over the years
population  = array2table(zeros(4,(Years)));
RowNames = {'Num','Years', 'Israel population', 'Palestinian Authority population'};
population.Properties.RowNames = RowNames;

% Filling the Data to every year (By option A in the excel sheet)
for i =1:Years
    population(1,i) = {i};
    population(2,i) = {i+BaseYear-1};
    population(3,i) = {PopulationStartYear_global*PrecentegeByTheYears{1,i}};
    population(4,i) = {0*0^(i-1)}; % No palestinian in beer sheva.
end


% for i =1:width(PrecentegeByTheYears)
%     population(1,i) = {i};
%     population(2,i) = {i+BaseYear-1};
%     population(3,i) = {8.8*PrecentegeByTheYears{1,i}};
%     if PrecentegeByTheYears{1,i} == 1
%         population(4,i) = {4.455};
%     else
%         population(4,i) = {4.455*1.0223^(i-1)};
%     end
% 
% end
