## Variables to hold the USA (Used for aggregation)
USA.abb <- 'USA'
USA <- ' United States of America'

## Creates the States filter
state_df <- data.frame(state.abb=c(state.abb,USA.abb),state.name=c(state.name, USA))
states <- sort(c(state.name, USA))

## Source of the Census data
wiki_url = 'https://en.wikipedia.org/wiki/List_of_states_and_territories_of_the_United_States_by_population'
census_df <- read.csv('./data/census2020.csv')
usa_census = list(USA, sum(census_df$Population2020), USA.abb)
census_df = rbind(census_df,setNames(usa_census, names(census_df)))

## Form the COVID data set
covid_url = 'https://covidtracking.com/data/download/all-states-history.csv'
covid_data <- read.csv('data/all-states-history.csv')  
# covid_data <- read.csv(covid_url) ### Could be used to read data from the site

covid_data$negative[is.na(covid_data$negative)] = covid_data$totalTestResults[is.na(covid_data$negative)] - 
                                                  covid_data$positive[is.na(covid_data$negative)]
covid_data$negative = ifelse(covid_data$negative<0,0,covid_data$negative)


covid_data = covid_data %>% 
  filter(state %in% state.abb) %>% 
  select(submission_date=date,
         state,
         
         tot_death=death,
         tot_negative=negative,
         tot_cases=positive,
         tot_tests=totalTestResults,
         
         new_cases=positiveIncrease,
         new_death=deathIncrease,
         new_negative=negativeIncrease,
         new_tests=totalTestResultsIncrease) %>%
  
  mutate(submission_date=as.Date(submission_date, '%Y-%m-%d')) %>% 
  filter(submission_date>'2020-03-01')

us_data = covid_data %>% 
  group_by(submission_date) %>% 
  summarise_if(.predicate=is.numeric,.funs=sum,na.rm=T) %>% 
  mutate(state=USA.abb)

covid_data = covid_data %>% 
  rbind(us_data) %>% 
  arrange(state,submission_date) %>% 
  mutate(positivity_rate=case_when(new_tests==0 ~ 0,
                                   TRUE ~ new_cases/new_tests),
         positivity_rate=case_when(positivity_rate >= 1 ~ 1,
                                   positivity_rate <= 0 ~ 0,
                                   TRUE ~ positivity_rate)) %>% # Fixing irregularities in data collection
  inner_join(census_df,by=c("state"="state.abb")) %>% 
  group_by(state) %>% 
  mutate(new_cases_per_capita=new_cases/Population2020,
         new_death_per_capita=new_death/Population2020,
         new_tests_per_capita=new_tests/Population2020,
         roll7d_new_cases_per_capita=rollmean(new_cases_per_capita,k=7,fill=NA,align='right'),
         roll7d_new_death_per_capita=rollmean(new_death_per_capita,k=7,fill=NA,align='right'),
         roll7d_new_tests_per_capita=rollmean(new_tests_per_capita,k=7,fill=NA,align='right')) %>% 
  select(State,
         "State Abbr"=state,
         'Submission Date'=submission_date,
         'Total Deaths'=tot_death,
         'Total Tests'=tot_tests,
         'Total Positive Cases'=tot_cases,
         'Total Negative Tests'=tot_negative,
         'New Deaths'=new_death,
         'New Tests'=new_tests,
         'New Positive Cases'=new_cases,
         'New Negative Tests'=new_negative,
         'Positivity Rate'=positivity_rate,
         'Per Capita New Cases'=new_cases_per_capita,
         'Per Capita New Deaths'=new_death_per_capita,
         'Per Capita New Tests' =new_tests_per_capita,
         'Rolling 7 Day New Cases Per Capita'=roll7d_new_cases_per_capita,
         'Rolling 7 Day New Deaths Per Capita'=roll7d_new_death_per_capita,
         'Rolling 7 Day New Tests Per Capita'=roll7d_new_tests_per_capita
  )

## Latest date is used to show in the title
latest_date <- max(covid_data$`Submission Date`)
as_of_date <- format(latest_date, "%m/%d/%Y")

## Latest data is used in info boxes
latest_data <- covid_data %>% 
  filter(`Submission Date`==latest_date,
         State != USA)

## Formats are used to display different attributes using the correct numeric format
colChoices <- sort(colnames(covid_data)[-1:-3])
colFormats <- c(1,1,1,1,100,100,100,100,100,100,100,1,1,1,1) # 1 = comma, 100 = percentage
value_formats = data.frame(col=colChoices,format=colFormats) 
