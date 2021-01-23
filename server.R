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
    output$covidPlot <- renderPlot({
        ggplot(covid_data %>% 
                   filter(.,State==input$stateSel), 
               aes(x=`Submission Date`, 
                   y=`New Cases`)) + 
            geom_line(aes(color=State)) +
            geom_smooth(method='loess', formula='y~x', se=F) +
            ggtitle(paste(input$colSel,"Over Time for",input$stateSel)) +
            theme(plot.title=element_text(hjust=0.5))
    })
    
    # datatable ####
    output$table <- renderDataTable({
        datatable(covid_data %>% 
            filter(.,State==input$stateSel) %>% 
            arrange(.,desc(`Submission Date`)),rownames = FALSE) %>%
           # formatCurrency(new_case, currency='', interval=3, mark=",") %>% 
            formatStyle(columns = colnames(covid_data),
                        background="skyblue", fontWeight = "bold")
    })
})