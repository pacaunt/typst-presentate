
#import "../../../src/themes/structured/miniframes.typ": template, slide
#import "../../../src/presentate.typ" as p

#show: template.with(
  title: [Option Test: Navigation en Bas],
  author: [Gemini Agent],
  navigation: (position: "bottom", style: "full", fill: rgb("#c0392b")),
  mapping: (section: 1, subsection: 2),
)

// --- CONTEXT ---
#slide("CONTEXTE DU TEST")[
  *Thème :* `miniframes`
  *Option testée :* `Navigation en Bas`
  
  *Description :* 
  Déplacement de la barre de navigation en bas de page avec le style 'full'.

  *Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    La barre de miniframes doit être au-dessus du footer, fond rouge.
  ]
]

= Section Test
#slide[Slide 1.0]
== Subsection Test
#slide[Slide 1.1]
#slide[Slide 1.2]
