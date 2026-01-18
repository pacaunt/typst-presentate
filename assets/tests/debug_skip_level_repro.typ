#import "../../src/components/progressive-outline.typ": *

#set page(width: 15cm, height: auto, margin: 1cm)
#set text(font: "Lato", size: 12pt)

// Simuler l'enregistrement des titres
#show heading: it => register-heading(it) + it

= Part I (Niveau 1)

// Pas de niveau 2 ici

=== Subsection A (Niveau 3)

=== Subsection B (Niveau 3)

#v(2em)
*Test:* Progressive Outline avec saut de niveau (L1 -> L3).

*Attendu:* Les sous-sections A et B doivent s'afficher ci-dessous (sous Part I).

*Résultat observé :*

#line(length: 100%)

#progressive-outline(
  level-1-mode: "current",       
  level-2-mode: "current-parent", 
  level-3-mode: "current-parent", 
  show-numbering: true,
)

