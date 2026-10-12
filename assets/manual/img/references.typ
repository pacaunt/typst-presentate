#import "../../../src/export.typ": * 
#set page(paper: "presentation-16-9")
#set text(size: 40pt)
// start-example 
#set math.equation(numbering: "(1)")
#set heading(numbering: "1.1 ")
#slide[
  = Referencable Elements<reference>
  #figure(
    rect(fill: yellow, width: 2cm, height: 1cm), 
    caption: [A yellow rectangle.]
  )<yellow-rect>
  #pause
  $ E = m c^2 $<eistein>
  #pause
  From @yellow-rect, there is no relationship with @eistein in @reference.
]