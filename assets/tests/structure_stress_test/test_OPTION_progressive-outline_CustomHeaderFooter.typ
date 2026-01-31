
#import "../../../src/themes/structured/progressive-outline.typ": template, slide
#import "../../../src/presentate.typ" as p

#show: template.with(
  title: [Option Test: Header/Footer Custom],
  author: [Gemini Agent],
  header: [--- Mon Header Perso ---], footer: [Page #context counter(page).display()],
  mapping: (section: 1, subsection: 2),
)

// --- CONTEXT ---
#slide("CONTEXTE DU TEST")[
  *Thème :* `progressive-outline`
  *Option testée :* `Header/Footer Custom`
  
  *Description :* 
  Remplacement complet du header et du footer par du contenu arbitraire.

  *Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Le header affiche le texte fixe, le footer affiche 'Page X'.
  ]
]

= Section Test
#slide[Slide 1.0]
== Subsection Test
#slide[Slide 1.1]
#slide[Slide 1.2]
