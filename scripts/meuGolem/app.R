# Launch the ShinyApp (Do not remove this comment)
# To deploy, run: rsconnect::deployApp()
# Or use the blue button on top of this file

library(shinyjs)
library(devtools)

devtools::load_all(".")
options( "golem.app.prod" = TRUE)
auth0::shinyAppAuth0(app_ui, app_server)
