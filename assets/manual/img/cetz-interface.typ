#import "../../../src/export.typ": * 
#set page(paper: "presentation-16-9")
#set text(size: 40pt)
// start-example 
#import "@preview/cetz:0.5.2": draw, canvas 
// The wrapper
#let canvas = interface(
  canvas,                             // The environment function
  inner: "array",                     // datatype of the content inside
  hider: draw.hide.with(bounds: true) // hider used for `pause`
)

#slide[
  = CeTZ Interface 
  // just for visuals
  #set align(center + horizon)
  #show: scale.with(200%) 
  #canvas({
    import draw: * 
    // change the mode of uncover, and its hider
    let uncover = uncover.with(mode: "array", hider: hide.with(bounds: true))

    circle((0, 0), fill: red) 
    (pause,)
    circle((1, 0), fill: green)
    uncover(3, line((-2, 0), (rel: (5, 0))))
  }) 
]