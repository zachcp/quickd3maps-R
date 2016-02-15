## quickd3map

simple mapping with d3 using htmltools. this is the stub but will expand
this to allow coloring, sorting  and selecting.

```r
library(quickd3map)

cities <- read.csv("data-raw/topcities.csv")
bubblemap(mapdata = "usa",
           data=cities,
           latcol="Latitude",
           loncol="Longitude",
           mapscale = 800,
           size = "Area",
           maxdomain = 1e3,
           maxrange = 20)

```
#cities

