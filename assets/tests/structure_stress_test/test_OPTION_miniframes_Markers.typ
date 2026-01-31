
#import "../../../src/themes/structured/miniframes.typ": template, slide
#import "../../../src/presentate.typ" as p

#show: template.with(
  title: [Option Test: Marqueurs Carrés],
  author: [Gemini Agent],
  navigation: (marker-shape: "square", marker-size: 5pt, active-color: rgb("#2ecc71")),
  mapping: (section: 1, subsection: 2),
)

// --- CONTEXT ---
#slide("CONTEXTE DU TEST")[
  *Thème :* `miniframes`
  *Option testée :* `Marqueurs Carrés`
  
  *Description :* 
  Changement de la forme des points de navigation en carrés verts.

  *Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Les points de progression sont des carrés.
  ]
]

= Section Test
#slide[Slide 1.0]
== Subsection Test
#slide[Slide 1.1]
#slide[Slide 1.2]
