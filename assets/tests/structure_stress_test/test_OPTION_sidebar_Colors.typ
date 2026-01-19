
#import "../../../src/themes/structured/sidebar.typ": template, slide
#import "../../../src/presentate.typ" as p

#show: template.with(
  title: [Option Test: Couleurs Personnalisées],
  author: [Gemini Agent],
  sidebar-color: rgb("#16a085"), active-color: rgb("#f1c40f"), completed-color: rgb("#ecf0f1"),
  mapping: (section: 1, subsection: 2),
)

// --- CONTEXT ---
#slide("CONTEXTE DU TEST")[
  *Thème :* `sidebar`
  *Option testée :* `Couleurs Personnalisées`
  
  *Description :* 
  Test de la palette de couleurs : fond turquoise, actif jaune, complété blanc.

  *Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Couleurs respectées dans la sidebar.
  ]
]

= Section Test
#slide[Slide 1.0]
== Subsection Test
#slide[Slide 1.1]
#slide[Slide 1.2]
