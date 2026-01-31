#import "../../src/export.typ": * 
#import themes.split: template, slide

#set heading(numbering: "I.a.1.")

#show: template.with(
  title: [The Split Theme],
  subtitle: [Dual-column header for structural awareness],
  author: [David Hajage],
  navigation-style: "all",
  primary: rgb("#003366"),
  secondary: rgb("#336699"),
  show-heading-numbering: true,
  numbering-format: auto,
  mapping: (section: 1, subsection: 2),
  auto-title: true,
)

= Introduction

== Theme Philosophy
#slide[
  The *Split* theme offers a dual-column header:
  
  - *Left side*: Displays the sections.
  - *Right side*: Displays subsections of the current section.
]

== Transitions
#slide[
  Integrated transition slides provide a roadmap between sections and subsections, helping the audience stay oriented.
]

= Configuration

== Navigation Style
#slide[
  Toggle between two modes:
  
  - `navigation-style: "all"`: Shows all siblings (Copenhagen style).
  - `navigation-style: "current"`: Shows only the active context (Cambridge style).
]

== Layout
#slide[
  Customize the header proportions using `header-columns` (e.g., `(2fr, 1fr)`) and alignments (`section-align`, `subsection-align`).
]

= Conclusion

== Summary
#slide[
  Perfect for professional talks with a clear hierarchical structure.
  
  ```typ
  #import "@preview/presentate:0.2.3": split, pause
  #import split: template, slide

  #show: template.with(
    title: [My Presentation],
    primary: rgb("#003366"),
  )

  #slide[ Hello World! ]
  ```
]