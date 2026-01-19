
#import "../../../src/themes/structured/miniframes.typ": template, slide

#show: template.with(
  title: [Test T05_Visibility_All: Visibility: Show All],
  subtitle: [Transition Engine Test],
  author: [Gemini Agent],
  mapping: (section: 1, subsection: 2),
  transitions: (sections: (visibility: (section: "all", subsection: "all"))),
  auto-title: true, 
  color: rgb("#1a5fb4"),
)

// --- CONTEXT SLIDE ---
#slide("CONTEXTE")[ 
  #set text(size: 18pt)
  *Test:* Visibility: Show All (T05_Visibility_All)
  
  *Description:* 
  Sections show ALL items instead of current.

  *Mapping:* `(section: 1, subsection: 2)`
  
  *Transitions Options:* 
  ```typ
  (sections: (visibility: (section: "all", subsection: "all")))
  ```

  *Expected:*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    On Section A transition, Section B is visible (not hidden). Subsections also visible.
  ]
]

// --- CONTENT ---

= Section A
== Sub A.1
= Section B
== Sub B.1

