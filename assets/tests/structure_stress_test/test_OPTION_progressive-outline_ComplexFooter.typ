
#import "../../../src/themes/structured/progressive-outline.typ": template, slide
#import "../../../src/presentate.typ" as p

#show: template.with(
  title: [Option Test: Footer Complexe],
  author: [Gemini Agent],
  footer: grid(columns: (1fr, 1fr), align: (left, right), [Confidentiel], [Page #context counter(page).display()]),
  mapping: (section: 1, subsection: 2),
)

// --- CONTEXT ---
#slide("CONTEXTE DU TEST")[
  *Thème :* `progressive-outline`
  *Option testée :* `Footer Complexe`
  
  *Description :* 
  Utilisation d'une grille complexe dans le footer.

  *Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Footer avec 'Confidentiel' à gauche et le numéro de page à droite.
  ]
]

= Section A
#slide[Slide A.1]
== Subsection A.1
#slide[Slide A.1.1]
#slide[Slide A.1.2]
= Section B
#slide[Slide B.1]
