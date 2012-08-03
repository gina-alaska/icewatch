class @IceGraph
  init: ->
    #TODO: 
    #IceBox should fetch the data and pass it to here, so we only have to fetch the data once.
    @fetchData();
      
    #Set up on resize events to redraw the graph
    
    
        
  fetchData: () ->
    url = "/observations.json"
    $.getJSON url, (data) =>
      @data = data;
      @updateGraph();
  
  updateGraph: ->
    w = $("#graph").width();
    h = $("#graph").height();
    w = 800;
    h = 300;
    series = @transformData()

    graph = new Rickshaw.Graph(
      element: document.querySelector("#graph"),
      width: w,
      height: h,
      renderer: 'area',
      unstack: true,
      offset: 'zero',
      interpolation: 'step-after'
      onData: (d) =>
        @transformData(d)
      series: series
    );
    
    x_axis = new Rickshaw.Graph.Axis.Time(
      graph: graph
    );
    y_axis = new Rickshaw.Graph.Axis.Y(
      graph: graph,
      orientation: 'left',
      tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
      element: document.querySelector('#y_axis')
    );
    
    legend = new Rickshaw.Graph.Legend(
      element: document.querySelector('#legend'),
      graph: graph
    );
    # 
    # slider =new Rickshaw.Graph.RangeSlider(
    #   element: $("#slider"),
    #   graph: graph
    # );
    graph.render();
    
  transformData: ->
    palette = new Rickshaw.Color.Palette(
      scheme: 'cool'
    );
    data = [];
    seriesItems = {};
    maps = {
      total_concentration: "Total Concentration"
      ppartial_concentration: "Primary Concentration"
      spartial_concentration: "Secondary Concentration"
      tpartial_concentration: "Tertiary Concentration"
    };

    console.log(@data);

    $.each(@data, (index,item) ->
      
        seriesItems['tpartial_concentration'] = seriesItems['tpartial_concentration'] || []
        seriesItems['tpartial_concentration'].push({
          x: Date.parse(item.obs_datetime) / 1000
          y: item.ice_observations[2].partial_concentration || 0
        });
        seriesItems['spartial_concentration'] = seriesItems['spartial_concentration'] || []
        seriesItems['spartial_concentration'].push({
          x: Date.parse(item.obs_datetime) / 1000
          y: item.ice_observations[1].partial_concentration || 0
        });
        seriesItems['ppartial_concentration'] = seriesItems['ppartial_concentration'] || []
        seriesItems['ppartial_concentration'].push({
          x: Date.parse(item.obs_datetime) / 1000
          y: item.ice_observations[0].partial_concentration || 0
        });
        seriesItems['total_concentration'] = seriesItems['total_concentration'] || [];
        seriesItems['total_concentration'].push({
          x: Date.parse(item.obs_datetime) / 1000
          y: item.ice.total_concentration || 0
        });
    );
    console.log(seriesItems);
    
    $.each(seriesItems, (index, s) -> 
      data.push(
        name: maps[index] || "Unknown",
        data: s
        color: palette.color()
      )
    );
    data;
    