library("readr")
library("dplyr")
library("lubridate")

# https://stat.ethz.ch/pipermail/r-devel/2008-April/048914.html
srcfile <- (function() {
    attr(body(sys.function()), "srcfile")
})()$filename

# Load and tidy the data exported from https://www.mysleepbot.com

csv_file <- file.path(dirname(srcfile), "SleepBot.csv")
sleep_data <- read_delim(csv_file, ",",  quote = "'", col_types = "cc_c_") %>%
    mutate(# SleepBot' Date is when the entry was created, but I want the clock-in date.
        sleep_time = mdy_hm(paste(Date, `Sleep Time`)) - days(1),
        duration = as.interval(hm(Duration), sleep_time)) %>%
    # Combine non-contiguous entries.
    group_by(as.Date(sleep_time)) %>%
    summarize(sleep_time = min(sleep_time),
              duration = sum(duration)) %>%
    select(sleep_time, duration)

# Precompute information used in the plots

min_date <- min(as.Date(sleep_data$sleep_time))
max_date <- max(as.Date(sleep_data$sleep_time))

sleep_data <- sleep_data %>%
    mutate(date = as.Date(sleep_time), # just the date
           wake_time = as.POSIXct(format(sleep_time + duration, "%H:%M"), format = "%H:%M", tz = "UTC"),
           sleep_time = as.POSIXct(format(sleep_time, "%H:%M"), format = "%H:%M", tz = "UTC"),
           duration = duration / 60 / 60) # convert to hours
