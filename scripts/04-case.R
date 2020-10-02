library(tidyverse)
library(shiny)
library(shinydashboard)
library(leaflet)
library(reactable)
library(plotly)
library(shinyjs)

# da_covid <- readxl::read_excel(
#   "~/Downloads/HIST_PAINEL_COVIDBR_28set2020.xlsx",
#   col_types = "text"
# )
# da_covid %>% write_rds("scripts_de_aula/da_covid.rds", compress = "xz")

da_covid <- read_rds("da_covid.rds")


## install.packages("geobr")
# shape_estados <- geobr::read_state()
# write_rds(shape_estados, "scripts_de_aula/shape_estados.rds")
shape_estados <- read_rds("shape_estados.rds")
ufs <- unique(geobr::grid_state_correspondence_table$code_state)

## Para instalar o pacote {abjData}, rode
## remotes::install_github("abjur/abjData")
aux_latlon <- abjData::cadmun %>%
  transmute(
    codmun = as.character(MUNCOD),
    lat, lon
  )


ui <- dashboardPage(
  dashboardHeader(title = "Covid"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Análises", tabName = "analises")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        "analises",
        fluidRow(
          box(
            width = 12,
            collapsed = TRUE,
            collapsible = TRUE,
            selectInput(
              "estados",
              "Estados",
              ufs,
              ufs,
              multiple = TRUE
            ),
            auth0::logoutButton("Deslogar")
          )
        ),
        fluidRow(
          box(plotlyOutput("acumulado")),
          box(reactableOutput("contagens"))
        ),
        fluidRow(
          box(leafletOutput("shapes")),
          box(leafletOutput("pontos"))
        )
      )
    )
  )
)

server <- function(input, output, session) {


  base_plotly <- reactive({
    da_covid %>%
      filter(
        estado %in% input$estados,
        is.na(municipio)
      ) %>%
      mutate(data = as.Date(as.numeric(data), origin = "1900-01-01")) %>%
      group_by(data) %>%
      summarise(
        casos = sum(as.numeric(casosAcumulado)),
        obitos = sum(as.numeric(obitosAcumulado)),
        .groups = "drop"
      )
  })

  base_tabela <- reactive({

    da_covid %>%
      filter(estado %in% input$estados) %>%
      filter(
        data == max(data),
        regiao != "Brasil",
        is.na(municipio),
        is.na(codmun)
      ) %>%
      transmute(
        regiao,
        estado,
        casos = as.numeric(casosAcumulado),
        obitos = as.numeric(obitosAcumulado)
      )

  })

  base_mapa_municipio <- reactive({
    da_covid %>%
      filter(estado %in% input$estados) %>%
      filter(
        data == max(data),
        regiao != "Brasil",
        !is.na(municipio),
        !is.na(codmun)
      ) %>%
      transmute(
        municipio,
        codmun,
        casos = as.numeric(casosAcumulado),
        obitos = as.numeric(obitosAcumulado)
      ) %>%
      inner_join(aux_latlon, "codmun") %>%
      filter(lon < 0, lat > -40)
  })




  output$acumulado <- renderPlotly({


    p <- base_plotly() %>%
      ggplot(aes(x = data, y = obitos)) +
      geom_line()

    ggplotly(p)

  })

  output$contagens <- renderReactable({
    base_tabela() %>%
      reactable(
        groupBy = "regiao",
        columns = list(
          regiao = colDef(name = "Região"),
          estado = colDef(name = "Estado"),
          casos = colDef(name = "Casos", aggregate = "sum"),
          obitos = colDef(name = "Óbitos", aggregate = "sum")
        )
      )

  })

  output$shapes <- renderLeaflet({

    # cria uma funcao que transforma números em cores
    color_fun <- colorNumeric(
      viridis::viridis(nrow(base_tabela())),
      domain = range(base_tabela()$obitos)
    )

    shape_estados %>%
      inner_join(base_tabela(), c("abbrev_state" = "estado")) %>%
      leaflet() %>%
      addTiles() %>%
      addPolygons(
        weight = .5,
        color = "black",
        opacity = .9,
        fillOpacity = .6,
        # a função que transforma números em cores é usada aqui
        fillColor = ~color_fun(obitos)
      )


  })

  output$pontos <- renderLeaflet({

    base_mapa_municipio() %>%
      mutate(label = map2(
        municipio, obitos,
        ~HTML("<strong>Município:</strong>", .x, "<br>",
              "<strong>Óbitos:</strong>", .y))
      ) %>%
      leaflet() %>%
      addTiles() %>%
      addMarkers(
        clusterOptions = markerClusterOptions(),
        label = ~label
      )

  })

}

# shiny::shinyApp(ui, server)
auth0::shinyAppAuth0(ui, server)
