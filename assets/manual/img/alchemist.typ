#import "../../../src/export.typ": *
#set page(paper: "presentation-16-9")
#set text(size: 40pt)
// start-example
#import "@preview/alchemist:0.1.9" as alc

// set stroke to `gray`
#let modifier(func, ..args) = func(stroke: gray + 1pt, ..args) 
#let (single, double) = animation.animate(modifier: modifier, alc.single, alc.double)
#let (fragment,) = animation.animate(
  // set atom color to gray
  modifier: (func, ..args) => func(colors: (gray,), ..args), 
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
