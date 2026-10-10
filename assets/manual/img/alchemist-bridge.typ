#import "../../../src/export.typ": *


#set page(paper: "presentation-16-9")
#set text(size: 40pt)

// start-example
#import "@preview/alchemist:0.2.0" as alc: skeletize
// enable Presentate's parsing
#let skeletize = interface(skeletize, inner: "array", hider: alc.hide)
#let m-cycle = bridge(alc.cycle)  // default mode is "array"

#slide[
  = Alchemist Environment 
  // visuals
  #set align(center + horizon)
  #skeletize({
    import alc: *
    let uncover = uncover.with(mode: "array", hider: alc.hide)
    fragment("HO")
    single(angle: -1)
    m-cycle(5, {
      single()
      (pause,) // pauses inside `cycle`!
      single()
      single()
      (pause,)
      single()
      single()
    })
  })
]
