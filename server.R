shinyServer(function(input, output) {
    
    # data <- reactive({ covid_data %>% filter(., state==input$stateSel) }) # Do I need to use reactive at all?

    # maximum box ####
    output$latestMaxBox <- renderInfoBox({
        get_info(latest_data, input$colSel, max,icon("hand-o-down"))
    })

    # minimum box ####
    output$latestMinBox <- renderInfoBox({
        get_info(latest_data, input$colSel, min, icon("hand-o-up"))
    })

    # average box ####
    output$latestAvgBox <- renderInfoBox(
        get_info(latest_data, input$colSel, median, icon('calculator'))
    )
    
    # graph ####
    columnSelect = reactive(paste0("`",input$colSel,"`"))
    
    output$covidPlot <- renderPlot({
        ggplot(covid_data %>% 
                   filter(.,State==input$stateSel), 
               aes_string(x="`Submission Date`", 
                   y=columnSelect())) + 
            # geom_smooth(method='loess', formula='y~x', se=F) +
            geom_line(aes(color=State)) +
            ggtitle(paste(input$colSel,"Over Time for",input$stateSel)) +
            theme(plot.title=element_text(hjust=0.5))
    })
    
    # datatable ####
    output$table <- renderDataTable({
        datatable(covid_data %>% 
            arrange(.,desc(`Submission Date`),State),rownames = FALSE) %>%
            formatCurrency(4:11, currency="", interval=3,mark=",",digits=0) %>% 
            formatPercentage(12:18, 2) %>% 
            formatStyle(columns = colnames(covid_data),
                        background="skyblue", fontWeight = "bold")
    })
})