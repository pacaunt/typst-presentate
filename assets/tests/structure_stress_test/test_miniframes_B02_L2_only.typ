
#import "../../../src/themes/miniframes.typ": template, slide

#show: template.with(
  title: [Test B02_L2_only: Niveau 2 Uniquement (Démarrage Profond)],
  subtitle: [Stress Test Automatisé],
  author: [Gemini Agent],
  mapping: (section: 1, subsection: 2),
  auto-title: true, // Force auto-title pour verification
  color: rgb("#1a5fb4"),
)

// --- SLIDE DE CONTEXTE ---
#slide("CONTEXTE DU TEST")[ 
  #set text(size: 18pt)
  *Scénario :* Niveau 2 Uniquement (Démarrage Profond)
  
  *Description :* 
  Document commençant directement par == Titre.

  *Mapping Actif :*
  `(section: 1, subsection: 2)`

  *Comportement Attendu :*
  #block(fill: luma(240), inset: 1em, radius: 5pt, width: 100%)[ 
    Fonctionnel. La nav peut afficher '...' ou vide pour le parent manquant.
  ]
]

// --- CONTENU DU TEST ---

== Subsection 1
#slide[Slide 1]
== Subsection 2
#slide[Slide 2]

