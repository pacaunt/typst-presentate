#import "../../../src/export.typ": * 
#set page(paper: "presentation-16-9")
#set text(size: 40pt)
// start-example 
#slide[
  Who can remember?  
  #pause[It will be shown once.] // first pause 
  + #uncover(none)[Bird] // with the pause 
  + #uncover(auto)[Ant] // after the pause 
  + #uncover((rel: 1))[Bees] // also after the pause
  + #uncover((rel: -1))[Monkey] // before the first pause
  #uncover(from: (rel: 2))[What was the third animal?] 
]