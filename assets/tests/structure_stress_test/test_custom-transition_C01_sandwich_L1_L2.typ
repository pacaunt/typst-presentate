
#import "../../../src/themes/custom-transition.typ": template, slide

#show: template.with(
  title: [Test C01_sandwich_L1_L2: Sandwich L1 -> Slide -> L2],
  subtitle: [Stress Test Automatisé],
  author: [Gemini Agent],
  mapping: (section: 1, subsection: 2),
  auto-title: true, // Force auto-title pour verification
  
)

// --- SLIDE DE CONTEXTE ---
#slide("CONTEXTE DU TEST")[ 
  #set text(size: 18pt)
  *Scénario :* Sandwich L1 -> Slide -> L2
  
  *Description :* 
  Une slide insérée APRES L1 mais AVANT le premier L2.

  *Mapping Actif :*
  `(section: 1, subsection: 2)`

  *Comportement Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Slide Sandwich: Nav indique Section A, pas de sous-section active.
  ]
]

// --- CONTENU DU TEST ---

= Section A
#slide("Sandwich")[Cette slide appartient à Section A, mais n'a pas de sous-section.]
== Subsection A.1
#slide("Normal")[Dans A.1]

