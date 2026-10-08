#import "../../../src/export.typ": *

#set page(paper: "presentation-16-9")
#set text(size: 25pt)
// start-example
#slide[
  = Combination
  Derive an equation of displacement vs time for a free-falling object from height $h$ at initial velocity of $u$.
  #pause #marker(<solution>)

  *Solution.* #pause
  $
    v = u - g t quad "and" quad s = ((u + v)/2) t \
    #pause
    s = ((u + (u - g t))/2) t quad pause => quad s = u t - 1/2 g t^2
    #marker(<end>)
  $
  #jump(<solution>)
  #uncover(from: (to:<solution>, rel: 1), to: <end>)[_Comments:_]
  #only(auto, update: true)[From definitions.]
  #only(auto, update: true)[Distribute the terms.]
  #only(<end>)[That's it.]
]
