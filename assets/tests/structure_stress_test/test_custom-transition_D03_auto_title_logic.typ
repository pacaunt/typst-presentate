
#import "../../../src/themes/custom-transition.typ": template, slide

#show: template.with(
  title: [Test D03_auto_title_logic: Test Auto-Title vs Manual],
  subtitle: [Stress Test Automatisé],
  author: [Gemini Agent],
  mapping: (section: 1, subsection: 2),
  auto-title: true, // Force auto-title pour verification
  
)

// --- SLIDE DE CONTEXTE ---
#slide("CONTEXTE DU TEST")[ 
  #set text(size: 18pt)
  *Scénario :* Test Auto-Title vs Manual
  
  *Description :* 
  Mélange de slides avec titre manuel et titre auto.

  *Mapping Actif :*
  `(section: 1, subsection: 2)`

  *Comportement Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Priorité : Titre Manuel > Titre Auto (Niveau le plus bas mappé).
  ]
]

// --- CONTENU DU TEST ---

= Section Auto
#slide[Doit avoir titre 'Section Auto']
#slide("Manuel")[Doit avoir titre 'Manuel']
== Sub Auto
#slide[Doit avoir titre 'Sub Auto']

