
#import "../../../src/themes/structured/sidebar.typ": template, slide

#show: template.with(
  title: [Test T08_Disable_Subsections: Disable Subsections],
  subtitle: [Transition Engine Test],
  author: [Gemini Agent],
  mapping: (section: 1, subsection: 2),
  transitions: (subsections: (enabled: false)),
  auto-title: true, 
  side: "left", active-color: rgb("#f39c12"),
)

// --- CONTEXT SLIDE ---
#slide("CONTEXTE")[ 
  #set text(size: 18pt)
  *Test:* Disable Subsections (T08_Disable_Subsections)
  
  *Description:* 
  Subsections enabled: false.

  *Mapping:* `(section: 1, subsection: 2)`
  
  *Transitions Options:* 
  ```typ
  (subsections: (enabled: false))
  ```

  *Expected:*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    No transition slide for Subsection.
  ]
]

// --- CONTENT ---

= Section 1
== Subsection 1.1 (No Slide)
#slide[Content]

