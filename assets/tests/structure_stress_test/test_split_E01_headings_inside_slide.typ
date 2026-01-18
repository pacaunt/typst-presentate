
#import "../../../src/themes/split.typ": template, slide

#show: template.with(
  title: [Test E01_headings_inside_slide: Titres INTERNES à la Slide],
  subtitle: [Stress Test Automatisé],
  author: [Gemini Agent],
  mapping: (section: 1, subsection: 2),
  auto-title: true, // Force auto-title pour verification
  primary: rgb("#003366"), secondary: rgb("#336699"),
)

// --- SLIDE DE CONTEXTE ---
#slide("CONTEXTE DU TEST")[ 
  #set text(size: 18pt)
  *Scénario :* Titres INTERNES à la Slide
  
  *Description :* 
  Utilisation de =, ==, === DANS le contenu d'une slide.

  *Mapping Actif :*
  `(section: 1, subsection: 2)`

  *Comportement Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Les titres internes doivent être stylisés MAIS ignorés par la navigation et ne pas créer de nouvelles sections.
  ]
]

// --- CONTENU DU TEST ---

= Section Externe (Navigation)
#slide("Test Isolation")[
  Ceci est du texte normal.
  = Titre H1 Interne (Ne doit pas casser la nav)
  Texte sous H1.
  == Titre H2 Interne
  Texte sous H2.
]
#slide("Check")[Slide de vérification après le chaos.]

