#import "../../../src/export.typ": *
#set page(paper: "presentation-16-9")
#set text(size: 40pt)
// start-example
#import "@preview/cetz:0.4.2": canvas, draw 
// create a custom pause function for CeTZ package's elements
#let cetz-pause = animation.pause.with(hider: draw.hide.with(bounds: true))
#slide[
  = CeTZ animation
  #set align(center + horizon)
  #render(s => ({
    import animation: * 
    canvas({
      import draw: * 
      scale(3)
      circle((0, 0))
      cetz-pause(s, circle((2, 0), fill: red))
      s.push(auto) // update the pause
      cetz-pause(s, circle((4, 0), fill: eastern))
    })
  }, s))
]