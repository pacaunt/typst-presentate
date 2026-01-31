
#import "../../../src/themes/structured/split.typ": template, slide

#show: template.with(
  title: [Test T02_Filter_Level1: Filter: Level 1 Only],
  subtitle: [Transition Engine Test],
  author: [Gemini Agent],
  mapping: (section: 1, subsection: 2),
  transitions: (filter: h => h.level == 1),
  auto-title: true, 
  primary: rgb("#003366"), secondary: rgb("#336699"),
)

// --- CONTEXT SLIDE ---
#slide("CONTEXTE")[ 
  #set text(size: 18pt)
  *Test:* Filter: Level 1 Only (T02_Filter_Level1)
  
  *Description:* 
  Filter function allowing only level 1 headings.

  *Mapping:* `(section: 1, subsection: 2)`
  
  *Transitions Options:* 
  ```typ
  (filter: h => h.level == 1)
  ```

  *Expected:*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Transition slide ONLY for 'Section'. Subsection headings appear in outline but trigger no slide.
  ]
]

// --- CONTENT ---

= Section 1 (Transition)
== Subsection 1.1 (No Transition)
#slide[Content]
= Section 2 (Transition)

