
#import "../../../src/themes/progressive-outline.typ": template, slide

#show: template.with(
  title: [Test D01_skip_L1_to_L3: Saut L1 -> L3 (Pas de L2)],
  subtitle: [Stress Test Automatisé],
  author: [Gemini Agent],
  mapping: (part: 1, section: 2, subsection: 3),
  auto-title: true, // Force auto-title pour verification
  
)

// --- SLIDE DE CONTEXTE ---
#slide("CONTEXTE DU TEST")[ 
  #set text(size: 18pt)
  *Scénario :* Saut L1 -> L3 (Pas de L2)
  
  *Description :* 
  On passe de = Part à === Subsection directement.

  *Mapping Actif :*
  `(part: 1, section: 2, subsection: 3)`

  *Comportement Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Pas de crash. Numérotation type 1.0.1. Nav indique Part I et Sub.
  ]
]

// --- CONTENU DU TEST ---

= Part I
=== Subsection Directe (1.0.1)
#slide[Slide Deep]

