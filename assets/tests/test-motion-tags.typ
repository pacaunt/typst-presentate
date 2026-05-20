#import "../../src/export.typ": *

#set page(paper: "presentation-16-9")
#set text(size: 25pt)
#set align(center + horizon)
#show heading: set align(top + left)
#show raw.where(block: true): rect.with(fill: gray.transparentize(80%), radius: 0.5em, outset: 1em)

#slide[
  #title[Motion-tags]
]

#slide[
  = How to use it?
  ```typst
  #motion(s => [
      // your content
      #tag(s, "name", [Hello, World!])
    ],
    hider: hide, // your hiding function
    controls: (
      // an array of rules for displaying each steps
      "name.start",
    )
  )
  ```
]

#slide[
  = Example 1: Using `apply`
  #motion(
    s => [
      #tag(s, "greet", [Hello, Presentate user.])
    ],
    controls: (
      "greet.start",
      ("greet.apply", rect.with(outset: 1em)),
      (
        "greet.apply",
        it => {
          show "Presentate": strong
          it
        },
      ),
    ),
  )
]

#slide[
  = Example 2: `revert`
  #import "@preview/cetz:0.5.2": canvas, draw
  #motion(
    s => [
      #tag(s, "d", [A Normal Circle.])
      #canvas({
        import draw: *
        let tag = tag.with(hider: hide)
        tag(s, "c", circle((0, 0)))
      })
    ],
    controls: {
      import draw: *
      (
        ("c.start", "d.start"),
        (
          (
            "c.apply",
            it => {
              scope({
                fill(red)
                it
              })
            },
          ),
          ("d.apply", it => [Fill it Red.]),
        ),
        (
          (
            "c.apply",
            it => {
              scope({
                scale(2)
                it
              })
            },
          ),
          ("d.apply", it => [Make it BIG.]),
        ),
        (
          "c.revert",
          ("d.apply", it => [Oh, it's gone.])
        ),
        (
          "c.apply",
          ("d.apply", it => [Don't worry, it can came back.])
        )
      )
    },
  )
]
