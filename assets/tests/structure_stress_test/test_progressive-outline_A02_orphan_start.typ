
#import "../../../src/themes/progressive-outline.typ": template, slide

#show: template.with(
  title: [Test A02_orphan_start: Slide Orpheline (Avant H1)],
  subtitle: [Stress Test Automatisé],
  author: [Gemini Agent],
  mapping: (section: 1, subsection: 2),
  auto-title: true, // Force auto-title pour verification
  
)

// --- SLIDE DE CONTEXTE ---
#slide("CONTEXTE DU TEST")[ 
  #set text(size: 18pt)
  *Scénario :* Slide Orpheline (Avant H1)
  
  *Description :* 
  Une slide placée AVANT le premier titre de niveau 1.

  *Mapping Actif :*
  `(section: 1, subsection: 2)`

  *Comportement Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Slide 1: Nav vide/neutre. Slide 2: Nav active sur Section A.
  ]
]

// --- CONTENU DU TEST ---

#slide("Orpheline")[Je suis avant la Section A]
= Section A
#slide("Slide A")[Dans Section A]

