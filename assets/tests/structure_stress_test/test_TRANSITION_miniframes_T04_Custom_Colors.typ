
#import "../../../src/themes/structured/miniframes.typ": template, slide

#show: template.with(
  title: [Test T04_Custom_Colors: Custom Colors],
  subtitle: [Transition Engine Test],
  author: [Gemini Agent],
  mapping: (section: 1, subsection: 2),
  transitions: (background: black, style: (active-color: yellow, active-weight: "black")),
  auto-title: true, 
  color: rgb("#1a5fb4"),
)

// --- CONTEXT SLIDE ---
#slide("CONTEXTE")[ 
  #set text(size: 18pt)
  *Test:* Custom Colors (T04_Custom_Colors)
  
  *Description:* 
  Black background, Yellow active text.

  *Mapping:* `(section: 1, subsection: 2)`
  
  *Transitions Options:* 
  ```typ
  (background: black, style: (active-color: yellow, active-weight: "black"))
  ```

  *Expected:*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Transition slide with BLACK background and YELLOW text.
  ]
]

// --- CONTENT ---

= Section 1
#slide[Content]

