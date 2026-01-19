#import "../../../src/themes/structured/progressive-outline.typ": template, slide

#show: template.with(
  title: [Test Breadcrumb 3 Niveaux],
  mapping: (part: 1, section: 2, subsection: 3),
)

#slide("Explication")[
  Le header (fil d'Ariane) doit maintenant afficher les 3 niveaux s'ils sont mappés :
  `Partie / Section / Sous-section`.
]

= Partie I
== Section A
=== Sous-section A.1
#slide[Vérifiez le header : il doit afficher Partie I / Section A / Sous-section A.1]
