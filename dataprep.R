library(htmltab)

state_df <- data.frame(state.abb,state.name)

Wiki_url = 'https://en.wikipedia.org/wiki/List_of_states_and_territories_of_the_United_States_by_population'

census_df = htmltab(Wiki_url,1) # Get the first table on the HTML web page
census_df = census_df %>% select(c(3,4)) # Take the State and Est 2020 Population columns
colnames(census_df) = c('State','Population2020') # Rename the columns

census_df = census_df %>% 
  mutate(State = substr(State,3,length(State)-2),
         Population2020=parse_number(Population2020)
  ) %>% inner_join(state_df, by=c("State"="state.name"))

# Data downloaded from https://healthdata.gov/dataset/united-states-covid-19-cases-and-deaths-state-over-time
covid_data <- read.csv('./data/United_States_COVID-19_Cases_and_Deaths_by_State_over_Time.csv')

covid_data[['submission_date']] <- as.Date(covid_data[['submission_date']], "%m/%d/%Y")
covid_data$new_case[covid_data$new_case<0] = 0 # Correction for negative new cases in data

covid_data <- covid_data %>% 
  group_by(., state) %>% 
  arrange(., state, submission_date) %>% 
  mutate(., delta_new_case=new_case-lag(new_case,1), delta_new_death=new_death-lag(new_death,1)) %>% 
  select(., state, submission_date, tot_cases,new_case,delta_new_case, tot_death,new_death,delta_new_death) %>% 
  inner_join(census_df, by=c("state"="state.abb")) %>% 
  mutate(total_cases_per_capita=tot_cases/Population2020,
         new_cases_per_capita=new_case/Population2020,
         total_death_per_capita=tot_death/Population2020,
         new_death_per_capita=new_death/Population2020,
         mortality_rate=tot_death/tot_cases)

covid_data = covid_data %>% 
  select(State=State,
         'State Abbr'=state,
         'Submission Date'=submission_date, 
         Population=Population2020,
        'Total Cases'=tot_cases, 
        'New Cases'=new_case, 
        'Change(New Cases)'=delta_new_case,
        'Total Deaths'=tot_death,
        'New Deaths'=new_death, 
        'Change(New Deaths)'=delta_new_death,
        'Total Cases Per Capita'=total_cases_per_capita, 
        'New Cases Per Capita'=new_cases_per_capita,
        'Total Deaths Per Capita'=total_death_per_capita, 
        'New Deaths Per Capita'=new_death_per_capita,
        'Mortality Rate'=mortality_rate)

colChoices <- sort(colnames(covid_data)[-1:-4])
colFormats <- c(1,1,100,1,100,1,100,1,100,1,100)
value_formats = data.frame(col=colChoices,format=colFormats)

latest_date <- max(covid_data$`Submission Date`)
as_of_date <- format(latest_date, "%m/%d/%Y")

states <- state.name

latest_data <- covid_data %>% 
  ungroup() %>% 
  filter(`Submission Date`==latest_date, State %in% states)

