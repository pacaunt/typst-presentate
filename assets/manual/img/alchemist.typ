#import "../../../src/export.typ": *
#set page(paper: "presentation-16-9")
#set text(size: 40pt)
// start-example
#import "@preview/alchemist:0.1.9" as alc

#let (single, double, fragment) = animation.animate(
  hider: alc.hide, 
  alc.single, 
  alc.double, 
  alc.fragment
)

#slide[
  = Alchemist Molecules
  #set align(center + horizon)
  #render(s => (
    {
      alc.skeletize({
        fragment(s, "H_3C")
        s.push(auto)
        single(s, angle: 1)
        fragment(s, "CH")
        s.push(auto)
        double(s, angle: -1, from: 0)
        fragment(s, "CH")
        s.push(auto)
        single(s, from: 0, angle: 1)
        fragment(s, "CH_3")
      })
    },
    s,
  ))
]
