library("shiny")
library("shinydashboard")

dashboardPage(
    dashboardHeader(title = "Track Your Sleep!"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Plots", tabName = "plots", icon = icon("area-chart")),
            dateRangeInput("dateRange", label = "Date Range:", startview = "year"),
            menuItem("Documentation", tabName = "docs", icon = icon("book")),
            menuItem("Source Code", icon = icon("github"),
                     href = "https://github.com/yasserglez/devdataprod-project")
        )
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName = "plots",
                h2("Plots")
            ),

            tabItem(tabName = "docs",
                h2("Documentation")
            )
        )
    )
)
