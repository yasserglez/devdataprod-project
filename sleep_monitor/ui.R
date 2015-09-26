library("shiny")
library("shinydashboard")

dashboardPage(
    dashboardHeader(title = "Sleep Monitor"),
    dashboardSidebar(
        sidebarMenu(
            dateRangeInput("dates", label = "Date Range:", startview = "year"),
            menuItem("Source Code", icon = icon("github"),
                     href = "https://github.com/yasserglez/devdataprod-project")
        )
    ),
    dashboardBody(
        fluidRow(
            box(title = "Welcome", width = 12, collapsible = TRUE,
                HTML(paste('<p>This <a href="http://shiny.rstudio.com/">Shiny</a> app',
                           'allows you to study your sleeping habits.')),
                p(paste("The first plot shows each day's sleep duration, along with",
                        "a regression line and a 95% confidence interval. The second",
                        "and third plots are histograms of the sleep and wake time.",
                        "You can use the date picker widgets located in the sidebar",
                        "to select different date ranges.")),
                HTML(paste('The sample data are my own records, collected over the past year using',
                           '<a href="https://mysleepbot.com/">SleepBot</a>.')))
        ),
        fluidRow(box(title = "Sleep Duration", width = 12, plotOutput("duration_plot"))),
        fluidRow(
            box(title = "Sleep Time Histogram", width = 6, plotOutput("sleep_plot")),
            box(title = "Wake Time Histogram", width = 6, plotOutput("wake_plot"))
        )
    )
)
