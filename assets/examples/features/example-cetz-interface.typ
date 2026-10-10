#import "../../../src/export.typ": *

#set page(paper: "presentation-16-9")
#set text(size: 25pt)

#import "@preview/cetz:0.5.2": canvas, draw
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#slide[
  = CeTZ integration using `interface`

  #let canvas = interface(canvas, inner: "array", hider: draw.hide.with(bounds: true))
  #canvas({
    // You can use pause and animations inside CeTZ.
    import draw: *
    let uncover = uncover.with(mode: "array", hider: draw.hide.with(bounds: true))
    circle((0, 0), radius: 2)
    (pause,)
    circle((4, 0), radius: 2)
    uncover(3, circle((8, 0), radius: 2))
  })
]

#slide[
  = Fletcher integration

  #let diagram = interface(diagram, hider: fletcher.hide)
  #let f-uncover = uncover.with(hider: fletcher.hide)
  #diagram(
    node((0, 0), [First Node], name: <1>),
    pause,
    node((1, 0), [Second Node], name: <2>),
    f-uncover(3, edge(<1>, "d,r", <2>, "->")),
  )
]
