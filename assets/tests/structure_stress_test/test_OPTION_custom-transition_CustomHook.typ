
#import "../../../src/themes/structured/custom-transition.typ": template, slide
#import "../../../src/presentate.typ" as p

#show: template.with(
  title: [Option Test: Hook de transition personnalisé],
  author: [Gemini Agent],
  on-section-change: (h) => [#p.slide[Slide spéciale pour #h.body]],
  mapping: (section: 1, subsection: 2),
)

// --- CONTEXT ---
#slide("CONTEXTE DU TEST")[
  *Thème :* `custom-transition`
  *Option testée :* `Hook de transition personnalisé`
  
  *Description :* 
  Test de l'injection d'une slide totalement différente via le hook on-section-change.

  *Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Au lieu de l'outline standard, on voit une slide avec 'Slide spéciale pour...'
  ]
]

= Section Test
#slide[Slide 1.0]
== Subsection Test
#slide[Slide 1.1]
#slide[Slide 1.2]
