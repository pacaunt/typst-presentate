#import "@local/presentate:0.2.3": *

#set page(paper: "presentation-16-9")
#set text(size: 25pt)
#set raw(lang: "typc")
#let grayed = text.with(fill: gray.transparentize(50%))

#let pause = pause.with(hider: grayed)
#let uncover = uncover.with(hider: grayed)

#slide[
  = Relative `auto`, `none`, and `(rel: int)` Indices

  This is present first

  #show: pause

  #only(auto)[This came later, but *not* preserve space.]
  _This will shift. $->$_

  #uncover(none)[This comes with current `pause`.]

  #pause[This is the second `pause`.]

  #pause[This is the third `pause`]

  #uncover((rel: -1), [But This come before.])
]
