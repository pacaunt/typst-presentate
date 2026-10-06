#import "../../src/export.typ": * 

#set page(paper: "presentation-16-9") 
#set text(size: 25pt)

#set heading(numbering: "1.1 ")
// CHORES: Check the compatibility of themes...
#show: init 


#store.updater(s => {
  s.at(0).saved.conditions.push((
    condition: it => type(it) == content and it.func() == heading and it.depth == 1,
    apply: (s, it) => {
      s.at(0).saved.storage.last-slide-title = none
      s.at(0).saved.storage.last-topic = it
      (s, it)
    }, 
    modify-state: true, 
    contextual: true
  ))

  s.at(0).saved.conditions.push((
    condition: it => type(it) == content and it.func() == heading and it.depth == 2,
    apply: (s, it) => {
      s.at(0).saved.storage.last-slide-title = it
      (s, it)
    }, 
    modify-state: true, 
    contextual: true
  ))

  s
})

= Topic 

#slide[
  == Welcome

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

