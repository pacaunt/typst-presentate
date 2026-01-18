#import "../../../src/export.typ": *
#import "../../../src/themes/progressive-outline.typ": template, slide
#import "common.typ": *

#show: template.with(
  title: [Progressive Outline Demo],
  subtitle: [Focused Roadmaps],
  author: [Presentate Team],
  mapping: (part: 1, section: 2, subsection: 3),
  auto-title: true,
  show-all-sections-in-transition: true,
)

#part_simple_demo(slide, [This theme focuses on contextual transition slides.])
#part_sectioned_demo(slide)
#part_nested_demo(slide)
#global_options_slides(slide)

= Outline Specific Options

== Transition Detail
#slide("Scope of Roadmap")[
  Control how much of the presentation is visible during transitions:
  ```typ
  show-all-sections-in-transition: true 
  // If false, only shows current parent and siblings
  ```
]

== Overrides
#slide("Manual Headers")[
  Like `custom-transition`, this theme accepts direct overrides:
  ```typ
  header: context { ... },
  footer: [Custom Text],
  ```
]
