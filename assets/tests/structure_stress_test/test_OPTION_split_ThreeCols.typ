
#import "../../../src/themes/structured/split.typ": template, slide
#import "../../../src/presentate.typ" as p

#show: template.with(
  title: [Option Test: Header 3 Colonnes],
  author: [Gemini Agent],
  header-columns: (1fr, 2fr, 1fr), primary: rgb("#8e44ad"),
  mapping: (section: 1, subsection: 2),
)

// --- CONTEXT ---
#slide("CONTEXTE DU TEST")[
  *Thème :* `split`
  *Option testée :* `Header 3 Colonnes`
  
  *Description :* 
  Test d'un header split avec 3 colonnes de largeurs inégales.

  *Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Header divisé en 3 zones distinctes avec le ratio 1:2:1.
  ]
]

= Section A
#slide[Slide A.1]
== Subsection A.1
#slide[Slide A.1.1]
#slide[Slide A.1.2]
= Section B
#slide[Slide B.1]
