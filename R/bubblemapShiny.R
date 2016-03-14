#' Call Bubblemap with Shiny for interactivity
#'
bubblemapShiny <- function(df) {

  ui = shinyUI(
    fluidPage(
      fluidRow(
        column(3,
               selectInput("mapdata", "Map Data", c("USA" = "usa", "World" = "world")),
               selectInput("latcol", "Latitude Column", names(df)),
               selectInput("loncol", "Longitude Column", names(df)),
               selectInput("namecol", "Name Column", names(df)),
               selectInput("sizecol", "Size Column", names(df)),
               selectInput("colorcol",  "Color Column", names(df)),
               sliderInput("maxdomain", "Max Domain", min = 1, max = 1000000, step = 100, value=1000),
               sliderInput("maxrange",  "Max Range",   min = 1, max = 100, step = 10, value=20 ),
               sliderInput("mapscale",  "Map Scale",   min = 1, max = 10000, step = 10, value=1280)
        ),
        column(9, bubblemapOutput('bubblemap'))
      )))

  server = function(input, output) {
    output$bubblemap <- renderBubblemap(
      bubblemap(uscities,
                mapdata    = input$mapdata,
                latcol     = input$latcol,
                loncol     = input$loncol,
                namecol    = input$namecol,
                sizecol    = input$sizecol,
                colorcol   = input$colorcol,
                maxdomain  = input$maxdomain,
                maxrange   = input$maxrange,
                mapscale   = input$mapscale
    ))}
  shinyApp(ui = ui, server = server)
}


#' Call Bubblemap with Shiny Gadgets for interactivity
#'
#' @import miniUI
#' @import shiny
bubblemapGadget <- function(df, latcol, loncol) {

  ui = miniPage(
    gadgetTitleBar("Make A Static Map with D3"),
    fillRow(
      flex = c(1,2),
      fillCol(selectInput("mapdata", "Map Data", c("USA" = "usa", "World" = "world")),
              selectInput("latcol", "Latitude Column", names(df)),
              selectInput("loncol", "Longitude Column", names(df)),
              selectInput("namecol", "Name Column", names(df)),
              selectInput("sizecol", "Size Column", names(df)),
              selectInput("colorcol",  "Color Column", names(df)),
              sliderInput("maxdomain", "Max Domain", min = 1, max = 1000000, step = 100, value=1000),
              sliderInput("maxrange",  "Max Range",   min = 1, max = 100, step = 10, value=20 ),
              sliderInput("mapscale",  "Map Scale",   min = 1, max = 10000, step = 10, value=1280)
              ),

      bubblemapOutput('bubblemap')))

  server = function(input, output) {
    output$bubblemap <- renderBubblemap(
      bubblemap(uscities,
                mapdata    = input$mapdata,
                latcol     = input$latcol,
                loncol     = input$loncol,
                namecol    = input$namecol,
                sizecol    = input$sizecol,
                colorcol   = input$colorcol,
                maxdomain  = input$maxdomain,
                maxrange   = input$maxrange,
                mapscale   = input$mapscale))

    # Handle the Done button being pressed.
    observeEvent(input$done, { stopApp() })
  }

  runGadget(ui, server,viewer = browserViewer())
}

#library(shiny)
#library(shiny)
#library(miniUI)
#library(quickd3map)
#bubblemapShiny(uscities)
#bubblemapGadget(uscities)
