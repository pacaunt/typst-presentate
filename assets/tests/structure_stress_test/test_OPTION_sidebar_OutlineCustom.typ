
#import "../../../src/themes/structured/sidebar.typ": template, slide
#import "../../../src/presentate.typ" as p

#show: template.with(
  title: [Option Test: Outline Sidebar Custom],
  author: [Gemini Agent],
  outline-options: (spacing: (v-between-1-1: 2em, indent-2: 3em)),
  mapping: (section: 1, subsection: 2),
)

// --- CONTEXT ---
#slide("CONTEXTE DU TEST")[
  *Thème :* `sidebar`
  *Option testée :* `Outline Sidebar Custom`
  
  *Description :* 
  Test de la personnalisation de l'outline interne à la sidebar.

  *Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Les titres de niveau 1 doivent être très espacés, et le niveau 2 très indenté.
  ]
]

= Section A
#slide[Slide A.1]
== Subsection A.1
#slide[Slide A.1.1]
#slide[Slide A.1.2]
= Section B
#slide[Slide B.1]
