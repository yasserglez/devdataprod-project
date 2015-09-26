library("shiny")
library("shinydashboard")

plots_tab <- tabItem(tabName = "plots",
    fluidRow(box(title = "Sleep Duration", width = 12, plotOutput("duration_plot"))),
    fluidRow(
        box(title = "Sleep Time Histogram", width = 6, plotOutput("sleep_plot")),
        box(title = "Wake Time Histogram", width = 6, plotOutput("wake_plot"))
    )
)

docs_tab <- tabItem(tabName = "docs", fluidRow(
    box(title = "Documentation", width = 12)
))

dashboardPage(
    dashboardHeader(title = "Sleep Tracking"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Plots", tabName = "plots", icon = icon("area-chart")),
            dateRangeInput("dates", label = "Date Range:", startview = "year"),
            menuItem("Documentation", tabName = "docs", icon = icon("book")),
            menuItem("Source Code", icon = icon("github"),
                     href = "https://github.com/yasserglez/devdataprod-project")
        )
    ),
    dashboardBody(tabItems(plots_tab, docs_tab))
)
