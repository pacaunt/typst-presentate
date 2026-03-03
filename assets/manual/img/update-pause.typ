#import "../../../src/export.typ": * 
#set page(paper: "presentation-16-9")
#set text(size: 40pt)
// start-example 
#slide[
    Who can remember? 
  #pause[It will be shown once.] // first pause 
  + #uncover(none)[Bird] 
  + #uncover(auto)[Ant]
  + #uncover((rel: 1), update-pause: true)[Bees] // update the last animation
  + #uncover((rel: -1))[Monkey] 
  #pause[What was the third animal?] // so this shows later
]