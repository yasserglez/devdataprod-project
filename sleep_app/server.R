library("shiny")
library("readr")
library("dplyr")
library("lubridate")
library("ggplot2")

# Load and tidy the data exported from https://www.mysleepbot.com
sleep_data <- read_delim("SleepBot.csv", ",",  quote = "'", col_types = "cc_c_") %>%
    mutate(# SleepBot' Date is when the entry was created, but I want the clock-in date.
        sleep_time = mdy_hm(paste(Date, `Sleep Time`)) - days(1),
        duration = as.interval(hm(Duration), sleep_time)) %>%
    # Combine non-contiguous entries.
    group_by(as.Date(sleep_time)) %>%
    summarize(sleep_time = min(sleep_time),
              duration = sum(duration)) %>%
    select(sleep_time, duration)

# Precompute information used in the plots
sleep_data <- sleep_data %>%
    mutate(date = as.Date(sleep_time))

shinyServer(function(input, output, session) {
    updateDateRangeInput(session, "dateRange",
                         min = min(sleep_data$date), max = max(sleep_data$date),
                         start = min(sleep_data$date), end = max(sleep_data$date))
})
