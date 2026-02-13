#import "../../src/themes/structured/split.typ": *

#show: template.with(
  title: "Test Split Theme",
  author: "Expert Agent",
  max-length: (level-1: 15, level-2: 10),
  use-short-title: true,
)

= Main Section with a long title
#metadata("Short Main") <short>

== Detailed Subsection
#slide[Slide in split]

= Another Section
#slide[Another slide]

== Sub with very long title for testing
#metadata("Short Sub") <short>
#slide[Final slide]
