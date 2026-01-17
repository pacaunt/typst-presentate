#import "../../src/presentate.typ": *
#import "../../src/themes/split.typ": *

#show: template.with(
  title: [The Split Theme],
  subtitle: [Inspired by Copenhagen & Cambridge],
  author: [David Hajage],
  navigation-style: "all", // Change to "current" for a minimalist look
  primary: rgb("#003366"),
  secondary: rgb("#336699"),
  text-size: 22pt,         // Global text size
  transitions: (enabled: false), 
)

= Introduction

== Motivation
#slide("Motivation")[
  The *Split* theme offers a dual-column header for clear structural awareness.
  
  - *Left side*: All sections (H1).
  - *Right side*: Subsections (H2) of the current section.
]

== Navigation Styles
#slide("Navigation Styles")[
  You can toggle between two navigation styles in the template:
  
  - `navigation-style: "all"`: Full overview (Beamer Copenhagen style).
  - `navigation-style: "current"`: Focus on current context only (Beamer Cambridge style).

  ```typ
  #show: doc => template(doc,
    navigation-style: "current",
    ...
  )
  ```
]

= Features

== Font Configuration
#slide("Font Configuration")[
  You can easily change the global font and size. Headers and footers scale automatically.
  
  ```typ
  #show: doc => template(doc,
    text-font: "Roboto", // Default is "Lato"
    text-size: 22pt,     // Default is 20pt
    ...
  )
  ```
  
  In this presentation, we are using `22pt`.
]

== Auto-scaling UI
#slide("Auto-scaling UI")[
  The header and footer sizes are defined using relative units (`em`).
  
  This means they automatically scale when you change the `text-size` in the template configuration, maintaining a consistent visual balance without manual adjustment.
]

== Visual Layout
#slide("Visual Layout")[
  The slide is organized into fixed areas:
  - *Header*: Split into two thematic colors.
  - *Body*: Large area for content with an optional manual title.
  - *Footer*: Three-part bar with author, title, and numbering.
]

== Automatic Transitions
#slide("Transitions")[
  Section changes automatically trigger a high-contrast transition slide. 
  
  Configure this via the `transitions` dictionary:
  
  ```typ
  transitions: (
    enabled: true, // Toggle on/off
    level: 2       // 1: Sections, 2: Sections & Subsections
  )
  ```
]

== Header Proportions
#slide("Header Columns")[
  By default, the header is split 50/50. You can change this using `header-columns`:
  
  ```typ
  header-columns: (2fr, 1fr)
  ```
  
  This is useful if your section names are much longer than your subsection names.
]

== Header Alignment
#slide("Header Alignment")[
  You can control the alignment of the text in the header columns:
  
  ```typ
  section-align: right,    // Default
  subsection-align: left,  // Default
  ```
  
  For example, to center everything:
  ```typ
  section-align: center,
  subsection-align: center,
  ```
]

== Heading Numbering
#slide("Numbering")[
  Toggle the display of numbers in the header navigation:
  
  ```typ
  show-heading-numbering: false
  ```
  
  By default, it is set to `true`.
]

#slide("Manual Title Demo")[
  By default, slides have *no title* (empty space). 
  
  If you want a title, provide it as the first argument:
  `#slide("My Title")[...]`.
]

#slide[
  This slide has *no title* because we called `#slide[...]` without a string argument.
  
  Note how the header still highlights the current subsection ("Automatic Transitions") regardless of the slide's own title.
]

= Deep Hierarchy

== Subsection A
#slide("Part A")[Content for Subsection A]

== Subsection B
#slide("Part B")[Content for Subsection B]

== Subsection C
#slide("Part C")[Content for Subsection C]

= Conclusion

#slide("Summary")[
  The Split theme is perfect for long presentations where keeping track of the global plan is essential.
]
