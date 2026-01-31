
#import "../../../src/themes/structured/miniframes.typ": template, slide

#show: template.with(
  title: [Test T03_MaxLevel_1: Max Level: 1],
  subtitle: [Transition Engine Test],
  author: [Gemini Agent],
  mapping: (section: 1, subsection: 2),
  transitions: (max-level: 1),
  auto-title: true, 
  color: rgb("#1a5fb4"),
)

// --- CONTEXT SLIDE ---
#slide("CONTEXTE")[ 
  #set text(size: 18pt)
  *Test:* Max Level: 1 (T03_MaxLevel_1)
  
  *Description:* 
  Explicit max-level set to 1.

  *Mapping:* `(section: 1, subsection: 2)`
  
  *Transitions Options:* 
  ```typ
  (max-level: 1)
  ```

  *Expected:*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Similar to Filter, but using max-level. Only Section transition.
  ]
]

// --- CONTENT ---

= Section 1 (Transition)
== Subsection 1.1 (No Transition)
#slide[Content]

