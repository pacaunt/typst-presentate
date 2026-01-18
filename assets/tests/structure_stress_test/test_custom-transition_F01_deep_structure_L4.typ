
#import "../../../src/themes/custom-transition.typ": template, slide

#show: template.with(
  title: [Test F01_deep_structure_L4: Structure Profonde (Niveau 4+)],
  subtitle: [Stress Test Automatisé],
  author: [Gemini Agent],
  mapping: (section: 1, subsection: 2),
  auto-title: true, // Force auto-title pour verification
  
)

// --- SLIDE DE CONTEXTE ---
#slide("CONTEXTE DU TEST")[ 
  #set text(size: 18pt)
  *Scénario :* Structure Profonde (Niveau 4+)
  
  *Description :* 
  Utilisation de ==== et ===== à l'extérieur des slides.

  *Mapping Actif :*
  `(section: 1, subsection: 2)`

  *Comportement Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Pas de crash. Les niveaux > 3 sont ignorés par la nav mais le contenu s'affiche. Titre slide hérité de L2 ou L3 selon mapping.
  ]
]

// --- CONTENU DU TEST ---

= Section 1
== Subsection 1.1
=== Sub-sub (L3)
==== Deep Level (L4)
#slide[Slide Profonde L4]
===== Very Deep (L5)
#slide[Slide Profonde L5]

