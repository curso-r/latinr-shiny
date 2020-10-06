#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    bs4Dash::dashboardPage(
      bs4Dash::dashboardHeader(
        rightUi = auth0::logoutButton()
      ),
      bs4Dash::dashboardSidebar(
        title = "Titulo",

        bs4Dash::sidebarMenu(
          bs4Dash::menuItem(
            "Dashboard",
            tabName = "dashboard"
          ),
          bs4Dash::menuItem(
            "Mapa",
            tabName = "mapa"
          )
        )
      ),
      bs4Dash::dashboardBody(
        bs4Dash::tabItems(
          bs4Dash::tabItem(
            tabName = "dashboard",
            esquisse::esquisserUI(
              "esquisse",
              header = FALSE,
              choose_data = FALSE
            )
          ),
          bs4Dash::tabItem(
            tabName = "mapa",
            mod_mapa_ui("mapa_ui_1")
          )
        )

      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){

  add_resource_path(
    'www', app_sys('app/www')
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'meuGolem'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}

