## quickd3map

simple mapping with d3 using htmltools. this is the stub but will expand
this to allow coloring, sorting  and selecting. see the [main page](http://zachcp.github.io/quickd3map/)

```r
library(quickd3map)

bubblemap(mapdata = "usa",
           data=cities,
           latcol="Latitude",
           loncol="Longitude",
           mapscale = 800,
           size = "Area",
           maxdomain = 1e3,
           maxrange = 20)

```

## News

- Version `0.1` released
