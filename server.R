shinyServer(function(input, output) {

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
            geom_line(aes(color=State)) +
            get_axis(input$colSel) + # Format axis appropriately
            ggtitle(paste(input$colSel,"Over Time for",trimws(input$stateSel))) +
            theme_classic() +
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