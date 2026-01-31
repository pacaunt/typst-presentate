
#import "../../../src/themes/structured/split.typ": template, slide

#show: template.with(
  title: [Test T07_Orphan_Subsection: Orphan Subsection],
  subtitle: [Transition Engine Test],
  author: [Gemini Agent],
  mapping: (section: 1, subsection: 2),
  transitions: (),
  auto-title: true, 
  primary: rgb("#003366"), secondary: rgb("#336699"),
)

// --- CONTEXT SLIDE ---
#slide("CONTEXTE")[ 
  #set text(size: 18pt)
  *Test:* Orphan Subsection (T07_Orphan_Subsection)
  
  *Description:* 
  Subsection without parent Section.

  *Mapping:* `(section: 1, subsection: 2)`
  
  *Transitions Options:* 
  ```typ
  ()
  ```

  *Expected:*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Orphan Subsection triggers transition. Outline should handle missing parent gracefully.
  ]
]

// --- CONTENT ---

== Orphan Subsection
#slide[Content]
= Section A
== Normal Subsection

