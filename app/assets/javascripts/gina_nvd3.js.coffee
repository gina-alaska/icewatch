d3.scale.icewatch = ->
  d3.scale.ordinal().range(d3_icewatch);

d3.scale.icecategory = ->
  d3.scale.ordinal().range(d3_icewatch_category);


d3_icewatch = [
  "#F2F2F2", #Frazil
  "#F2F2F2", #Grease
  "#F2F2F2", #Shuga
  "#D9D9D9", #Nilas
  "#BFBFBF", #Pancakes
  "#A6A6A6", #Young Grey (10-15cm)
  "#808080", #Young Grey (15-30cm)
  "#D0E2E1", #First Year (30-70cm)
  "#BFD7D3", #First Year (70-120cm)
  "#77ADA3", #First Year (>=120cm)
  "#8DD3E3", #Second Year
  "#50BBD4", #Multi Year
  "#5F80A9", #Brash
  "#92A9C4", #Fast
  "#244062"  #Water
]

d3_icewatch_category = [
  "#D9D9D9", #New
  "#BFD7D3", #First Year
  "#50BBD4", #Old
  "#92A9C4"  #Other
];

@d3_icewatch_cruise = [
	#  "#DCF900",
	#  "#FF8900",
	# "#ABBC2E",
	#  "#C07D2F",
	# "#90A300",
	# "#EDFE6A",
	#  "#A75A00",
	#  "#FFBA6B"
	"#1B9E77",
	"#D95F02",
	"#7570B3",
	"#E7298A",
	"#66A61E",
	"#E6AB02",
	"#A6761D",
	"#666666"
];

$(document).ready ->
  $("#charts a[data-toggle=pill]").on 'shown', -> 
    for graph in nv.graphs 
      graph.update()