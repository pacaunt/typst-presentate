#import "../../../src/export.typ": *
#set page(paper: "presentation-16-9")
#set text(size: 40pt)
// start-example
#import "@preview/cetz:0.4.2": canvas, draw

#slide[
  #set align(center + horizon)
  #motion(
    s => [
      #canvas({
        import draw: *
        scale(1.5)
        stroke((thickness: 2pt))
        line(name: "L", (0, 0), (6, 0), mark: (symbol: "o"))
        stroke((paint: gray))
        intersections("I", {
          tag(s, "circ1", circle("L.start", radius: 4))
          tag(s, "circ2", circle("L.end", radius: 4))
        })
        tag(s, "pt", {
          circle(radius: .1, "I.1", fill: black)
          circle(radius: .1, "I.0", fill: black)
        })
        tag(s, "cut", line("I.0", "I.1"))
        tag(s, "mark", {
          stroke(black)
          mark("L.mid", "L.end", symbol: "|", width: .5)
        })
      })
    ],
    hider: draw.hide.with(bounds: true),
    controls: (
      (), // don't show any group
      "circ1.start", // show the `circ1`
      "circ2.start", // show the `circ2`
      "pt.start", // show the `pt`
      ("circ1.stop", "circ2.stop", "cut"), 
      // stop showing `circ1` and `circ2`, and show the `cut` once
      ("mark.start", "pt.stop"), // show the `mark` and stop showing the `pt`
    ),
  )
]