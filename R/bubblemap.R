#' Plot Points on a Map using D3.js
#'
#' D3.js provides the ability to generate beautiful maps using many projections.
#'
#' @import htmlwidgets
#' @param message message
#' @export
bubblemap <- function(#pointdata
                       data,
                       latcol   = NULL,
                       loncol   = NULL,
                       colorcol = NULL,
                       namecol  = NULL,
                       sizecol  = NULL,
                       size     = 5,
                       defaultcolor="#D3D3D3",
                       #mapddata
                       mapdata = "usa",
                       maxdomain = 1000,
                       maxrange  = 10,
                       mapscale  = 1280,
                       legend    = TRUE,
                       graticule = FALSE,
                       sphere    = FALSE,
                       #general params
                       top=20,
                       right=40,
                       bottom=30,
                       left=50,
                       width = NULL,
                       height = NULL) {

  # Choose mapdata
  if (mapdata == "usa") {
    usamap       <- system.file("mapdata", "us_states.json", package = "quickd3map")
    rawmapdata   <- jsonlite::fromJSON(usamap,simplifyVector = FALSE, flatten = FALSE)
  } else if (mapdata == "world") {
    worldmap     <- system.file("mapdata", "world-110m.json", package = "quickd3map")
    rawmapdata   <- jsonlite::fromJSON(worldmap,simplifyVector = FALSE, flatten = FALSE)
  } else if (mapdata == "nyc") {
    nycmap     <- system.file("mapdata", "nyc.json", package = "quickd3map")
    rawmapdata   <- jsonlite::fromJSON(nycmap,simplifyVector = FALSE, flatten = FALSE)
  }

  # check size
  if (is.null(sizecol)) {
    data$pointsize <- size
  } else {
    data$pointsize <- data[[sizecol]]
  }

  # set default color values
  data$colors <- defaultcolor



  params = list(
    data       = data,
    mapdata    = mapdata,
    rawmapdata = rawmapdata,
    colorcol   = colorcol,
    latcol     = latcol,
    loncol     = loncol,
    namecol    = namecol,
    sizecol    = sizecol,
    top        = top,
    bottom     = bottom,
    left       = left,
    right      = right,
    maxdomain  = maxdomain,
    maxrange   = maxrange,
    mapscale   = mapscale,
    legend     = legend,
    graticule  = graticule,
    sphere     = sphere
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'bubblemap',
    x = params,
    width = width,
    height = height,
    package = 'quickd3map'
  )
}

#' Widget output function for use in Shiny
#'
#' @export
bubblemapOutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'bubblemap', width, height, package = 'quickd3map')
}

#' Widget render function for use in Shiny
#'
#' @export
renderBubblemap <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, bubblemapOutput, env, quoted = TRUE)
}


