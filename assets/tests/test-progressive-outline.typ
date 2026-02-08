#import "../../src/themes/structured/progressive-outline.typ": *

#show: template.with(
  title: "Test Progressive Outline",
  author: "Expert Agent",
  max-length: 15,
  use-short-title: true,
)

= First Section with a very long title
#metadata("Short First") <short>

== Subsection A
#slide[Content A]

= Second Section
#slide[Content B]

== Very long subsection title for testing breadcrumbs
#metadata("Short Bread") <short>
#slide[Content C]
