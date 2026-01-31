
#import "../../../src/themes/structured/miniframes.typ": template, slide

#show: template.with(
  title: [Test T06_Mapping_Shift: Mapping Shift (Part/Section)],
  subtitle: [Transition Engine Test],
  author: [Gemini Agent],
  mapping: (part: 1, section: 2),
  transitions: (),
  auto-title: true, 
  color: rgb("#1a5fb4"),
)

// --- CONTEXT SLIDE ---
#slide("CONTEXTE")[ 
  #set text(size: 18pt)
  *Test:* Mapping Shift (Part/Section) (T06_Mapping_Shift)
  
  *Description:* 
  Mapping Part=1, Section=2.

  *Mapping:* `(part: 1, section: 2)`
  
  *Transitions Options:* 
  ```typ
  ()
  ```

  *Expected:*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Level 1 treated as 'Part', Level 2 as 'Section'. Part transition should show Parts only (default).
  ]
]

// --- CONTENT ---

= Part I
== Section A
#slide[Content]
== Section B

