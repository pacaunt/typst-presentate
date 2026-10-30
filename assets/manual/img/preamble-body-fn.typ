#import "../../../src/export.typ": *
#set page(paper: "presentation-16-9")
#set text(size: 40pt)
// start-example
#slide(
  preamble: it => {
    set page(fill: luma(30))
    set text(fill: white)
    it
  },
  body-fn: it => {
    block(stroke: .5pt + white, it, width: 100%, height: 1fr, inset: 1em)
  },
)[
  = Styled Slide
  #pause
  - `preamble` applies once. #pause
  - `body-fn` applies to all subslides.
]
