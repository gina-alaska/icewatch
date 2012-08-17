class @IceGraph
  init: (div)->
    @div = $(div);
    @datasource = @div.attr("data-url");

    $.getJSON @datasource, (data) =>
      @data = data
      console.log @data
      @createCharts()
  #end init

  transformData: =>
    data = [];
    for cruise in @data
      return if cruise.observations.length == 0
      
      seriesItems = [];
      for obs in cruise.observations
        x = Date.parse(obs.obs_datetime);
        y = obs.ice.total_concentration;
        
        if x? and y? 
          seriesItems.push [x,y]
      
      data.push
        key: cruise.ship
        values: seriesItems

    data;
  #end transformData
  
  createCharts: =>
    nv.addGraph => 
      chart = nv.models.lineChart();
      chart = chart.x (d) ->
        d[0]
      chart = chart.y (d) ->
        d[1]
        
      chart.xAxis.axisLabel('Date/Time').tickFormat (d) -> 
        return d3.time.format('%x')(new Date(d))
      
      chart.yAxis.axisLabel('Total Concentration').tickFormat(d3.format(',f'));
      chart.forceY([0,10])
      
      d3.select('#chart svg')
        .datum(@transformData)
        .transition().duration(500)
        .call(chart);
      
      nv.utils.windowResize(chart.update);
      chart
  #end createChart