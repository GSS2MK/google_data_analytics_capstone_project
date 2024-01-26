# google_data_analytics_capstone_project


This project is my Google Data Analytics Capstone Project that is required by the Google Data Analytics program offered by Google on Coursera.com. I was asked to choose a case study to work on to highlight my skills learned in the program.

## THE CASE STUDY SUMMARY

In the case study I selected, I was hired as a junior data analyst to work on the marketing analyst team at a fictional company, Cyclistic, a bike-share company located in Chicago that features more than 5,800 bicycles and 600 docking stations.

### ASK

My goal was to highlight how annual members and casual riders use Cyclistic bikes differently in order to help the marketing team convert casual users into member users. 

Here is a list of questions that I asked myself to help me with my goal:

**What is the yearly total number of rides by bike type?**

**What is the yearly total number of rides by user type? Monthly? Daily? Hourly?**

**What is the yearly average ride length by user type? Monthly? Daily? Hourly?**

**What is the mode month of the year? Day of week? Hour of day?** 

### PREPARE

In order to prepare my data, I was tasked with downloading the most recent 12 months of Cyclistic trip data. Each month was a separate CSV file. I downloaded all 12 files into a single folder called original_data. The files contained in this folder are not to be changed in any way as they are the original data sets and should any problems occur in the future, I have a copy of the original data sets to refer back to. 

At the time of doing the project, the most recent 12 months of Cyclistic trip data for me happened to be between January 2023 and December 2023, the entire year of 2023.  

### PROCESS

To process the data, I was asked to open each file separately in a spreadsheet application of my choosing. After opening the first month of data in Google Sheets, I realized that there were over 1,000 rows of data and the file took some time to open. It was at this moment that I decided to conduct my data analysis with R because it would allow me to work with the big data set.  

In R Studio, I created a new project called google_data_analytics_capstone_project. I then pasted into this folder a copied version of the original_data folder. 

The following steps were taken next to further process the data:

#### LIBRARIES

All libraries needed to analyze the data were installed:

library(tidyverse)
library(hms)
library(scales)

#### IMPORT DATA

All 12 data sets were imported into R using the read_csv() function to import the data sets into data frames.

#### CHECKS AND COMPARISONS

Each data frame was checked to make sure that all column names were uniform and coherent, meaning that there were no unnecessary characters in the column names and that every distinct column name matched across the different data frames. Next, the data types in each column of each data frame was compared to make sure they matched each other. These two steps were very important as the goal was to merge all the data frames into a single data frame for analysis. 

#### COMBINE DATA FRAMES

After making sure all data frames were identical in structure, they were combined into a single data frame using the rbind() function.

#### CREATE NEW COLUMNS

Seven new columns were created to help analyze the data:

$ride_length
$ride_length_formatted
$day_of_week
$day_of_week_numeric
$month_of_year
$month_of_year_numeric
$hour_of_day

#### DUPLICATIONS AND DISCREPANCIES

In order to properly analyze the data, every trip in the data frame needs to be discrete. To do this, the sum() and duplicated() functions were used. After checking for duplicated data, I checked for any discrepancies with the types of users and the types of bikes they used. To accomplish this, I used the unique() function.

#### DROP DATA

Some of the starting stations and ending stations had missing data. To address this issue, I used the drop_na() function to drop (remove) the rows with missing data.

#### FILTER DATA

After viewing the data, some of the ride lengths had negative values. I used the filter() function to filter out these rows. 

#### CLEAN DATA EXPORT

The data frame was finally processed and cleaned so I decided to use the write_csv() function to export this data frame to a CSV file. This allowed me to have a clean copy of the data in a CSV file format that I can use later on in Tableau as well as if I decided to work with the data on a separate day. I would not have to repeat the steps above to get the clean data I need, I can just import the cleaned data CSV file.

#### ANALYZE

To analyze the data, I created summaries of the data frame to answer the questions I asked myself and then visualized them to get a better understanding. Each summary was exported to a CSV file and every plot was saved to a PNG and PDF file.

#### SHARE

To share the data, I imported the cleaned data CSV file as well as all the summary CSV files into Tableau for visualization. Here, I recreated the plots above. Tableau made some of the visualizations a little easier to view such as the Hourly Total Number of Rides. 

[Visualization on Tableau](https://public.tableau.com/app/profile/gss2mk/viz/GoogleAnalyticsCapstoneProject_17057875717240/Dashboard2)

#### ACT

To act on the data, I needed to give 3 recommendations based on my analysis. 

#### DATA SUMMARY

Member users ride bikes more than casual users, however, casual users spend more time riding bikes than member users. 

Member users are riding bikes more in the mornings and the evenings, during what is considered normal business hours. We can hypothesize that member users are riding bikes to commute to and from work. This hypothesis is further supported by the fact that member users are riding bikes more during the week than on the weekends. 

#### RECOMMENDATIONS

What can I suggest that would help the marketing team convert casual users into member users after visualizing the data?

1.  Offer a financial incentive for a casual user to become a member user. Although transactions were not included in this data set, from a marketing perspective, customers are more inclined to become a member of a company if they can receive some sort of monetary savings. 

2.  Introduce member user only benefits. This can be in the form of badges or trophies or points a member can earn so they can use elsewhere. 

3.  We can simply poll casual users and ask them directly how we can help them become a member. This would give us insight into providing something more than currently offered. 

4.  If we can determine what the top starting and ending stations are for casual users, we can target those stations more with advertising to become a member user.
