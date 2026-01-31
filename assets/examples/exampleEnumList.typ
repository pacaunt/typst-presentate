#import "@local/presentate:0.2.3": *

#set page(paper: "presentation-16-9")
#set text(size: 25pt)

#slide[
  = List Hacks with Relative Index
  #set list(marker: uncover(from: auto, update-pause: false, [-]))

  - #show: pause;First Item.
  - #show: pause;Second Item.
  - #show: pause;Third Item.

]
