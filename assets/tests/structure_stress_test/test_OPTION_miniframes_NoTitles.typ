
#import "../../../src/themes/structured/miniframes.typ": template, slide
#import "../../../src/presentate.typ" as p

#show: template.with(
  title: [Option Test: Navigation Sans Titres],
  author: [Gemini Agent],
  navigation: (show-level1-titles: false, show-level2-titles: false),
  mapping: (section: 1, subsection: 2),
)

// --- CONTEXT ---
#slide("CONTEXTE DU TEST")[
  *Thème :* `miniframes`
  *Option testée :* `Navigation Sans Titres`
  
  *Description :* 
  Masquage des titres dans la barre de miniframes pour ne garder que les points.

  *Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Seuls les points (dots) doivent apparaître dans la barre de navigation.
  ]
]

= Section A
#slide[Slide A.1]
== Subsection A.1
#slide[Slide A.1.1]
#slide[Slide A.1.2]
= Section B
#slide[Slide B.1]
