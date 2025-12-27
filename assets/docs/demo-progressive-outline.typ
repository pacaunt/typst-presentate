#import "../../src/export.typ": *
#import "../../src/themes/progressive-outline.typ": slide
#import "../../src/themes/progressive-outline.typ": template

#show: template.with(
  author: "David",
  title: "Test Progressive Outline",
)

= Chapter 1

== Section 1.1
#slide[
Content for section 1.1
]

#slide[Subsection 1.1.1][
  Content for subsection 1.1.1
]

#slide[
  This slide should carry over the title "Subsection 1.1.1".
]

== Section 1.2
#slide[
Content for section 1.2
]

= Chapter 2

== Section 2.1
#slide[
Content for section 2.1
]

== Section 2.2
#slide[
Content for section 2.2
]
