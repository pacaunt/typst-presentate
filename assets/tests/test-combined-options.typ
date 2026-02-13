#import "../../src/themes/structured/miniframes.typ": *

#show: template.with(
  title: "Test Combined Options",
  author: "Expert Agent",
  // Combiné : utilise les titres courts ET tronque si c'est encore trop long
  max-length: 8, 
  use-short-title: true,
)

= Une section très longue
#metadata("Titre court mais encore trop long") <short>

== Une sous-section
#slide[
  Sur cette slide :
  - La section devrait afficher "Titre co..." (troncation du titre court).
]

= Une autre section sans titre court
#slide[
  Sur cette slide :
  - La section devrait afficher "Une autr..." (troncation du titre original).
]
