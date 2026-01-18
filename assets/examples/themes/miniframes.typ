#import "../../../src/export.typ": *
#import "../../../src/themes/miniframes.typ": template, slide
#import "common.typ": *

#show: template.with(
  title: [Miniframes Theme Demo],
  subtitle: [Situational Awareness with Dots],
  author: [Presentate Team],
  mapping: (part: 1, section: 2, subsection: 3),
  auto-title: true,
  transitions: (enabled: true, level: 3),
  color: rgb("#1a5fb4"),
  navigation: (
    style: "grid",
    marker-shape: "circle",
  )
)

#part_simple_demo(slide, [Miniframes uses dots to show progress within sections.])
#part_sectioned_demo(slide)
#part_nested_demo(slide)
#global_options_slides(slide)

= Miniframes Specific Options

== The Navigation Object
#slide("The Bar Config")[
  The `navigation` dictionary groups all bar settings:
  ```typ
  navigation: (
    style: "grid",       // or "compact"
    position: "top",     // or "bottom"
    dots-align: "left",  // or "center", "right"
    marker-shape: "circle", // or "square"
    marker-size: 5pt,
  )
  ```
]

== Title Visibility
#slide("Heading Control")[
  Control which structural levels appear as text in the bar:
  ```typ
  show-level1-titles: true, // Show Parts
  show-level2-titles: true, // Show Sections
  ```
]
