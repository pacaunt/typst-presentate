#import "../../src/presentate.typ": *
#import "../../src/themes/miniframes.typ": *
#import "../../src/render.typ": pause

#show: doc => template(doc,
  title: [The Miniframes Theme],
  subtitle: [Navigation bar with progress tracking],
  author: [David Hajage],
  color: rgb("#1a5fb4"),
  navigation: (
    style: "grid",
    show-subsection-titles: true,
    marker-shape: "circle",
    inset: (x: 2em, y: 1.2em),
  ),
  transitions: (
    enabled: true,
    level: 2
  )
)

= Introduction

== What is this theme?
#slide[
  The *Miniframes* theme provides a navigation bar at the top or bottom of every slide.
  
  It is inspired by classic LaTeX Beamer themes (like *Frankfurt* or *Berlin*) where small dots represent the progress within each section.
]

== Key Features
#slide[
  - *Automatic Tracking*: Dots are generated and highlighted based on your headings.
  - *Stable Layout*: The header and footer are fixed to prevent content from jumping.
  - *Transition Slides*: Automated outlines appear between sections and subsections.
  - *Highly Customizable*: Control colors, shapes, spacing, and positioning.
]

= Layout & Zones

== The 3-Zone System
#slide("Slide Zones")[
  The theme splits every slide into three vertical zones:
  
  1.  *Navigation Zone*: Contains the miniframes bar.
  2.  *Content Zone*: Contains the slide title and body.
  3.  *Metadata Zone*: Contains the footer (author, title, page numbering).
]

== Slide Titles
#slide("Optional Titles")[
  Slide titles are now optional and strictly manual. 
  
  Unlike previous versions, the theme no longer automatically uses the subsection title as the slide title.
  
  - `#slide[...]`: No title block shown.
  - `#slide("My Title")[...]`: Displays "My Title" at the top.
]

== Font Configuration
#slide[
  The theme supports global font customization:
  
  ```typ
  text-font: "Roboto",
  text-size: 22pt
  ```
  
  The navigation bar (dots), titles, and footer will scale proportionally to the chosen text size.
]

== Navigation Position
#slide[
  By default, the bar is at the top. You can move it to the bottom:
  
  ```typ
  navigation: (
    position: "bottom"
  )
  ```
  
  In this case, it will be placed just below the footer.
]

= Navigation Options

== Compact vs Grid
#slide[
  There are two main styles for the navigation bar:
  
  - *compact*: All dots of a section are aligned on a single line.
  - *grid*: Each subsection gets its own line (current mode).
  
  ```typ
  navigation: (
    style: "grid",
    show-subsection-titles: true
  )
  ```
]

== Heading Numbering
#slide[
  You can toggle section numbering:
  
  ```typ
  show-heading-numbering: false
  ```
  
  This affects the slide titles, the navigation outlines, and the transition slides.
]

== Marker Customization
#slide[
  You can change the shape and size of the progress dots:
  
  - `marker-shape`: `"circle"` or `"square"`.
  - `marker-size`: The diameter/width of the marker.
  
  The colors are derived from the theme's main color but can be overridden.
]

== Advanced Layout
#slide[
  You can further customize the block containing the navigation bar:
  
  - *Width*: Reduce the bar's width (e.g., `width: 80%`).
  - *Radius*: Round the corners of the bar (e.g., `radius: 10pt`).
  - *Alignment*: Align the entire block (left, center, right).
  
  ```typ
  navigation: (
    width: 80%,
    radius: 10pt,
    align-mode: "center"
  )
  ```
]

= Animations

== Dots & Pauses
#slide("Stable Navigation")[
  Even when using animations like `pause`, the navigation bar remains stable.
  
  #pause[
    Note that a slide with pauses only counts as *one* dot in the navigation bar.
  ]
  #pause[
    This ensures that the bar reflects the *logical* progress of your talk, not the number of click-steps.
  ]
]

= Conclusion

== Getting Started
#slide("Summary")[
  Simply import the theme and start using standard headings:
  
  - `=` for Sections (H1)
  - `==` for Subsections (H2)
  - `#slide("Title")[...]` for your content.
]