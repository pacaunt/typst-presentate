#import "../../src/export.typ": * 

#show: init

#set page(paper: "presentation-16-9") 
#set text(size: 25pt)

#slide[
  = Welcome

  Hello, this is presentate. 
  #pause 

  Another presentation framework.
] 

#set page(fill: yellow)

#slide[
  = Everything is easy and configurable..

  #set align(horizon) 
  #show: block.with(height: 1fr)

  #grid(columns: (1fr,) * 2, rows: 1fr, fill: white, gutter: 2em, inset: 1em)[
    This is the first column.
    #pause 
  ][
    This is the second column.
  ]
  
]

