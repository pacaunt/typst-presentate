
#import "../../../src/themes/structured/miniframes.typ": template, slide
#import "../../../src/presentate.typ" as p

#show: template.with(
  title: [Option Test: Navigation Full Center],
  author: [Gemini Agent],
  navigation: (style: "full", align-mode: "center", dots-align: "center", fill: rgb("#2980b9")),
  mapping: (section: 1, subsection: 2),
)

// --- CONTEXT ---
#slide("CONTEXTE DU TEST")[
  *Thème :* `miniframes`
  *Option testée :* `Navigation Full Center`
  
  *Description :* 
  Style 'full' avec alignement centré pour les titres et les points.

  *Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Barre de navigation centrée, occupant toute la largeur.
  ]
]

= Section A
#slide[Slide A.1]
== Subsection A.1
#slide[Slide A.1.1]
#slide[Slide A.1.2]
= Section B
#slide[Slide B.1]
