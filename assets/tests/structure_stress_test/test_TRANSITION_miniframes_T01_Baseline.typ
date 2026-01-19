
#import "../../../src/themes/structured/miniframes.typ": template, slide

#show: template.with(
  title: [Test T01_Baseline: Baseline Defaults],
  subtitle: [Transition Engine Test],
  author: [Gemini Agent],
  mapping: (section: 1, subsection: 2),
  transitions: (),
  auto-title: true, 
  color: rgb("#1a5fb4"),
)

// --- CONTEXT SLIDE ---
#slide("CONTEXTE")[ 
  #set text(size: 18pt)
  *Test:* Baseline Defaults (T01_Baseline)
  
  *Description:* 
  Default configuration with standard mapping.

  *Mapping:* `(section: 1, subsection: 2)`
  
  *Transitions Options:* 
  ```typ
  ()
  ```

  *Expected:*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Transitions for Section (Level 1) and Subsection (Level 2). Standard styling.
  ]
]

// --- CONTENT ---

= Section 1
== Subsection 1.1
#slide[Content 1.1]
= Section 2
== Subsection 2.1
#slide[Content 2.1]

