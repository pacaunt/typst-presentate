#import "../../src/themes/structured/miniframes.typ": *

#show: template.with(
  title: "Test Miniframes",
  author: "Expert Agent",
  max-length: (level-1: 10, level-2: 5),
  use-short-title: true,
)

= Introduction
#metadata("Short Intro") <short>

== Subsection 1
#slide[Slide 1]

= Very long section title that should be truncated in the bar but not in transition
#slide[Slide 2]

== Another long subsection title
#metadata("Short Sub") <short>
#slide[Slide 3]
