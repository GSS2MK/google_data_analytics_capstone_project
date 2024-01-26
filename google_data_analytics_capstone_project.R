#==================# 
# install packages #
#==================#

install.packages("tidyverse")
library(tidyverse)
library(hms)
options(scipen = 999)
library(scales)

#==================#
# import data sets #
#==================#

df_202301 <- read_csv("original_data/202301-divvy-tripdata.csv") 
df_202302 <- read_csv("original_data/202302-divvy-tripdata.csv")
df_202303 <- read_csv("original_data/202303-divvy-tripdata.csv")
df_202304 <- read_csv("original_data/202304-divvy-tripdata.csv")
df_202305 <- read_csv("original_data/202305-divvy-tripdata.csv")
df_202306 <- read_csv("original_data/202306-divvy-tripdata.csv")
df_202307 <- read_csv("original_data/202307-divvy-tripdata.csv")
df_202308 <- read_csv("original_data/202308-divvy-tripdata.csv")
df_202309 <- read_csv("original_data/202309-divvy-tripdata.csv")
df_202310 <- read_csv("original_data/202310-divvy-tripdata.csv")
df_202311 <- read_csv("original_data/202311-divvy-tripdata.csv")
df_202312 <- read_csv("original_data/202312-divvy-tripdata.csv")

#=================#
# column(s) check #
#=================#

# check if all column names are uniform and coherent

colnames(df_202301)
colnames(df_202302)
colnames(df_202303)
colnames(df_202304)
colnames(df_202305)
colnames(df_202306)
colnames(df_202307)
colnames(df_202308)
colnames(df_202309)
colnames(df_202310)
colnames(df_202311)
colnames(df_202312)

#=======================#
# data type comparisons #
#=======================#

# compare the data types in each column across all the data sets by view the structure of each data set

str(df_202301)
str(df_202302)
str(df_202303)
str(df_202304)
str(df_202305)
str(df_202306)
str(df_202307)
str(df_202308)
str(df_202309)
str(df_202310)
str(df_202311)
str(df_202312)

#=======================#
# data sets unification #
#=======================#

# combine all the data sets into 1 main data set

df_2023 <- rbind(df_202301, df_202302, df_202303, df_202304, df_202305, df_202306, df_202307, df_202308, df_202309, df_202310, df_202311, df_202312)

#=============#
# $ride_length #
#=============#

# create:     column ($ride_length)
# calculate:  ($ended_at - $started_at)
# purpose:    calculate the length of each ride by each type of user throughout the year

df_2023$ride_length <- difftime(df_2023$ended_at, df_2023$started_at)

#========================#
# $ride_length_formatted #
#========================#

# create:     column ($ride_length_formatted)
# calculate:  format $ride_length as HH:MM:SS
# purpose:    format the length of each ride by each type of user throughout the year as HH:MM:SS

df_2023$ride_length_formatted <- as_hms(df_2023$ride_length)

#==============#
# $day_of_week #
#==============#

# create:     column ($day_of_week)
# calculate:  format ($started_at) as day of the week
# purpose:    calculate the day of the week that each ride took place on

df_2023$day_of_week <- weekdays(df_2023$started_at, abbreviate = FALSE)

#======================#
# $day_of_week_numeric #
#======================#

# create:     column ($day_of_week_numeric)
# calculate:  format ($day_of_week) as a numerical value 0-7
# purpose:    help to sort days of the week

df_2023$day_of_week_numeric <- wday(df_2023$started_at)

#================#
# $month_of_year #
#================#

# create:     column ($month_of_year)
# calculate:  format ($started_at) as month of the year
# purpose:    calculate the month of the year that each ride took place on

df_2023$month_of_year <- months.Date(df_2023$started_at, abbreviate = FALSE)

#========================#
# $month_of_year_numeric #
#========================#

# create:     column ($month_of_year_numeric)
# calculate:  format ($month_of_year) as a numerical value 0-12
# purpose:    help to sort months of the year

df_2023$month_of_year_numeric <- month(df_2023$started_at, label = FALSE, abbr = FALSE)

#=============#
# $hour_of_day #
#=============#

# create:     column ($hour_of_day)
# calculate:  format ($started_at) as an hour of the day
# purpose:    calculate the hour of the day that each ride took place on 

df_2023$hour_of_day <- hour(df_2023$started_at)

#==================#
# duplicates check #
#==================#

# purpose:    check for duplicates in the ($ride_id) column to make sure each trip is distinct

sum(duplicated(df_2023$ride_id))

#=====================#
# discrepancies check #
#=====================#

# purpose:    check for any discrepancies in the ($member_casual) and ($rideable_type) columns

unique(df_2023$member_casual)
unique(df_2023$rideable_type)

#======#
# NOTE #
#======#

# the data set has NULL values for some of the starting stations and ending stations
# in an actual project, it would be a good idea to ask for help and how to proceed to correct the issue
# for this project, that option is not available so all NA (NULL) values will be dropped (excluded) from the data set

#==================#
# drop NULL values #
#==================#

df_2023 <- df_2023 %>% drop_na()

#======#
# NOTE #
#======#

# the data set has negative ($ride_length) values for some of the trips
# also, there seems to be trips that are less than a minute and the starting stations and the ending stations are the same location which could indicate that users had some troubles with the bikes
# in an actual project, it would be a good idea to ask for help and how to proceed to correct the issue
# for this project, that option is not available so all trips with negative ($ride_length) values will be filtered out

#========================#
# filter negative values #
#========================#

# purpose:    filter (remove) trips with negative values in the ($ride_length) column

df_2023 <- df_2023 %>% 
  filter(ride_length > 0)

#===============#
# export to CSV #
#===============#

# purpose:    export the cleaned data set to a CSV file for future use efficiency and for further analysis in Tableau

write_csv(df_2023, "TD_2023.csv")

#==================#
# summary creation #
#==================#

# purpose:    calculate and compare the number of rides by user type throughout the year
# results:    presented as a total number and as a percentage

summary_total_rides_yearly <- df_2023 %>% 
  group_by(member_casual) %>% 
  summarize(total_number_of_rides = n()) %>% 
  mutate(as_percentage = (total_number_of_rides * 100) / sum(total_number_of_rides)) %>% 
  mutate(as_percentage_whole = as.integer(as_percentage))

#===============#
# export to CSV #
#===============#

# purpose:    export the summary to a CSV file for future use efficiency and for further analysis in Tableau

write_csv(summary_total_rides_yearly, "summary_total_rides_yearly.csv")

#===============#
# visualization #
#===============#

# purpose:    visualize the summary_total_rides_yearly summary in a bar chart

ggplot(data = summary_total_rides_yearly, mapping = aes(x = member_casual, y = total_number_of_rides, fill = member_casual)) +
  geom_col() +
  geom_text(aes(label = scales::comma(total_number_of_rides)), color = "white", position = position_stack(vjust = 0.5)) +
  labs(
    title = "Yearly Total Number of Rides", 
    subtitle = "Member Users vs. Casual Users", 
    caption = "based on data from Cyclistics", 
    tag = "2023 Data",
    x = "type of user",
    y = "total number of rides"
  ) +
  scale_y_continuous(labels = scales::comma) +
  theme(
    legend.title = element_blank(),
    plot.title = element_text(h = 0.5),
    plot.subtitle = element_text(h = 0.5))

#===============#
# visualization #
#===============#

# purpose:    visualize the summary_total_rides_yearly summary in a pie chart

ggplot(data = summary_total_rides_yearly, mapping = aes(x = "", y = as_percentage_whole, fill = member_casual)) +
  geom_col() +
  coord_polar(theta = "y") +
  geom_text(aes(label = paste(as_percentage_whole, "%")), color = "white", position = position_stack(vjust = 0.5)) +
  labs(
    title = "Yearly Total Number of Rides by Percentage",
    subtitle = "Member Users vs. Casual Users",
    caption = "based on data from Cyclistics",
    tag = "2023 Data",
    x = "",
    y = ""
  ) +
  theme(
    legend.title = element_blank(),
    plot.title = element_text(h = 0.5),
    plot.subtitle = element_text(h = 0.5)
  )

#==================#
# summary creation #
#==================#

# purpose:    calculate and compare the total number of rides by user type by month throughout the year
# results:    presented as whole numbers

summary_total_rides_monthly <- df_2023 %>% 
  group_by(member_casual, month_of_year, month_of_year_numeric) %>% 
  summarize(total_number_of_rides = n())

#===============#
# export to CSV #
#===============#

# purpose:    export the summary to a CSV file for future use efficiency and for further analysis in Tableau

write_csv(summary_total_rides_monthly, "summary_total_rides_monthly.csv")

#===============#
# visualization #
#===============#

# purpose:    visualize the summary_total_rides_monthly summary in a bar chart

ggplot(data = summary_total_rides_monthly, mapping = aes(x = factor(month_of_year, level = c('December', 'November', 'October', 'September', 'August', 'July', 'June', 'May', 'April', 'March', 'February', 'January')), y = total_number_of_rides, fill = member_casual)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  geom_text(aes(label = scales::comma(total_number_of_rides)), color = "black", size = 2, hjust = 1.1, vjust = 0.4, position = position_dodge(width = 1)) +
  labs(
    title = "Monthly Total Number of Rides", 
    subtitle = "Member Users vs. Casual Users", 
    caption = "based on data from Cyclistics", 
    tag = "2023 Data",
    x = "month of the year",
    y = "total number of rides"
  ) +
  scale_y_continuous(labels = scales::comma) +
  theme(
    legend.title = element_blank(),
    plot.title = element_text(h = 0.5),
    plot.subtitle = element_text(h = 0.5))

#==================#
# summary creation #
#==================#

# purpose:    calculate and compare the number of rides by user type by day of the week throughout the year
# results:    presented as whole numbers

summary_total_rides_daily <- df_2023 %>% 
  group_by(member_casual, day_of_week, day_of_week_numeric) %>% 
  summarize(total_number_of_rides = n())

#===============#
# export to CSV #
#===============#

# purpose:    export the summary to a CSV file for future use efficiency and for further analysis in Tableau

write_csv(summary_total_rides_daily, "summary_total_rides_daily.csv")

#===============#
# visualization #
#===============#

# purpose:    visualize the summary_total_rides_daily summary in a bar chart

ggplot(data = summary_total_rides_daily, mapping = aes(x = factor(day_of_week, level = c('Saturday', 'Friday', 'Thursday', 'Wednesday', 'Tuesday', 'Monday', 'Sunday')), y = total_number_of_rides, fill = member_casual)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  geom_text(aes(label = scales::comma(total_number_of_rides)), color = "black", size = 4, hjust = 1.1, vjust = 0.4, position = position_dodge(width = 1)) +
  labs(
    title = "Daily Total Number of Rides", 
    subtitle = "Member Users vs. Casual Users", 
    caption = "based on data from Cyclistics", 
    tag = "2023 Data",
    x = "day of the week",
    y = "total number of rides"
  ) +
  scale_y_continuous(labels = scales::comma) +
  theme(
    legend.title = element_blank(),
    plot.title = element_text(h = 0.5),
    plot.subtitle = element_text(h = 0.5))

#==================#
# summary creation #
#==================#

# purpose:    calculate and compare the number of rides by user type by hour of the day throughout the year
# results:    presented as whole numbers

summary_total_rides_hourly <- df_2023 %>% 
  group_by(member_casual, hour_of_day) %>% 
  summarize(total_number_of_rides = n())

#===============#
# export to CSV #
#===============#

# purpose:    export the summary to a CSV file for future use efficiency and for further analysis in Tableau

write_csv(summary_total_rides_hourly, "summary_total_rides_hourly.csv")

#===============#
# visualization #
#===============#

# purpose:    visualize the summary_total_rides_hourly summary in a bar chart

ggplot(data = summary_total_rides_hourly, mapping = aes(x = factor(hour_of_day, level = c(24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 09, 08, 07, 06, 05, 04, 03, 02, 01, 00)), y = total_number_of_rides, fill = member_casual)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  geom_text(aes(label = scales::comma(total_number_of_rides)), color = "black", size = 2, hjust = 1.1, vjust = 0.4, position = position_dodge(width = 1)) +
  labs(
    title = "Hourly Total Number of Rides", 
    subtitle = "Member Users vs. Casual Users", 
    caption = "based on data from Cyclistics", 
    tag = "2023 Data",
    x = "hour of the day",
    y = "total number of rides"
  ) +
  scale_y_continuous(labels = scales::comma) +
  theme(
    legend.title = element_blank(),
    plot.title = element_text(h = 0.5),
    plot.subtitle = element_text(h = 0.5))

#==================#
# summary creation #
#==================#

# purpose:    calculate the total number of bike types used throughout the year by user type
# results:    presented as whole numbers as well as a percentage

summary_rideable_types_used <- df_2023 %>% 
  group_by(member_casual, rideable_type) %>% 
  summarize(rideable_type_used = n()) %>% 
  mutate(as_percentage = (rideable_type_used *100) / sum(rideable_type_used)) %>% 
  mutate(as_percentage_whole = as.integer(as_percentage))

#===============#
# export to CSV #
#===============#

# purpose:    export the summary to a CSV file for future use efficiency and for further analysis in Tableau

write_csv(summary_rideable_types_used, "summary_rideable_types_used.csv")

#===============#
# visualization #
#===============#

# purpose:    visualize the summary_rideable_types_used summary in a bar chart

ggplot(data = summary_rideable_types_used, mapping = aes(x = member_casual, y = rideable_type_used, fill = rideable_type)) +
  geom_col() +
  geom_text(aes(label = scales::comma(rideable_type_used)), color = "white", position = position_stack(vjust = 0.5)) +
  labs(
    title = "Types of Bikes Used", 
    subtitle = "Member Riders vs. Casual Riders", 
    caption = "based on data from Cyclistics", 
    tag = "2023 Data", 
    x = "type of rider",
    y = "number of bikes used") +
  scale_y_continuous(labels = scales::comma) +
  theme(
    legend.title = element_blank(), 
    plot.title = element_text(h = 0.5), 
    plot.subtitle = element_text(h = 0.5))

#==================#
# summary creation #
#==================#

# purpose:    calculate the yearly average ride length by user type
# results:    presented as seconds and also formatted as HH:MM:SS

summary_average_ride_length_yearly <- df_2023 %>% 
  group_by(member_casual) %>% 
  summarize(yearly_average_ride_length = mean(ride_length)) %>% 
  mutate(yearly_average_ride_length_formatted = as_hms(round(yearly_average_ride_length)))

#===============#
# export to CSV #
#===============#

# purpose:    export the summary to a CSV file for future use efficiency and for further analysis in Tableau

write_csv(summary_average_ride_length_yearly, "summary_average_ride_length_yearly.csv")

#===============#
# visualization #
#===============#

# purpose:    visualize the summary_average_ride_length_yearly summary in a bar chart

ggplot(data = summary_average_ride_length_yearly, mapping = aes(x = member_casual, y = yearly_average_ride_length_formatted, fill = member_casual)) +
  geom_col() +
  geom_text(aes(label = yearly_average_ride_length_formatted), color = "white", position = position_stack(vjust = 0.5)) +
  labs(
    title = "Yearly Average Ride Length", 
    subtitle = "Member Riders vs. Casual Riders", 
    caption = "based on data from Cyclistics", 
    tag = "2023 Data",
    x = "type of rider",
    y = "average ride length") +
  theme(
    legend.title = element_blank(),
    plot.title = element_text(h = 0.5),
    plot.subtitle = element_text(h = 0.5))

#==================#
# summary creation #
#==================#

# purpose:    calculate the monthly average ride length by user type
# results:    presented as seconds and also formatted as HH:MM:SS

summary_average_ride_length_monthly <- df_2023 %>% 
  group_by(member_casual, month_of_year, month_of_year_numeric) %>% 
  summarize(monthly_average_ride_length = mean(ride_length)) %>% 
  mutate(monthly_average_ride_length_formatted = as_hms(round(monthly_average_ride_length)))

#===============#
# export to CSV #
#===============#

# purpose:    export the summary to a CSV file for future use efficiency and for further analysis in Tableau

write_csv(summary_average_ride_length_monthly, "summary_average_ride_length_monthly.csv")

#===============#
# visualization #
#===============#

# purpose:    visualize the summary_average_ride_length_monthly summary in a bar chart

ggplot(data = summary_average_ride_length_monthly, mapping = aes(x = factor(month_of_year, level = c('December', 'November', 'October', 'September', 'August', 'July', 'June', 'May', 'April', 'March', 'February', 'January')), y = monthly_average_ride_length_formatted, fill = member_casual)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() + 
  geom_text(aes(label = monthly_average_ride_length_formatted), color = "black", size = 2, hjust = 1.1, vjust = 0.4, position = position_dodge(width = 1)) +
  labs(
    title = "Monthly Average Ride Length", 
    subtitle = "Member Riders vs. Casual Riders", 
    caption = "based on data from Cyclistics", 
    tag = "2023 Data",
    x = "month of the year",
    y = "average ride length") +
  theme(
    legend.title = element_blank(),
    plot.title = element_text(h = 0.5),
    plot.subtitle = element_text(h = 0.5))

#==================#
# summary creation #
#==================#

# purpose:    calculate the daily average ride length by user type
# results:    presented as seconds and also formatted as HH:MM:SS

summary_average_ride_length_daily <- df_2023 %>% 
  group_by(member_casual, day_of_week, day_of_week_numeric) %>% 
  summarize(daily_average_ride_length = mean(ride_length)) %>% 
  mutate(daily_average_ride_length_formatted = as_hms(round(daily_average_ride_length)))

#===============#
# export to CSV #
#===============#

# purpose:    export the summary to a CSV file for future use efficiency and for further analysis in Tableau

write_csv(summary_average_ride_length_daily, "summary_average_ride_length_daily.csv")

#===============#
# visualization #
#===============#

# purpose:    visualize the summary_average_ride_length_daily summary in a bar chart

ggplot(data = summary_average_ride_length_daily, mapping = aes(x = factor(day_of_week, level = c("Saturday", "Friday", "Thursday", "Wednesday", "Tuesday", "Monday", "Sunday")), y = daily_average_ride_length_formatted, fill = member_casual)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  geom_text(aes(label = daily_average_ride_length_formatted), color = "black", size = 2, hjust = 1.1, vjust = 0.4, position = position_dodge(width = 1)) +
  labs(
    title = "Daily Average Ride Length", 
    subtitle = "Member Users vs. Casual Users", 
    caption = "based on data from Cyclistics", 
    tag = "2023 Data",
    x = "day of the week",
    y = "average ride length"
  ) +
  theme(
    legend.title = element_blank(),
    plot.title = element_text(h = 0.5),
    plot.subtitle = element_text(h = 0.5))

#==================#
# summary creation #
#==================#

# purpose:    calculate the daily average ride length by user type
# results:    presented as seconds and also formatted as HH:MM:SS

summary_average_ride_length_hourly <- df_2023 %>% 
  group_by(member_casual, hour_of_day) %>% 
  summarize(hourly_average_ride_length = mean(ride_length)) %>% 
  mutate(hourly_average_ride_length_formatted = as_hms(round(hourly_average_ride_length)))

#===============#
# export to CSV #
#===============#

# purpose:    export the summary to a CSV file for future use efficiency and for further analysis in Tableau

write_csv(summary_average_ride_length_hourly, "summary_average_ride_length_hourly.csv")

#===============#
# visualization #
#===============#

# purpose:    visualize the summary_average_ride_length_hourly summary in a bar chart

ggplot(data = summary_average_ride_length_hourly, mapping = aes(x = factor(hour_of_day, level = c(24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 09, 08, 07, 06, 05, 04, 03, 02, 01)), y = hourly_average_ride_length_formatted, fill = member_casual)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  geom_text(aes(label = hourly_average_ride_length_formatted), color = "black", size = 2, hjust = 1.1, vjust = 0.4, position = position_dodge(width = 1)) +
  labs(
    title = "Hourly Average Ride Length", 
    subtitle = "Member Users vs. Casual Users", 
    caption = "based on data from Cyclistics", 
    tag = "2023 Data",
    x = "hour of day",
    y = "average ride length"
  ) +
  theme(
    legend.title = element_blank(),
    plot.title = element_text(h = 0.5),
    plot.subtitle = element_text(h = 0.5))

#===================#
# function creation #
#===================#

# purpose:    create a function to calculate the "mode" of the input

function_mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

#==================#
# summary creation #
#==================#

# purpose:    calculate the month with the most trips by user type
# results:    presented as a whole number

summary_mode_month <- df_2023 %>% 
  group_by(member_casual) %>% 
  summarize(mode_month = function_mode(month_of_year))

#===============#
# export to CSV #
#===============#

# purpose:    export the summary to a CSV file for future use efficiency and for further analysis in Tableau

write_csv(summary_mode_month, "summary_mode_month.csv")

#==================#
# summary creation #
#==================#

# purpose:    calculate the day with the most trips by user type
# results:    presented as a whole number

summary_mode_day <- df_2023 %>% 
  group_by(member_casual) %>% 
  summarize(mode_day = function_mode(day_of_week))

#===============#
# export to CSV #
#===============#

# purpose:    export the summary to a CSV file for future use efficiency and for further analysis in Tableau

write_csv(summary_mode_day, "summary_mode_day.csv")

#==================#
# summary creation #
#==================#

# purpose:    calculate the hour with the most trips by user type
# results:    presented as a whole number

summary_mode_hour <- df_2023 %>% 
  group_by(member_casual) %>% 
  summarize(mode_hour = function_mode(hour_of_day))

#===============#
# export to CSV #
#===============#

# purpose:    export the summary to a CSV file for future use efficiency and for further analysis in Tableau

write_csv(summary_mode_hour, "summary_mode_hour.csv")



