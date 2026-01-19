#import "../../../src/themes/structured/miniframes.typ": template, slide

#show: template.with(
  title: [Test Miniframes: Vertical Bar],
  navigation: (style: "grid", show-level2-titles: true),
  mapping: (part: 1, section: 2, subsection: 3), // 3 levels to trigger bars
)

#slide("Explication")[
  Dans ce test, nous avons 3 niveaux :
  1. Partie (Level 1)
  2. Section (Level 2)
  3. Sous-section (Level 3)
  
  Dans le thème miniframes, les sous-sections (Level 3) au sein d'une même section (Level 2) doivent être séparées par une barre verticale `|` dans la barre de navigation.
]

= Partie I
== Section A
=== Sous-section A.1
#slide[Slide 1.1.1]
#slide[Slide 1.1.2]
=== Sous-section A.2
#slide[Slide 1.2.1]

== Section B
=== Sous-section B.1
#slide[Slide B.1.1]
