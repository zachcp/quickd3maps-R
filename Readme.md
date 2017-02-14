## quickd3map

simple mapping with d3 using htmltools. this is the stub but will expand
this to allow coloring, sorting  and selecting. see the [main page](http://zachcp.github.io/quickd3maps-R/)

```r
library(quickd3map)

bmap <- bubblemap(mapdata = "usa",
           data=uscities,
           latcol="Latitude",
           loncol="Longitude",
           mapscale = 800,
           sizecol = "Area",
           maxdomain = 1e3,
           maxrange = 20)

add_colors(bmap,  colorcol="State")
```

## News

- Version `0.1` released
