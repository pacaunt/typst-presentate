
#import "../../../src/themes/structured/split.typ": template, slide
#import "../../../src/presentate.typ" as p

#show: template.with(
  title: [Option Test: Aspect Ratio 4:3],
  author: [Gemini Agent],
  aspect-ratio: "4-3",
  mapping: (section: 1, subsection: 2),
)

// --- CONTEXT ---
#slide("CONTEXTE DU TEST")[
  *Thème :* `split`
  *Option testée :* `Aspect Ratio 4:3`
  
  *Description :* 
  Changement du format de la présentation en 4:3.

  *Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    La diapositive doit être plus carrée (format traditionnel).
  ]
]

= Section A
#slide[Slide A.1]
== Subsection A.1
#slide[Slide A.1.1]
#slide[Slide A.1.2]
= Section B
#slide[Slide B.1]
