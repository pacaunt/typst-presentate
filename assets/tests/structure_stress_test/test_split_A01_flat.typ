
#import "../../../src/themes/split.typ": template, slide

#show: template.with(
  title: [Test A01_flat: Structure Plate (0 Niveaux)],
  subtitle: [Stress Test Automatisé],
  author: [Gemini Agent],
  mapping: (section: 1, subsection: 2),
  auto-title: true, // Force auto-title pour verification
  primary: rgb("#003366"), secondary: rgb("#336699"),
)

// --- SLIDE DE CONTEXTE ---
#slide("CONTEXTE DU TEST")[ 
  #set text(size: 18pt)
  *Scénario :* Structure Plate (0 Niveaux)
  
  *Description :* 
  Aucun titre (=). Uniquement des slides brutes.

  *Mapping Actif :*
  `(section: 1, subsection: 2)`

  *Comportement Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Barre de navigation vide (ou titre doc). Sidebar vide. Pas de transition.
  ]
]

// --- CONTENU DU TEST ---

#slide("Slide 1")[Contenu Slide 1]
#slide("Slide 2")[Contenu Slide 2]

