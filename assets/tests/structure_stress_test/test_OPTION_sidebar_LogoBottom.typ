
#import "../../../src/themes/structured/sidebar.typ": template, slide
#import "../../../src/presentate.typ" as p

#show: template.with(
  title: [Option Test: Logo en Bas],
  author: [Gemini Agent],
  logo: circle(radius: 20pt, fill: white), logo-position: "bottom", width: 20%,
  mapping: (section: 1, subsection: 2),
)

// --- CONTEXT ---
#slide("CONTEXTE DU TEST")[
  *Thème :* `sidebar`
  *Option testée :* `Logo en Bas`
  
  *Description :* 
  Test de l'affichage du logo en bas de la sidebar.

  *Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Un cercle blanc doit apparaître en bas de la barre latérale.
  ]
]

= Section A
#slide[Slide A.1]
== Subsection A.1
#slide[Slide A.1.1]
#slide[Slide A.1.2]
= Section B
#slide[Slide B.1]
