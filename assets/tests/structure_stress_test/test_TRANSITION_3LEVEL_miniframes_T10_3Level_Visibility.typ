
#import "../../../src/themes/structured/miniframes.typ": template, slide
#import "../../../src/presentate.typ" as p

#show: template.with(
  title: [Test T10_3Level_Visibility: 3-Level Focus (Current-Parent)],
  subtitle: [3-Level Transition Test],
  author: [Gemini Agent],
  mapping: (part: 1, section: 2, subsection: 3),
  transitions: (max-level: 3, subsections: (visibility: (part: "none", section: "current", subsection: "current-parent"))),
  auto-title: true, 
  color: rgb("#1a5fb4"),
)

// --- CONTEXT SLIDE ---
#slide("CONTEXTE")[ 
  #set text(size: 18pt)
  *Test:* 3-Level Focus (Current-Parent) (T10_3Level_Visibility)
  
  *Description:* Testing focus mode at depth 3.

  *Mapping:* `(part: 1, section: 2, subsection: 3)`
  
  *Transitions Options:* 
  ```typ
  (max-level: 3, subsections: (visibility: (part: "none", section: "current", subsection: "current-parent")))
  ```

  *Expected:*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    On Sub A.2 transition, should show Section A (active) and its children (Sub A.1, Sub A.2). Section B should be hidden.
  ]
]

// --- CONTENT ---

= Part I
== Section A
=== Sub A.1
#slide[Slide A.1]
=== Sub A.2
#slide[Slide A.2]
== Section B
=== Sub B.1
#slide[Slide B.1]

