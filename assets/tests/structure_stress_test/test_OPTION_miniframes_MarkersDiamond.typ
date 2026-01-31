
#import "../../../src/themes/structured/miniframes.typ": template, slide
#import "../../../src/presentate.typ" as p

#show: template.with(
  title: [Option Test: Marqueurs Losanges],
  author: [Gemini Agent],
  navigation: (marker-shape: "diamond", marker-size: 6pt, active-color: rgb("#e67e22")),
  mapping: (section: 1, subsection: 2),
)

// --- CONTEXT ---
#slide("CONTEXTE DU TEST")[
  *Thème :* `miniframes`
  *Option testée :* `Marqueurs Losanges`
  
  *Description :* 
  Test des marqueurs en forme de losange orange.

  *Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Les points de navigation sont des losanges.
  ]
]

= Section A
#slide[Slide A.1]
== Subsection A.1
#slide[Slide A.1.1]
#slide[Slide A.1.2]
= Section B
#slide[Slide B.1]
