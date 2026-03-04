#import "../../../src/export.typ": *
#set page(paper: "presentation-16-9")
#set text(size: 40pt)
// start-example
#import "@preview/alchemist:0.1.8" as alc 

#let modifier(func, ..args) = func(stroke: none, ..args) // set stroke to `none`
#let (single, double) = animation.animate(modifier: modifier, alc.single, alc.double)
#let (fragment,) = animation.animate(
  // set atom colors to white
  modifier: (func, ..args) => func(colors: (white,),..args), 
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
