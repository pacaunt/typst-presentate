#import "../../../src/export.typ": *
#import "../../../src/themes/split.typ": template, slide
#import "common.typ": *

#show: template.with(
  title: [Split Theme Demo],
  subtitle: [Symmetric Header Navigation],
  author: [Presentate Team],
  mapping: (part: 1, section: 2, subsection: 3),
  auto-title: true,
  primary: rgb("#003366"),
  secondary: rgb("#336699"),
)

#part_simple_demo(slide, [The Split theme offers dynamic header columns.])
#part_sectioned_demo(slide)
#part_nested_demo(slide)
#global_options_slides(slide)

= Split Specific Options

== Colors & Hierarchy
#slide("The Split Header")[
  The header colors and behavior are highly configurable:
  ```typ
  primary: rgb("#003366"),   // Main color
  secondary: rgb("#336699"), // Secondary color
  navigation-style: "all",   // or "current"
  ```
]

== Geometry
#slide("Columns & Inset")[
  Control the width and padding of the header zones:
  ```typ
  header-columns: (1fr, 1fr, 1fr), // Manual widths
  header-inset: 1.5em,             // Inside padding
  section-align: left,             // Alignment of L1
  subsection-align: right,          // Alignment of L3
  ```
]
