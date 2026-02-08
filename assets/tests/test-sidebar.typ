#import "../../src/themes/structured/sidebar.typ": *

#show: template.with(
  title: "Test Sidebar",
  author: "Expert Agent",
  max-length: 12,
  use-short-title: true,
)

= Introduction
#metadata("Intro") <short>

== Detailed overview of the project
#slide[Overview slide]

= Implementation
#metadata("Impl.") <short>

== Some very long subsection title that must be truncated in sidebar
#slide[Truncation test]
