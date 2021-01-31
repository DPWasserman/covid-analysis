# Analysis of COVID in the United States
## Project Background

During the past year, the world has been beset by a pandemic going by many names: Coronavirus, COVID-19, SARS-COV-2, et al. It is said that to defeat your opponent, one must know your enemy. Understanding trend analysis and correlation is a good approach.

This project attempts to visualize the daily trends of the disease on a state by state basis. The starting data is composed of positive and negative tests, deaths from COVID, and estimated 2020 population. These data points allowed the computation of mortality rates, positivity rates, and per capita calculations. Data was aggregated across the 50 states to simulate the United States.

Data about the disease was obtained from [covidtracking.com](https://covidtracking.com/data/download/all-states-history.csv) while estimated population data for 2020 came from [Wikipedia](https://en.wikipedia.org/wiki/List_of_states_and_territories_of_the_United_States_by_population).

The application is hosted at the following URL: https://dpwasserman.shinyapps.io/COVID_analysis/

## Setup Instructions

1. Create a data folder
2. Execute the census_extraction.R program
3. Download the data from covidtracking.com and place in the data folder
4. Execute the R Shiny App (from global.R, server.R, or ui.R)