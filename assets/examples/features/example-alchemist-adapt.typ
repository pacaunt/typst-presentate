#import "../../../src/export.typ": *

#set page(paper: "presentation-16-9")
#set text(size: 25pt)

#import "@preview/alchemist:0.2.0" as alc: skeletize

#slide[
  = Alchemist Nested Interface

  #let skeletize = interface(skeletize, inner: "array", hider: alc.hide) 
  #let m-cycle = adapt(alc.cycle)
  #skeletize({
    import alc: *
    fragment("HO")
    single(angle: 1) 
    (pause,)
    m-cycle(5, {
      single() 
      (pause,)
      single() 
      single() 
      (pause,)
      single() 
      single()
    })
  })
]