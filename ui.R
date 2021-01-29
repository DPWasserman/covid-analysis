shinyUI(dashboardPage(
    dashboardHeader(title=paste("COVID Analysis as of", as_of_date),
                    titleWidth=350),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Introduction", tabName = "intro", icon = icon("clinic-medical")),
            menuItem("State Graphs", tabName = "graph", icon = icon("map")),
            menuItem("Data", tabName = "data", icon = icon("database")),
            menuItem("About", tabName = 'about', icon=icon("address-card"))
        )
    ),
    dashboardBody(tabItems(
        tabItem(tabName = 'intro',
                fluidRow(box(p('During the past year, the world has been beset by 
                             a pandemic going by many names: Coronavirus, COVID-19, SARS-COV-2, et al.
                             It is said that to defeat one\'s opponent, one must know the enemy.
                             Understanding trend analysis and correlation is a good approach.'),
                             p('This project attempts to visualize the trends of the disease on two levels: 
                             Cases and Deaths. This is done on a state by state basis.'),
                             p('Data about the disease was obtained from ',
                               a('covidtracking.com',
                                 href=covid_url), 
                               'while population data for 2020 came from ',
                               a('Wikipedia',href=wiki_url),'.'),
                             title="Introduction", width=12))),
        
        tabItem(
            tabName = 'graph',
            fluidRow(
                infoBoxOutput("latestMinBox"), 
                infoBoxOutput("latestMaxBox"),
                infoBoxOutput("latestAvgBox")
            ),

            fluidRow(box(plotOutput("covidPlot"), width=12)),
            fluidRow(box(selectizeInput(
                inputId = 'stateSel',
                label = 'Choose a state:',
                choice = states
            ),width=6),box(
            selectizeInput(
                inputId = 'colSel',
                label = 'Choose a metric:',
                choice = colChoices
            ),width=6))
        ),
        
        tabItem(tabName = "data",
                fluidRow(box(dataTableOutput("table"), width = 12))
                ),
        
        tabItem(tabName='about',
                fluidRow(box(
                             p(img(src='DPW_20201121.jpg',height=50,width=50),
                               'Author: David Wasserman'),
                             br(),
                             p('Email:',a('davidphilipwasserman@gmail.com',
                                          href='mailto:davidphilipwasserman@gmail.com')), 
                             br(),
                             p('GitHub:',a('https://github.com/DPWasserman/covid_analysis',
                                           href='https://github.com/DPWasserman/covid_analysis'))
                             )
                         )
                )
    ))
))