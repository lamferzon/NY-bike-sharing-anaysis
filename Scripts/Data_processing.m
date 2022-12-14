
% *Part 1: data processing*

%  Preliminary data processing regarding bike sharing and weather parameters 
%  in New York City during 2020, starting from January 1th to December 31th.

clc
clearvars
warning off

%% Bike sharing data (expected execution time: ~ 45/50 minutes) 

%  Information extraction
tic;
disp("Start processing of bike sharing data")
disp(" ")

bike_path = "..\Data\Sources\Bike sharing\";
months = ["January" "February" "March" "April" "May" "June" "July" "August"...
    "September" "October" "November" "December"];

DS = readtable(bike_path + months(1, 1) + "2020.csv");
id_stations = sort(unique(DS.startStationId));
daily_calendar = datetime(2020, 1, (1:366));
hourly_calendar = repmat(datetime('now'), 24, 366);
for i=1:366
    hourly_calendar(:, i) = datetime(2020, 1, i, (0:23), 0, 0);
end
hourly_calendar = hourly_calendar(:)';
 
daily_counters_table = array2table(NaN(length(id_stations), length(daily_calendar)+1));
daily_counters_table.Properties.VariableNames = ["idStation" string(daily_calendar)];
daily_counters_table.idStation = id_stations;
hourly_counters_table = array2table(NaN(length(id_stations), length(hourly_calendar)+1));
hourly_counters_table.Properties.VariableNames = ["idStation" string(hourly_calendar)];
hourly_counters_table.idStation = id_stations;

daily_age_table = array2table(NaN(length(id_stations), length(daily_calendar)+1));
daily_age_table.Properties.VariableNames = ["idStation" string(daily_calendar)];
daily_age_table.idStation = id_stations;
hourly_age_table = array2table(NaN(length(id_stations), length(hourly_calendar)+1));
hourly_age_table.Properties.VariableNames = ["idStation" string(hourly_calendar)];
hourly_age_table.idStation = id_stations;

daily_duration_table = array2table(NaN(length(id_stations), length(daily_calendar)+1));
daily_duration_table.Properties.VariableNames = ["idStation" string(daily_calendar)];
daily_duration_table.idStation = id_stations;
hourly_duration_table = array2table(NaN(length(id_stations), length(hourly_calendar)+1));
hourly_duration_table.Properties.VariableNames = ["idStation" string(hourly_calendar)];
hourly_duration_table.idStation = id_stations;

daily_male_table = array2table(NaN(length(id_stations), length(daily_calendar)+1));
daily_male_table.Properties.VariableNames = ["idStation" string(daily_calendar)];
daily_male_table.idStation = id_stations;
hourly_male_table = array2table(NaN(length(id_stations), length(hourly_calendar)+1));
hourly_male_table.Properties.VariableNames = ["idStation" string(hourly_calendar)];
hourly_male_table.idStation = id_stations;

daily_female_table = array2table(NaN(length(id_stations), length(daily_calendar)+1));
daily_female_table.Properties.VariableNames = ["idStation" string(daily_calendar)];
daily_female_table.idStation = id_stations;
hourly_female_table = array2table(NaN(length(id_stations), length(hourly_calendar)+1));
hourly_female_table.Properties.VariableNames = ["idStation" string(hourly_calendar)];
hourly_female_table.idStation = id_stations;

daily_unknown_table = array2table(NaN(length(id_stations), length(daily_calendar)+1));
daily_unknown_table.Properties.VariableNames = ["idStation" string(daily_calendar)];
daily_unknown_table.idStation = id_stations;
hourly_unknown_table = array2table(NaN(length(id_stations), length(hourly_calendar)+1));
hourly_unknown_table.Properties.VariableNames = ["idStation" string(hourly_calendar)];
hourly_unknown_table.idStation = id_stations;

daily_subscriber_table = array2table(NaN(length(id_stations), length(daily_calendar)+1));
daily_subscriber_table.Properties.VariableNames = ["idStation" string(daily_calendar)];
daily_subscriber_table.idStation = id_stations;
hourly_subscriber_table = array2table(NaN(length(id_stations), length(hourly_calendar)+1));
hourly_subscriber_table.Properties.VariableNames = ["idStation" string(hourly_calendar)];
hourly_subscriber_table.idStation = id_stations;

daily_customer_table = array2table(NaN(length(id_stations), length(daily_calendar)+1));
daily_customer_table.Properties.VariableNames = ["idStation" string(daily_calendar)];
daily_customer_table.idStation = id_stations;
hourly_customer_table = array2table(NaN(length(id_stations), length(hourly_calendar)+1));
hourly_customer_table.Properties.VariableNames = ["idStation" string(hourly_calendar)];
hourly_customer_table.idStation = id_stations;

% hourly data extraction

disp("Start hourly data extraction")
disp(" ")
day_counter = 1;
hour_counter = 1;
for i=1:length(months)
    disp(months(1, i) + " start")
    Bike_data = readtable(bike_path + months(1, i) + "2020.csv");
    for k=1:sum(month(daily_calendar, 'name') == months(1, i))
        disp(" Day: " + k + "/" + i)
        for h=0:23
            disp("  Hour: " + h)
            for j=1:length(id_stations)
                selector = Bike_data.startStationId == id_stations(j, 1)...
                & Bike_data.starttime.Day == k & Bike_data.starttime.Hour == h;
                temp = Bike_data(selector, :);
                % counting of the hourly number of picks-up per station
                count = size(temp, 1);
                hourly_counters_table(hourly_counters_table.idStation==id_stations(j, 1),...
                    hour_counter + 1) = {count};
                 % calculation of the hourly average users' age per station
                avg_age = mean(2020*ones(size(temp, 1), 1) - temp{:, "birthYear"});
                hourly_age_table(hourly_counters_table.idStation==id_stations(j, 1),...
                    hour_counter + 1) = {avg_age};
                % calculation of the hourly average trip duration per station
                avg_duration = mean(temp{:, "tripduration"});
                hourly_duration_table(hourly_counters_table.idStation==id_stations(j, 1),...
                    hour_counter + 1) = {avg_duration};
                % counting of the male/female/unknown hourly users per station
                male_count = size(temp(temp.gender==1, :), 1);
                hourly_male_table(hourly_counters_table.idStation==id_stations(j, 1),...
                    hour_counter + 1) = {male_count};
                female_count = size(temp(temp.gender==2, :), 1);
                hourly_female_table(hourly_counters_table.idStation==id_stations(j, 1),...
                    hour_counter + 1) = {female_count};
                unknown_count = size(temp(temp.gender==0, :), 1);
                hourly_unknown_table(hourly_counters_table.idStation==id_stations(j, 1),...
                    hour_counter + 1) = {unknown_count};
                % counting of the subscriber/customer hourly users per station
                subscriber_count = size(temp(temp.usertype=="Subscriber", :), 1);
                hourly_subscriber_table(hourly_counters_table.idStation==id_stations(j, 1),...
                    hour_counter + 1) = {subscriber_count};
                customer_count = size(temp(temp.usertype=="Customer", :), 1);
                hourly_customer_table(hourly_counters_table.idStation==id_stations(j, 1),...
                    hour_counter + 1) = {customer_count};
            end
            hour_counter = hour_counter + 1;
        end
        day_counter = day_counter + 1;
    end
    disp(months(1, i) + " done.")
    disp(" ")
end

% daily data extraction

disp("Start daily data extraction")
disp(" ")
day_counter = 1;
for i=1:length(months)
    disp(months(1, i) + " start")
    Bike_data = readtable(bike_path + months(1, i) + "2020.csv");
    for k=1:sum(month(daily_calendar, 'name') == months(1, i))
        disp(" Day: " + k + "/" + i)
        for j=1:length(id_stations)
            selector = Bike_data.startStationId == id_stations(j, 1)...
                & Bike_data.starttime.Day == k;
            temp = Bike_data(selector, :);
            % counting of the daily number of picks-up per station
            count = size(temp, 1);
            daily_counters_table(daily_counters_table.idStation==id_stations(j, 1),...
                day_counter + 1) = {count};
            % calculation of the daily average users' age per station
            avg_age = mean(2020*ones(size(temp, 1), 1) - temp{:, "birthYear"});
            daily_age_table(daily_counters_table.idStation==id_stations(j, 1),...
                day_counter + 1) = {avg_age};
            % calculation of the daily average trip duration per station
            avg_duration = mean(temp{:, "tripduration"});
            daily_duration_table(daily_counters_table.idStation==id_stations(j, 1),...
                day_counter + 1) = {avg_duration};
            % counting of the male/female/unknown daily users per station
            male_count = size(temp(temp.gender==1, :), 1);
            daily_male_table(daily_counters_table.idStation==id_stations(j, 1),...
                day_counter + 1) = {male_count};
            female_count = size(temp(temp.gender==2, :), 1);
            daily_female_table(daily_counters_table.idStation==id_stations(j, 1),...
                day_counter + 1) = {female_count};
            unknown_count = size(temp(temp.gender==0, :), 1);
            daily_unknown_table(daily_counters_table.idStation==id_stations(j, 1),...
                day_counter + 1) = {unknown_count};
            % counting of the subscriber/customer daily users per station
            subscriber_count = size(temp(temp.usertype=="Subscriber", :), 1);
            daily_subscriber_table(daily_counters_table.idStation==id_stations(j, 1),...
                day_counter + 1) = {subscriber_count};
            customer_count = size(temp(temp.usertype=="Customer", :), 1);
            daily_customer_table(daily_counters_table.idStation==id_stations(j, 1),...
                day_counter + 1) = {customer_count};
        end
        day_counter = day_counter + 1;
    end
    disp(months(1, i) + " done.")
    disp(" ")
end

num_stations = length(id_stations);
lat_stations = zeros(num_stations, 1);
lon_stations = zeros(num_stations, 1);
for i=1:num_stations
    temp = Bike_data(Bike_data.startStationId==id_stations(i, 1), :);
    lat_stations(i, 1) = temp{1, "startStationLatitude"};
    lon_stations(i, 1) = temp{1, "startStationLongitude"};
end

% In 2020, the US federal holidays fell on the following dates:
% - Wednesday, January 1 ??? New Year:s Day
% - Monday, January 20 ??? Birthday of Martin Luther King, Jr.
% - Monday, February 17 ??? Washington-s Birthday
% - Monday, May 25 ??? Memorial Day
% - Friday, July 3 ??? Independence Day
% - Monday, September 7 ??? Labor Day
% - Monday, October 12 ??? Columbus Day
% - Wednesday, November 11 ??? Veterans Day
% - Thursday, November 26 ??? Thanksgiving Day
% - Friday, December 25 ??? Christmas Day

daily_calendar = convertTo(daily_calendar, "datenum");
% hourly_calendar = convertTo(hourly_calendar, "datenum");

sundays = convertTo(datetime(2020, 1, 5), "datenum"):7:convertTo(datetime(2020, 12, 27), "datenum");
holidays = convertTo([datetime(2020, 1, 1) datetime(2020, 1, 20) ...
    datetime(2020, 2, 17) datetime(2020, 5, 25) datetime(2020, 7, 3) ...
    datetime(2020, 9, 7) datetime(2020, 10, 12) datetime(2020, 11, 11) ...
    datetime(2020, 11, 26) datetime(2020, 12, 25)], "datenum");
non_working_days = ismember(daily_calendar, [sundays holidays]);

% Lockdown dates due to COVID-19 pandemic in New York City:
% - March 22, 2020: NYS on Pause Program begins, all non-essential workers
%   must stay home;
% - May 15, 2020: Governor Cuomo allows drive-in theaters, landscaping, and
%   low-risk recreational activities to reopen.

lockdown = convertTo(datetime(2020, 3, 22),...
    "datenum"):1:convertTo(datetime(2020, 5, 15), "datenum");
lockdown_days = ismember(daily_calendar, lockdown);

disp("Processing of bike sharing data done.")
toc;

%% Weather data

%  Information extraction

tic;
disp(" ")
disp("Start processing of weather data")
disp(" ")

daily_weather_path = "..\Data\Sources\Weather\NYC_daily_weather_data.csv";
hourly_weather_path = "..\Data\Sources\Weather\NYC_hourly_weather_data.csv";
Daily_weather_DS = readtable(daily_weather_path);
Hourly_weather_DS = readtable(hourly_weather_path);
Hourly_weather_DS = Hourly_weather_DS(1:(24*366), :);

daily_calendar = convertTo(datetime(2020, 1, (1:366)), "datenum");
hourly_calendar = repmat(datetime('now'), 24, 366);
for i=1:366
    hourly_calendar(:, i) = datetime(2020, 1, i, (0:23), 0, 0);
end
hourly_calendar = convertTo(hourly_calendar(:)', "datenum");

disp("Processing of weather data done.")
toc;

%% Train stations data

tic;
disp(" ")
disp("Start processing of train stations data")
disp(" ")

train_stations_path = "..\Data\Sources\Train stations\Jersey_City_train_stations_data.csv";
train_stations_table = readtable(train_stations_path);
lat_b = lat_stations;
lon_b = lon_stations;
lat_t = train_stations_table.Lat;
lon_t = train_stations_table.Lon;
dist = ones(length(lat_b), 1);
dist_i = ones(length(lat_t), 1);

for i = 1:length(lat_b) 
    for j = 1:length(lat_t)
        dist_i(j) = distance('gc', lat_b(i), lon_b(i), lat_t(j), lon_t(j)); 
        dist_i(j) = deg2km(dist_i(j));
    end
    dist(i)=min(dist_i);
end

disp("Processing of weather data done.")
toc;

%% Daily data formatting for DCM and HDGM

tic;
disp(" ")
disp("Start formatting of daily data")
disp(" ")

daily_data.bs_data{1} = daily_counters_table{:,2:end};
daily_data.bs_data{2} = daily_duration_table{:,2:end};
daily_data.bs_data{3} = daily_age_table{:,2:end};
daily_data.bs_data{4} = daily_male_table{:,2:end};
daily_data.bs_data{5} = daily_female_table{:,2:end};
daily_data.bs_data{6} = daily_unknown_table{:,2:end};
daily_data.bs_data{7} = daily_subscriber_table{:,2:end};
daily_data.bs_data{8} = daily_customer_table{:,2:end};
daily_data.bs_var_names{1} = 'pickups counters';
daily_data.bs_var_names{2} = 'avg trip duration';
daily_data.bs_var_names{3} = 'avg clients age';
daily_data.bs_var_names{4} = 'male counters';
daily_data.bs_var_names{5} = 'female counters';
daily_data.bs_var_names{6} = 'unknown gender counters';
daily_data.bs_var_names{7} = 'subscribers counters';
daily_data.bs_var_names{8} = 'customers counters';
daily_data.bs_units_of_measure{1} = 'dimensionless';
daily_data.bs_units_of_measure{2} = 's';
daily_data.bs_units_of_measure{3} = 'years';
daily_data.bs_units_of_measure{4} = 'dimensionless';
daily_data.bs_units_of_measure{5} = 'dimensionless';
daily_data.bs_units_of_measure{6} = 'dimensionless';
daily_data.bs_units_of_measure{7} = 'dimensionless';
daily_data.bs_units_of_measure{8} = 'dimensionless';
daily_data.weather_data{1} = repmat(Daily_weather_DS{:, "temp"}', num_stations, 1);
daily_data.weather_data{2} = repmat(Daily_weather_DS{:, "feelslike"}', num_stations, 1);
daily_data.weather_data{3} = repmat(Daily_weather_DS{:, "humidity"}', num_stations, 1);
daily_data.weather_data{4} = repmat(Daily_weather_DS{:, "precip"}', num_stations, 1);
daily_data.weather_data{5} = repmat(Daily_weather_DS{:, "snow"}', num_stations, 1);
daily_data.weather_data{6} = repmat(Daily_weather_DS{:, "windspeed"}', num_stations, 1);
daily_data.weather_data{7} = repmat(Daily_weather_DS{:, "cloudcover"}', num_stations, 1);
daily_data.weather_data{8} = repmat(Daily_weather_DS{:, "visibility"}', num_stations, 1);
daily_data.weather_data{9} = repmat(Daily_weather_DS{:, "uvindex"}', num_stations, 1);
daily_data.weather_var_names{1} = 'avg temperature';
daily_data.weather_var_names{2} = 'avg feels like temperature';
daily_data.weather_var_names{3} = 'humidity';
daily_data.weather_var_names{4} = 'rainfall';
daily_data.weather_var_names{5} = 'snowfall';
daily_data.weather_var_names{6} = 'windspeed';
daily_data.weather_var_names{7} = 'cloud cover';
daily_data.weather_var_names{8} = 'visibility';
daily_data.weather_var_names{9} = 'UV index';
daily_data.weather_units_of_measure{1} = '??C';
daily_data.weather_units_of_measure{2} = '??C';
daily_data.weather_units_of_measure{3} = '%';
daily_data.weather_units_of_measure{4} = 'mm';
daily_data.weather_units_of_measure{5} = 'cm';
daily_data.weather_units_of_measure{6} = 'km/h';
daily_data.weather_units_of_measure{7} = '%';
daily_data.weather_units_of_measure{8} = 'km';
daily_data.weather_units_of_measure{9} = 'dimensionless';
daily_data.distances{1} = repmat(dist, 1, 366);
daily_data.distances_var_names{1} = 'distances from the nearest train station';
daily_data.distances_units_of_measure{1} = 'degrees';
daily_data.datetime_calendar = datetime(daily_calendar, 'ConvertFrom', 'datenum');
daily_data.num_calendar = daily_calendar;
daily_data.non_working_days = non_working_days;
daily_data.lockdown_days = lockdown_days;
daily_data.temporal_granularity = 'day';
daily_data.measure_type = 'observed';
daily_data.data_type = 'point';
daily_data.data_sources{1} = 'https://www.kaggle.com/datasets/vineethakkinapalli/citibike-bike-sharingnewyork-cityjan-to-apr-2021';
daily_data.data_sources{2} = 'https://www.visualcrossing.com/weather/weather-data-services/New%20York/us/last15days#';
daily_data.num_stations = num_stations;
daily_data.location  = 'New York City, Jersey City';
daily_data.id = id_stations;
daily_data.lat = lat_stations;
daily_data.lon = lon_stations;
daily_data.coordinate_unit = 'degree';
daily_data.processing_authors{1} = 'Alessandro Chaar';
daily_data.processing_authors{2} = 'Lorenzo Leoni';
daily_data.processing_authors{3} = 'Nicola Zambelli';
daily_data.processing_date = datetime('now');
daily_data.processing_machine = 'PCWIN64';

% save("..\Data\Processed data\Daily_data.mat", "daily_data")

disp("Formatting of daily data done.")
toc;

%% Hourly data formatting for f-HDGM

tic;
disp(" ")
disp("Start formatting of hourly data")
disp(" ")

happy = convertTo(datetime(2020, 5, 15),...
    "datenum"):1:convertTo(datetime(2020, 9, 20), "datenum");
happy = ismember(daily_calendar, happy);

var_names = {'Profile', 'Y_name', 'Y', 'X_h_hour', 'X_beta_const',...
    'X_beta_avg_feels_like_T', 'X_beta_rainfall', 'X_beta_visibility',...
    'X_beta_windspeed', 'X_beta_cloud_cover', 'X_beta_ts_distance',...
    'X_beta_holidays', 'X_beta_lockdown', 'X_beta_happy', 'Y_coordinate',...
    'X_coordinate', 'Time'};
var_units = {'', '', 'bikes', 'h', 'cons', '???^{\circ}C', 'mm', 'km', 'km/h',...
    '\%', 'deg', '', '', '', 'deg', 'deg', 'd'};
hourly_data = array2table(zeros(366*num_stations, length(var_names)));
hourly_data.Properties.VariableNames = var_names;
hourly_data.Properties.VariableUnits = var_units;
% hourly_data.Profile = 1:(366*num_stations);
hourly_data.Y_name = repmat({'pickups'}, 366*num_stations, 1);
hourly_data.Y_coordinate = repmat(lat_stations, 366, 1);
hourly_data.X_coordinate = repmat(lon_stations, 366, 1);

hourly_data.Y = num2cell(hourly_data.Y);
hourly_data.X_h_hour = num2cell(hourly_data.Y);
hourly_data.X_beta_const = num2cell(hourly_data.X_beta_const);
hourly_data.X_beta_avg_feels_like_T = num2cell(hourly_data.X_beta_avg_feels_like_T);
hourly_data.X_beta_rainfall = num2cell(hourly_data.X_beta_rainfall);
hourly_data.X_beta_visibility = num2cell(hourly_data.X_beta_visibility);
hourly_data.X_beta_windspeed = num2cell(hourly_data.X_beta_windspeed);
hourly_data.X_beta_cloud_cover = num2cell(hourly_data.X_beta_cloud_cover);
hourly_data.X_beta_ts_distance = num2cell(hourly_data.X_beta_ts_distance);
hourly_data.X_beta_holidays = num2cell(hourly_data.X_beta_holidays);
hourly_data.X_beta_lockdown = num2cell(hourly_data.X_beta_lockdown);
hourly_data.X_beta_happy = num2cell(hourly_data.X_beta_happy);
hourly_data.Time = datetime(hourly_data.Time, 'ConvertFrom', 'datenum');

count = 1;
start = 2;
for i = 1:366
    disp("Day: " + i)
    stop = start + 23;
    for j = 1:num_stations
        hourly_data.Profile(count) = count;
        hourly_data.Y(count) = {hourly_counters_table{j,start:stop}};
        hourly_data.X_h_hour(count) = {0:1:23};
        hourly_data.X_beta_const(count) = {ones(1, 24)};
        hourly_data.X_beta_avg_feels_like_T(count) = {Hourly_weather_DS{(start-1):(stop-1), "feelslike"}'};
        hourly_data.X_beta_rainfall(count) = {Hourly_weather_DS{(start-1):(stop-1), "precip"}'};
        hourly_data.X_beta_visibility(count) = {Hourly_weather_DS{(start-1):(stop-1), "visibility"}'};
        hourly_data.X_beta_windspeed(count) = {Hourly_weather_DS{(start-1):(stop-1), "windspeed"}'};
        hourly_data.X_beta_cloud_cover(count) = {Hourly_weather_DS{(start-1):(stop-1), "cloudcover"}'};
        hourly_data.X_beta_ts_distance(count) = {repmat(dist(j, 1), 1, 24)};
        if lockdown_days(1, i)
            hourly_data.X_beta_lockdown(count) = {ones(1, 24)};
        else
            hourly_data.X_beta_lockdown(count) = {zeros(1, 24)};
        end
        if non_working_days(1, i)
            hourly_data.X_beta_holidays(count) = {ones(1, 24)};
        else
            hourly_data.X_beta_holidays(count) = {zeros(1, 24)};
        end
        if happy(1, i)
            hourly_data.X_beta_happy(count) = {ones(1, 24)};
        else
            hourly_data.X_beta_happy(count) = {zeros(1, 24)};
        end
        hourly_data.Time(count) = datetime(2020, 1, i);
        count = count + 1;
    end
    start = stop + 1;
end

% save("..\Data\Processed data\Hourly_data.mat", "hourly_data")

disp("Formatting of daily data done.")
toc;
