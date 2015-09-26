library("shiny")
library("ggplot2")
library("scales")

source("sleep_data.R")

shinyServer(function(input, output, session) {
    updateDateRangeInput(session, "dates",
                         min = min_date, max = max_date,
                         start = min_date, end = max_date)

    filter_data <- reactive({
        sleep_data %>%
            filter(date >= input$dates[1], date <= input$dates[2])
    })

    output$duration_plot <- renderPlot({
        plot_data <- filter_data()
        if (nrow(plot_data) == 0) return()
        ggplot(plot_data, aes(x = date, y = duration)) +
            geom_point(colour = "#1e282b", size = 3, shape = 1) +
            geom_smooth(method = "loess", colour = "#367fa9") +
            labs(x = "Date", y = "Duration (hours)") +
            theme(axis.title.x = element_text(vjust = -0.25),
                  axis.title.y = element_text(vjust = 1))
    })

    output$sleep_plot <- renderPlot({
        plot_data <- filter_data()
        if (nrow(plot_data) == 0) return()
        ggplot(plot_data, aes(x = sleep_time)) +
            geom_histogram(colour = "#367fa9", fill = "#367fa9",
                           binwidth = 60 * 60) +
            scale_x_datetime(breaks = date_breaks("1 hours"),
                             labels = date_format("%l%p", tz = "UTC")) +
            labs(x = "Hour", y = "Count") +
            theme(axis.title.x = element_text(vjust = -0.25))
    })

    output$wake_plot <- renderPlot({
        plot_data <- filter_data()
        if (nrow(plot_data) == 0) return()
        ggplot(plot_data, aes(x = wake_time)) +
            geom_histogram(colour = "#367fa9", fill = "#367fa9",
                           binwidth = 60 * 60) +
            scale_x_datetime(breaks = date_breaks("1 hours"),
                             labels = date_format("%l%p", tz = "UTC")) +
            labs(x = "Hour", y = "Count") +
            theme(axis.title.x = element_text(vjust = -0.25))
    })
})
