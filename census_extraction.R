library(htmltab)
library(tidyverse)

Wiki_url = 'https://en.wikipedia.org/wiki/List_of_states_and_territories_of_the_United_States_by_population'

census_df = htmltab(Wiki_url,1) # Get the first table on the HTML web page
census_df = census_df %>% select(3:4) # Take the State and Est 2020 Population columns
colnames(census_df) = c('State','Population2020') # Rename the columns

census_df = census_df %>% 
  mutate(State = substr(State,3,length(State)-2),
         Population2020=parse_number(Population2020)
  ) %>% inner_join(state_df, by=c("State"="state.name"))

write.csv(census_df, './data/census2020.csv')
