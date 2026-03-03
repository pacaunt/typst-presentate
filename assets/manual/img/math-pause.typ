#import "../../../src/export.typ": * 
#set page(paper: "presentation-16-9")
#set text(size: 40pt)
// start-example 
#slide[
  $ 
    (x + y)^2 pause(&= (x + y)(x + y)) \ 
              pause(&= x^2 + 2x y + y^2)
  $ 
]