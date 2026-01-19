
#import "../../../src/themes/structured/split.typ": template, slide
#import "../../../src/presentate.typ" as p

#show: template.with(
  title: [Option Test: Alignements Alternatifs],
  author: [Gemini Agent],
  section-align: left, subsection-align: right, header-columns: (2fr, 1fr),
  mapping: (section: 1, subsection: 2),
)

// --- CONTEXT ---
#slide("CONTEXTE DU TEST")[
  *Thème :* `split`
  *Option testée :* `Alignements Alternatifs`
  
  *Description :* 
  Inversion des alignements et modification du ratio des colonnes du header.

  *Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Section à gauche (large), sous-section à droite (étroit).
  ]
]

= Section Test
#slide[Slide 1.0]
== Subsection Test
#slide[Slide 1.1]
#slide[Slide 1.2]
