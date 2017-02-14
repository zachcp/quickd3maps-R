#' add_colors_categorical
#'
#' @importFrom  leaflet colorFactor
#'
#' @export
add_colors_categorical <- function(bmap, colorcol, palette= NULL) {

  # set default palette
  if (is.null(palette)) palette <- "RdYlBu"

  data      <- bmap$x$data
  newcolors <- colorFactor(palette=palette, domain = data[[colorcol]])

  bmap$x$data$colors <- newcolors(data[[colorcol]])
  bmap
}


#' add_colors_quintile
#'
#' @importFrom  leaflet colorQuantile
#'
#' @export
add_colors_quintile <- function(bmap, colorcol, palette= NULL) {
   # set default palette
  if (is.null(palette))  palette <- "RdYlBu"

  data      <- bmap$x$data
  newcolors <- colorQuantile(palette=palette, domain = data[[colorcol]])

  bmap$x$data$colors <- newcolors(data[[colorcol]])
  bmap
}


#' add_colors_continuous
#'
#' @importFrom  leaflet colorNumeric
#'
#' @export
add_colors_continuous <- function(bmap, colorcol, palette= NULL) {
  # set darault palette
  if (is.null(palette))  palette <- "RdYlBu"

  data      <- bmap$x$data
  newcolors <- colorNumeric(palette=palette, domain = data[[colorcol]])

  bmap$x$data$colors <- newcolors(data[[colorcol]])
  bmap
}

#' add_colors_binned
#'
#' @importFrom  leaflet colorBin
#'
#' @export
add_colors_binned <- function(bmap, colorcol, palette= NULL) {
  # set darault palette
  if (is.null(palette))  palette <- "RdYlBu"

  data      <- bmap$x$data
  newcolors <- colorBin(palette=palette, domain = data[[colorcol]])

  bmap$x$data$colors <- newcolors(data[[colorcol]])
  bmap
}
