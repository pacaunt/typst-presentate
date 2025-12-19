#import "@local/presentate:0.2.3": *

#set page(paper: "presentation-16-9")
#set text(size: 25pt)

#import "@preview/cetz:0.4.2": canvas, draw

#slide[
  = Drawing A Fan
  #set align(center + horizon)
  #motion(
    s => [
      #canvas({
        import draw: *
        scale(3)
        tag(s, "filled", hider: it => none, stroke(red + 5pt))
        tag(s, "arc", arc((0, 0), start: 30deg, stop: 150deg, name: "R"))
        tag(s, "line1", line("R.start", "R.origin"))
        tag(s, "line2", line("R.end", "R.origin"))
      })
    ],
    hider: draw.hide.with(bounds: true),
    controls: (
      "line2.start",
      "line1.start",
      "arc.start",
      "filled.start"
    ),
  )
]
