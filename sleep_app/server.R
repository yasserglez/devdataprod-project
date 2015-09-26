library("shiny")
library("readr")
library("dplyr")
library("lubridate")
library("ggplot2")
library("scales")

# Load and tidy the data exported from https://www.mysleepbot.com:

sleep_data <- read_delim("SleepBot.csv", ",",  quote = "'", col_types = "cc_c_") %>%
    mutate(# SleepBot' Date is when the entry was created, but I want the clock-in date.
        sleep_time = mdy_hm(paste(Date, `Sleep Time`)) - days(1),
        duration = as.interval(hm(Duration), sleep_time)) %>%
    # Combine non-contiguous entries.
    group_by(as.Date(sleep_time)) %>%
    summarize(sleep_time = min(sleep_time),
              duration = sum(duration)) %>%
    select(sleep_time, duration)


# Precompute information used in the plots:

min_date <- min(as.Date(sleep_data$sleep_time))
max_date <- max(as.Date(sleep_data$sleep_time))

sleep_data <- sleep_data %>%
    mutate(date = as.Date(sleep_time), # just the date
           wake_time = as.POSIXct(format(sleep_time + duration, "%H:%M"), format = "%H:%M", tz = "UTC"),
           sleep_time = as.POSIXct(format(sleep_time, "%H:%M"), format = "%H:%M", tz = "UTC"),
           duration = duration / 60 / 60) # convert to hours


shinyServer(function(input, output, session) {
    updateDateRangeInput(session, "dates",
                         min = min_date, max = max_date,
                         start = min_date, end = max_date)

    plot_data <- reactive({
        sleep_data %>%
            filter(date >= input$dates[1], date <= input$dates[2])
    })

    output$duration_plot <- renderPlot({
        ggplot(plot_data(), aes(x = date, y = duration)) +
            geom_point(colour = "#1e282b", size = 3, shape = 1) +
            geom_smooth(method = "loess", colour = "#367fa9") +
            labs(x = "Date", y = "Duration (hours)") +
            theme(axis.title.x = element_text(vjust = -0.25),
                  axis.title.y = element_text(vjust = 1))
    })

    output$sleep_plot <- renderPlot({
        ggplot(plot_data(), aes(x = sleep_time)) +
            geom_histogram(colour = "#367fa9", fill = "#367fa9",
                           binwidth = 60 * 60) +
            scale_x_datetime(breaks = date_breaks("1 hours"),
                             labels = date_format("%l%p", tz = "UTC")) +
            labs(x = "Hour", y = "Count") +
            theme(axis.title.x = element_text(vjust = -0.25))
    })

    output$wake_plot <- renderPlot({
        ggplot(plot_data(), aes(x = wake_time)) +
            geom_histogram(colour = "#367fa9", fill = "#367fa9",
                           binwidth = 60 * 60) +
            scale_x_datetime(breaks = date_breaks("1 hours"),
                             labels = date_format("%l%p", tz = "UTC")) +
            labs(x = "Hour", y = "Count") +
            theme(axis.title.x = element_text(vjust = -0.25))
    })
})
