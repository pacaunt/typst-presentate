
#import "../../../src/themes/structured/custom-transition.typ": template, slide
#import "../../../src/presentate.typ" as p

#show: template.with(
  title: [Test T09_3Level_Full: 3-Level Depth (Part/Sec/Sub)],
  subtitle: [3-Level Transition Test],
  author: [Gemini Agent],
  mapping: (part: 1, section: 2, subsection: 3),
  transitions: (max-level: 3),
  auto-title: true, 
  
)

// --- CONTEXT SLIDE ---
#slide("CONTEXTE")[ 
  #set text(size: 18pt)
  *Test:* 3-Level Depth (Part/Sec/Sub) (T09_3Level_Full)
  
  *Description:* Full 3-level structure with Part, Section, and Subsection transitions.

  *Mapping:* `(part: 1, section: 2, subsection: 3)`
  
  *Transitions Options:* 
  ```typ
  (max-level: 3)
  ```

  *Expected:*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Transitions for Part (L1), Section (L2) and Subsection (L3). Outline should show 3 levels of depth.
  ]
]

// --- CONTENT ---

= Part I
== Section A
=== Subsection A.1
#slide[Content A.1]
=== Subsection A.2
#slide[Content A.2]
== Section B
#slide[Content B]

