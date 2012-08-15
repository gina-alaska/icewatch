class @IceGraph
  init: (div)->
    @div = $(div);
    @datasource = @div.attr("data-url");
    
    $.getJSON @datasource, (data) =>
      @data = @transformData(data);
      console.log(@data)
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
          .datum(@data)
          .transition().duration(500)
          .call(chart);
        
        nv.utils.windowResize(chart.update);
        
        chart;
      
  #end init

  transformData: (rawData) ->
    data = [];
    console.log(rawData)
    $.each rawData, (index,cruise) ->
      return if cruise.observations.length == 0
      
      seriesItems = [];
      $.each cruise.observations, (i, obs) ->
        x = Date.parse(obs.obs_datetime);
        y = obs.ice.total_concentration;
        
        if x? and y? 
          seriesItems.push [x,y]
    
      
      data.push
        key: cruise.ship
        values: seriesItems
      #  color: "#ff7f0e"
      # data.push
      #   key: cruise.ship + "1"
      #   values: seriesItems
      #   color: '#2ca02c'
        
    console.log(data)
    data;
    