
#import "../../../src/themes/split.typ": template, slide

#show: template.with(
  title: [Test B03_Standard_L1_L2: Standard (L1 + L2)],
  subtitle: [Stress Test Automatisé],
  author: [Gemini Agent],
  mapping: (section: 1, subsection: 2),
  auto-title: true, // Force auto-title pour verification
  primary: rgb("#003366"), secondary: rgb("#336699"),
)

// --- SLIDE DE CONTEXTE ---
#slide("CONTEXTE DU TEST")[ 
  #set text(size: 18pt)
  *Scénario :* Standard (L1 + L2)
  
  *Description :* 
  Hiérarchie classique Section -> Subsection.

  *Mapping Actif :*
  `(section: 1, subsection: 2)`

  *Comportement Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Comportement nominal du thème.
  ]
]

// --- CONTENU DU TEST ---

= Section A
#slide[Slide A]
== Sub A.1
#slide[Slide A.1]
= Section B
== Sub B.1
#slide[Slide B.1]

