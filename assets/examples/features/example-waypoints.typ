#import "../../../src/export.typ": *

#set page(paper: "presentation-16-9")
#set text(size: 25pt)

#slide[
  = Combination
  Five distinguishable balls can be chosen into a group of three balls in how many number of ways?
  #grid(columns: (1fr, 1fr), gutter: 1em)[
    #pause
    #waypoint(<solution>)
    $
      C_(5, 3) pause & = 5!/(3! (5 - 3)!) \
                     & = pause 10 "ways"
    $
  ][
    // #meanwhile
    #uncover(<solution>)[It's 5 choose 3.]

  ]
]
