
#import "../../../src/themes/progressive-outline.typ": template, slide

#show: template.with(
  title: [Test D02_mixed_mapping_overflow: Mapping vs Contenu (Overflow)],
  subtitle: [Stress Test Automatisé],
  author: [Gemini Agent],
  mapping: (section: 1, subsection: 2),
  auto-title: true, // Force auto-title pour verification
  
)

// --- SLIDE DE CONTEXTE ---
#slide("CONTEXTE DU TEST")[ 
  #set text(size: 18pt)
  *Scénario :* Mapping vs Contenu (Overflow)
  
  *Description :* 
  Contenu L3 présent, mais Mapping configuré pour L1/L2 uniquement.

  *Mapping Actif :*
  `(section: 1, subsection: 2)`

  *Comportement Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    L3 est ignoré par la nav. Titre slide = 'Subsection 1.1'. Pas 'Detail'.
  ]
]

// --- CONTENU DU TEST ---

= Section 1
== Subsection 1.1
=== Detail 1.1.1 (Non mappé)
#slide[Slide Profonde]

