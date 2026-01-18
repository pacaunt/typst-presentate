
#import "../../../src/themes/sidebar.typ": template, slide

#show: template.with(
  title: [Test B01_L1_only: Niveau 1 Uniquement],
  subtitle: [Stress Test Automatisé],
  author: [Gemini Agent],
  mapping: (section: 1, subsection: 2),
  auto-title: true, // Force auto-title pour verification
  side: "left", active-color: rgb("#f39c12"),
)

// --- SLIDE DE CONTEXTE ---
#slide("CONTEXTE DU TEST")[ 
  #set text(size: 18pt)
  *Scénario :* Niveau 1 Uniquement
  
  *Description :* 
  Plusieurs sections, aucune sous-section.

  *Mapping Actif :*
  `(section: 1, subsection: 2)`

  *Comportement Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Navigation simple. Pas de sous-menus déroulants/points secondaires.
  ]
]

// --- CONTENU DU TEST ---

= Section A
#slide[Slide A]
= Section B
#slide[Slide B]

