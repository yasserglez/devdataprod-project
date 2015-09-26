library("shiny")
library("shinydashboard")

plots_tab <- tabItem(tabName = "plots", fluidRow(
    box(title = "Sleep Duration", width = 12, collapsible = TRUE, status = "primary", plotOutput("duration_plot"))
))

docs_tab <- tabItem(tabName = "docs", fluidRow(
    box(title = "Documentation", width = 12, status = "primary")
))

dashboardPage(
    dashboardHeader(title = "Track Your Sleep!"),
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
