
#import "../../../src/themes/split.typ": template, slide

#show: template.with(
  title: [Test C02_sandwich_mixed: Sandwich Complexe],
  subtitle: [Stress Test Automatisé],
  author: [Gemini Agent],
  mapping: (part: 1, section: 2, subsection: 3),
  auto-title: true, // Force auto-title pour verification
  primary: rgb("#003366"), secondary: rgb("#336699"),
)

// --- SLIDE DE CONTEXTE ---
#slide("CONTEXTE DU TEST")[ 
  #set text(size: 18pt)
  *Scénario :* Sandwich Complexe
  
  *Description :* 
  Slides placées à tous les niveaux d'interstice.

  *Mapping Actif :*
  `(part: 1, section: 2, subsection: 3)`

  *Comportement Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Chaque slide doit hériter du titre de son parent direct le plus proche.
  ]
]

// --- CONTENU DU TEST ---

= Part I
#slide[Slide Niveau 1]
== Section A
#slide[Slide Niveau 2]
=== Subsection a
#slide[Slide Niveau 3]

