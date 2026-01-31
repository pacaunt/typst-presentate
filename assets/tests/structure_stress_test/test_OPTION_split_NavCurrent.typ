
#import "../../../src/themes/structured/split.typ": template, slide
#import "../../../src/presentate.typ" as p

#show: template.with(
  title: [Option Test: Navigation Style: Current],
  author: [Gemini Agent],
  navigation-style: "current", primary: rgb("#2c3e50"), secondary: rgb("#2980b9"),
  mapping: (section: 1, subsection: 2),
)

// --- CONTEXT ---
#slide("CONTEXTE DU TEST")[
  *Thème :* `split`
  *Option testée :* `Navigation Style: Current`
  
  *Description :* 
  Affichage uniquement de la section/sous-section courante dans le header split.

  *Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Le header ne montre que les titres actifs, pas toute l'arborescence.
  ]
]

= Section Test
#slide[Slide 1.0]
== Subsection Test
#slide[Slide 1.1]
#slide[Slide 1.2]
