#import "../../src/presentate.typ": *
#import "../../src/components/progressive-outline.typ": progressive-outline

#set page(width: 25cm, height: auto, margin: 1cm)
#set text(font: "Lato", size: 12pt)
#set heading(numbering: "1.1")

= Layout Test Suite

This document tests the `progressive-outline` function with both *Vertical* and *Horizontal* layouts.

#let test-box(title, body) = block(
  stroke: 0.5pt + gray,
  radius: 4pt,
  inset: 1em,
  width: 100%,
  breakable: false,
  [
    #text(weight: "bold", fill: blue, title)
    #v(0.5em)
    #body
  ]
)

== Current Position
Simulation of an outline rendered after Section 1 and Subsection 1.1.

#test-box("Default Vertical Layout (Level 1 & 2: all)", 
  progressive-outline(
    level-1-mode: "all",
    level-2-mode: "all",
    show-numbering: true,
  )
)

#test-box("Horizontal Layout (Level 1 & 2: all, no separator)", 
  progressive-outline(
    layout: "horizontal",
    level-1-mode: "all",
    level-2-mode: "all",
    show-numbering: true,
  )
)

#test-box("Horizontal Layout (Level 1 & 2: all, with separator / )", 
  progressive-outline(
    layout: "horizontal",
    level-1-mode: "all",
    level-2-mode: "all",
    separator: " / ",
    show-numbering: true,
  )
)

#test-box("Horizontal Layout (Breadcrumb style: level-n: current)", 
  progressive-outline(
    layout: "horizontal",
    level-1-mode: "current",
    level-2-mode: "current",
    separator: " > ",
    show-numbering: true,
  )
)

#test-box("Horizontal Layout (Complex: with markers and custom spacing)", 
  progressive-outline(
    layout: "horizontal",
    level-1-mode: "all",
    level-2-mode: "current-parent",
    separator: " | ",
    marker: (state, level) => {
      if state == "active" [★]
      else if state == "completed" [✓]
      else [○]
    },
    spacing: (h-spacing: 1em, marker-gap: 0.2em)
  )
)

#pagebreak()

= Section 1
== Subsection 1.1
#slide[Slide 1.1.1]

= Section 2
== Subsection 2.1
== Subsection 2.2

= Section 3