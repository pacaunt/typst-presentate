#import "../../../src/export.typ": *
#set page(paper: "presentation-16-9")
#set text(size: 40pt)
// start-example
#slide[
  #motion(s => {
    set rect(width: 100%, height: 100%)
    grid(
      rows: 1fr, columns: (1fr,1fr), 
      tag(s, "red", rect(fill: red)), 
      tag(s, "green", rect(fill: olive)),
      tag(s, "blue", rect(fill: blue)), 
      tag(s, "yellow", rect(fill: yellow))
    )
  }, 
  controls: ((),"red", "blue", "yellow", "green"))
]