#import "../../src/export.typ": * 

#set page(paper: "presentation-16-9") 
#set text(size: 25pt)
#set heading(numbering: "1 ")

#show heading.where(level: 1): it => {
  slide(context {it})
}
// CHORES: Check the compatibility of themes...
= Topic 

#slide[
  == Welcome
  #show: body => element.applier(body, it => context { it } )
  Hello, this is presentate. 
  #pause 

  Another presentation framework.
] 

#set page(fill: yellow)

#slide[
  == Everything is easy and configurable..

  #set align(horizon) 
  #show: block.with(height: 1fr)

  #grid(columns: (1fr,) * 2, rows: 1fr, fill: white, gutter: 2em, inset: 1em)[
    This is the first column.
    #pause 
  ][
    This is the second column.
  ]
  
]

