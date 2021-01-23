shinyUI(dashboardPage(
    dashboardHeader(title=paste("New COVID Cases", as_of_date)),
    dashboardSidebar(
        sidebarUserPanel("David", image = 'DPW_20201121.jpg'),
        sidebarMenu(
            menuItem("Graph", tabName = "graph", icon = icon("map")),
            ## icon is a built-in function that has a library of icons
            menuItem("Data", tabName = "data", icon = icon("database"))
        )
    ),
    dashboardBody(tabItems(
        tabItem(
            tabName = 'graph',
            
            fluidRow(
                infoBoxOutput("latestMaxBox"),
                infoBoxOutput("latestMinBox"),
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
                fluidRow(box(
                    DT::dataTableOutput("table"), width = 12
                )))
    ))
))