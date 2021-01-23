shinyUI(dashboardPage(
    dashboardHeader(title=paste("New COVID Cases", as_of_date)),
    dashboardSidebar(
        sidebarUserPanel("David", image = 'Me 20201121.jpg'),
        sidebarMenu(
            menuItem("Graph", tabName = "graph", icon = icon("map")),
            ## icon is a built-in function that has a library of icons
            menuItem("Data by State", tabName = "data", icon = icon("database"))
        ),
        selectizeInput(
            inputId = 'stateSel',
            label = 'Choose a location:',
            choice = states
        ),
        selectizeInput(
            inputId = 'colSel',
            label = 'Choose a metric:',
            choice = colChoices
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

            fluidRow(box(plotOutput("covidPlot"), width=12, height = "300"))
        ),
        tabItem(tabName = "data",
                fluidRow(box(
                    DT::dataTableOutput("table"), width = 12
                )))
    ))
))