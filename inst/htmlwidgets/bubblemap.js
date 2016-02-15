var prms, gjson, pnts, pth, prj;

HTMLWidgets.widget({

  name: 'bubblemap',

  type: 'output',

  initialize: function(el, width, height) {
    return {}
  },

  renderValue: function(el, params, instance) {
    instance.params = params;
    this.drawGraphic(el, params, el.offsetWidth, el.offsetHeight);
  },

  drawGraphic: function(el, params, width, height) {
    // remove existing children
    while (el.firstChild)
    el.removeChild(el.firstChild);

    prms = params;

    ///////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////
    //Basic Margin Information
    var margin = { top: params.top, right: params.right,
                   bottom: params.bottom, left: params.left };
    width  = width - margin.left - margin.right;
    height = height - margin.top - margin.bottom;

    var pointdata = HTMLWidgets.dataframeToD3(params.data);


    ///////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////
    //Create SVG and Basic Map Settings
    var svg = d3.select("#" + el.id).append("svg")
      .attr("width",  width  + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var radius = d3.scale.sqrt()
        .domain([0, params.maxdomain])
        .range( [0, params.maxrange]);

    var graticule = d3.geo.graticule();
    var formatNumber = d3.format(",.0f");
    var geojson = params.rawmapdata;
    var mapdata = params.mapdata;




    if (mapdata == "usa") {

      var projection = d3.geo.albersUsa()
                       .scale(params.mapscale)
                       .translate([width / 2, height / 2]);
      var path    = d3.geo.path().projection(projection);
      var center  = projection([0, 20]);

      if (params.graticule) {
        svg.append("path")
          .datum(graticule)
          .attr("class", "graticule")
          .attr("d", path);
      }

      svg.append("path")
         .datum(topojson.feature(geojson, geojson.objects.states))
         .attr("class", "states")
         .attr("d", path)

      svg.append("path")
      .datum(topojson.mesh(geojson,
                           geojson.objects.states,
                           function(a, b) { return a !== b; }))
      .attr("class", "boundary")
      .attr("d", path);
    }

    ///////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////
    // World Map
    if (mapdata == "world") {
      var projection = d3.geo.naturalEarth()
                       .scale(params.mapscale)
                       .translate([width / 2, height / 2]);
      var path    = d3.geo.path().projection(projection);
      var center  = projection([0, 20]);


      if (params.graticule) {
        svg.append("path")
          .datum(graticule)
          .attr("class", "graticule")
          .attr("d", path);
      }


      svg.append("path")
         .datum(topojson.feature(geojson,
                                 geojson.objects.countries))
         .attr("class", "country")
         .attr("d", path)

      svg.append("path")
        .datum(topojson.mesh(geojson,
                             geojson.objects.countries,
                             function(a, b) { return a !== b; }))
        .attr("class", "boundary")
        .attr("d", path);


      if (params.sphere) {

        svg.append("defs").append("path")
            .datum({type: "Sphere"})
            .attr("id", "sphere")
            .attr("d", path);
        svg.append("use")
            .attr("class", "stroke")
            .attr("xlink:href", "#sphere");
      }
    }


    ///////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////
    // Draw Points
    svg.append("g")
    .selectAll(".symbol")
      .data(pointdata)
        .sort(function(a, b) { return b.pointsize - a.pointsize; })
      .enter().append("circle")
    .attr("class", "symbol")
      .attr("transform",
          function(d) {return "translate(" + projection([+d[params.loncol],+d[params.latcol]]) + ")";})
      .attr("r", function(d) {return radius(+d.pointsize)})
    .append("title")
      .text(function(d) {
        if (params.sizecol) {
          return d[params.namecol] + "\n" + params.sizecol + " " + formatNumber(d.pointsize);
        } else {
          return d[params.namecol];
        }
      });

    //.attr("r", radius(100)  );

    ///////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////
    // add a legend if legend is true and a sizecolumn exists
    if (!(params.legend == null) && !(params.sizecol == null)) {
     var legend = svg.append("g")
                     .attr("class", "legend")
                     .attr("transform", "translate(" + (width - 50) + "," + (height - 20) + ")")
                .selectAll("g")
                .data([params.maxdomain / 5, params.maxdomain / 2, params.maxdomain])
                .enter().append("g");

        legend.append("circle")
            .attr("cy", function(d) { return -radius(d); })
            .attr("r", radius);

        legend.append("text")
            .attr("y", function(d) { return -2 * radius(d); })
            .attr("dy", "1.3em")
            .text(d3.format(".1s"));
    };



    prms = params;
    pnts = pointdata;
    pth = path;
    prj = projection;
  },

  resize: function(el, width, height, instance) {
      if (instance.params)
      this.drawGraphic(el, instance.params, width, height);
  }
});


/*    // Basic Map Setup Goes Here
  	var samples = {{geojson|string|safe}};
    var geojson = {{map_data|string|safe}};
    var radius = d3.scale.sqrt()
        .domain([0, 1e{{scale_exp}}])
        .range([0, 10]);
    var projection = d3.geo.albers()
		{% if center %}
			 .center( {{center}} )
		{% endif %}
      .scale(800);
    var path = d3.geo.path()
      .projection(projection);
	var center = projection([ 0, 20]);
    var svg = d3.select("#map")
      .append("svg")
      .append("g")
      .attr("width", width)
      .attr("height", height);
    svg.append("path")
          .attr("class", "states")
          .datum(topojson.feature(geojson, geojson.objects.states))
          .attr("d", path);
     svg.selectAll(".symbol")
            .data(samples.features)
            .enter().append("path")
              .attr("class", "symbol")
     .attr("d", path.pointRadius(function(d) { return radius(1000) }));
	//Selection Shorthands go here
    var map  = svg.append("path").attr("class", "state");
	var points = svg.selectAll(".symbol")
	          .data(samples.features);

    // Functions Go Here
	d3.selectAll("select").on("change", function () {updateSize(this.value) });

    //this is where the update size code goes
    function updateSize(value) {
        // join new data with old elements
        var symbol = svg.selectAll(".symbol")
              .data(samples.features);
        // UPDATE
        symbol.attr("d", path.pointRadius(function(d) { return radius(d.properties[value]); }))
*/

/*
	{% if title %}
		 <h2> {{ title }} </h2>
	{% else %}
		<h2> quickD3map</h2>
		<h4> default behavior is pan and zoom</h4>
	{% endif %}

	{% if columns%}
		 <p>Scale by colum values:
		 <select id="select" >
			 {% for col in columns %}
		        <option value="{{col}}"> {{col}} </option>
		     {% endfor %}
		 </select>
		 if the circles are too small or big try changing the scale_exp value.
		 </p>
	{% endif %}

	{% block body%}
		 <div id="map"></div>
	{% endblock %}*/

