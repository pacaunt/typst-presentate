#import "../../../src/export.typ": * 
#set page(paper: "presentation-16-9")
#set text(size: 40pt)
// start-example 
#slide[
  Pros and Cons of Banana
  #grid(columns: (1fr,) * 2)[
    *Pros* #show: pause 
    + energy 
    #show: pause 
    + tasty
  ][ // [] is the dummy content.
    #uncover(1, [], update-pause: true)
    *Cons* #show: pause
    + high sugar 
    #show: pause
    + smelly
  ]
]