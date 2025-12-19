#import "../../src/export.typ": * 
#set page(paper: "presentation-16-9", numbering: "1")
#set text(size: 25pt)

#set heading(numbering: "1.1")

#slide[
  = First Topic
]

#for (i, v) in ([First], [Second], [Third], [Fourth], [Fifth]).enumerate() {
  slide[
    == #v
    Hello #i
    #for i in range(6) [
      #show: pause
      Hello
    ]
  ]
}

#let section-slide(body) = {
      body
}

#slide[
  = Second Topic
]

#for (i, v) in ([First], [Second], [Third], [Fourth], [Fifth]).enumerate() {
  slide[
    == #v
    Hello #i
    #for i in range(6) [
      #show: pause
      Hello
    ]
  ]
}

#section-slide[
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  Hg
]

#for (i, v) in ([First], [Second], [Third], [Fourth], [Fifth]).enumerate() {
  slide[
    == #v
    Hello #i
    #for i in range(6) [
      #show: pause
      Hello
    ]
  ]
}

#slide[
  = Third Topic
]

#section-slide[
  #show: pause
  #show: pause
  #show: pause
  #show: pause
]


#section-slide[
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  Hg
]

// #slide[
//   = Fourth Topic
// ]

// #for (i, v) in ([First], [Second], [Third], [Fourth], [Fifth]).enumerate() {
//   slide[
//     == #v
//     Hello #i
//     #for i in range(6) [
//       #show: pause
//       Hello
//     ]
//   ]
// }

#section-slide[
  #show: pause
  #show: pause
  #show: pause
  #show: pause
]

#section-slide[
  #show: pause
  #show: pause
  #show: pause
  #show: pause
]

#for (i, v) in ([First], [Second], [Third], [Fourth], [Fifth]).enumerate() {
  section-slide[#show: pause; GH]
  slide[
    == #v
    Hello #i
    #for i in range(6) [
      #show: pause
      Hello
    ]
  ]
}
#section-slide[
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  Hg
]
#section-slide[
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  Hg
]
= Fourth Topic
#section-slide[
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  Hg
]

= Fifth Topic
#section-slide[
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  Hg
]
#section-slide[
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  Hg
]
#section-slide[
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  Hg
]

#section-slide[
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  #show: pause
  Hg
]

#slide[
  #let step-item = step-item.with(hider: text.with(fill: gray))
  = Item Lists
  #step-item[
    - This is the first Item
    - This came later
      #step-item[
        + Hello 
        + It's Me
      ]
  ]
]

#import "@preview/cetz:0.4.2": draw, canvas 

#slide[
  == A slide with CeTZ Diagram 

  #render(s => ({
    import animation: * 
    import draw: *
    let (rect, circle) = animate(hider: hide.with(bounds: true), rect, circle)
    canvas({
      rect(s, (0, 0), (1, 1))
      s.push(auto)
      circle(s, (2, 2))
    })
  }, s))
]

#slide[
  = Some Interesting Drawing
  Hey 
  #show: pause; 
  Hello
  #motion(start: auto, s => [
    #set align(center + horizon)
    #canvas({
      import draw: * 
      tag(s, "A", {
        circle((0, 0))
      })
      tag(s, "A1", scope({
        scale(2)
        rect((-1, -1), (1, 1))
      }))
      tag(s, "A2", {
        rect((-1, -1), (1, 1))
      })
    })
  ], controls: (
    "A", "A2", "A1.start", "A1.stop"
  ), hider: draw.hide.with(bounds: true), update-pause: true)
  #uncover((rel: -1), [H], update-pause: true)
  #show: pause
  Good 
]
