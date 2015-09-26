library("shiny")
library("readr")
library("dplyr")
library("lubridate")
library("ggplot2")

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
           duration = duration / 60 / 60) %>% # convert to hours
    # Add NA entries for the days without data.
    right_join(data.frame(date = seq(min_date, max_date, by = "1 day")), by = "date")


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
            geom_line()
    })
})
