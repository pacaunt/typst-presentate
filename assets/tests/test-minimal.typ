#import "../../src/themes/structured/minimal.typ": *

#show: template.with(
  title: "Test Minimal Theme",
  author: "Expert Agent",
  max-length: 15,
  use-short-title: true,
)

= Introduction
#metadata("Short Intro") <short>

== Subsection 1
#slide[Slide 1]

= Very long section title that should NOT be truncated in the slide title but SHOULD be in the footer
#slide[
  Sur cette slide :
  - Le titre en haut doit être complet.
  - Le fil d'ariane en bas doit être tronqué ("Very long sect...").
]
