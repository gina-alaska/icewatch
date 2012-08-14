class @IceGraph
  init: (div)->
    @div = $(div);
    @datasource = @div.attr("data-url");
    
    
    @fetchData();
      
    #Set up on resize events to redraw the graph
    
    
        
  fetchData: () ->
    $.getJSON @datasource, (data) =>
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
      renderer: 'line',
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

    graph.render();
    
  transformData: ->
    palette = new Rickshaw.Color.Palette(
      scheme: 'cool'
    );
    data = [];

    $.each @data, (index,cruise) ->
      return if cruise.observations.length == 0

      seriesItems = [];
      $.each cruise.observations, (i, obs) ->
        x = Date.parse(obs.obs_datetime) / 1000;
        y = obs.ice.total_concentration;
        
        if x? and y? 
          seriesItems.push
            x: Date.parse(obs.obs_datetime) / 1000,
            y: obs.ice.total_concentration || 0
  
      
      data.push
        name: cruise.ship
        data: seriesItems
        color: palette.color()


    data;
    