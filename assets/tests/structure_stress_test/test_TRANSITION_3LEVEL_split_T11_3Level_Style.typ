
#import "../../../src/themes/structured/split.typ": template, slide
#import "../../../src/presentate.typ" as p

#show: template.with(
  title: [Test T11_3Level_Style: 3-Level Custom Style],
  subtitle: [3-Level Transition Test],
  author: [Gemini Agent],
  mapping: (part: 1, section: 2, subsection: 3),
  transitions: (max-level: 3, style: (inactive-opacity: 0.1, active-weight: "black", active-color: rgb("#e74c3c"))),
  auto-title: true, 
  primary: rgb("#003366"), secondary: rgb("#336699"),
)

// --- CONTEXT SLIDE ---
#slide("CONTEXTE")[ 
  #set text(size: 18pt)
  *Test:* 3-Level Custom Style (T11_3Level_Style)
  
  *Description:* Testing styles across 3 levels.

  *Mapping:* `(part: 1, section: 2, subsection: 3)`
  
  *Transitions Options:* 
  ```typ
  (max-level: 3, style: (inactive-opacity: 0.1, active-weight: "black", active-color: rgb("#e74c3c")))
  ```

  *Expected:*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Very faint inactive items (0.1 opacity), very bold red active items on all 3 levels.
  ]
]

// --- CONTENT ---

= Part I
== Section A
=== Sub A.1
#slide[Slide]

