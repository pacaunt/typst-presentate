#import "../../../src/export.typ": *
#import "../../../src/themes/custom-transition.typ": template, slide, empty-slide
#import "common.typ": *

#show: template.with(
  author: [Presentate Team],
  title: [Custom Transition Demo],
  subtitle: [Unlimited Design Freedom],
  mapping: (part: 1, section: 2, subsection: 3),
  auto-title: true,
)

#part_simple_demo(slide, [Define exactly what happens when parts or sections change.])
#part_sectioned_demo(slide)
#part_nested_demo(slide)
#global_options_slides(slide)

= Custom Specific Options

== Injectable Hooks
#slide("Transition Functions")[
  Pass a function returning a slide to any change hook:
  ```typ
  on-part-change: (h) => empty-slide(fill: blue, {
    set align(center + horizon)
    text(3em, h.body)
  }),
  on-section-change: ...,
  on-subsection-change: ...
  ```
]

== Manual Overrides
#slide("Header & Footer")[
  Complete control over the slide layout:
  ```typ
  header: [ My Custom Header ],
  footer: [ Page #counter(page).display() ],
  ```
]