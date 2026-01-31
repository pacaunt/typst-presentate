
#import "../../../src/themes/structured/sidebar.typ": template, slide
#import "../../../src/presentate.typ" as p

#show: template.with(
  title: [Option Test: Sidebar à Droite],
  author: [Gemini Agent],
  side: "right", width: 25%, sidebar-color: rgb("#34495e"),
  mapping: (section: 1, subsection: 2),
)

// --- CONTEXT ---
#slide("CONTEXTE DU TEST")[
  *Thème :* `sidebar`
  *Option testée :* `Sidebar à Droite`
  
  *Description :* 
  Positionnement de la barre latérale à droite avec une largeur de 25%.

  *Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    La sidebar doit apparaître à droite. Le contenu de la slide est décalé à gauche.
  ]
]

= Section Test
#slide[Slide 1.0]
== Subsection Test
#slide[Slide 1.1]
#slide[Slide 1.2]
