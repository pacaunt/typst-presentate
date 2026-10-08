#import "../../../src/export.typ": * 
#set page(paper: "presentation-16-9")
#set text(size: 40pt)
// start-example 
#slide[
  Pros and Cons of Banana
  #grid(columns: (1fr,) * 2)[
    *Pros* #pause 
    + energy 
    #pause 
    + tasty
  ][ 
    #meanwhile
    *Cons* #pause
    + high sugar 
    #pause
    + smelly
  ]
]