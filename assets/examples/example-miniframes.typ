#import "../../src/themes/structured/miniframes.typ": template, slide
#import "../../src/render.typ": pause

#show: template.with(
  title: [The Miniframes Theme],
  subtitle: [A deep dive into structured navigation],
  author: [David Hajage],
  color: rgb("#1a5fb4"),
  // We use 3 levels to demonstrate the full power of the navigation bar
  mapping: (part: 1, section: 2, subsection: 3),
  show-heading-numbering: true,
  numbering-format: "1-1-a",
  navigation: (
    style: "grid",
    show-level2-titles: true,
    marker-shape: "circle",
    inset: (x: 2em, y: 1.2em),
  ),
  transitions: (
    max-level: 3,
  ),
  auto-title: true,
)

= Introduction

== Theme Overview
#slide[
  The *Miniframes* theme provides a navigation bar at the top or bottom of every slide.
  
  It uses small dots to represent the progress within each structural unit, ensuring the audience always knows where you are in your presentation.
]

== Roadmap Transitions
#slide[
  The transition engine automatically generates roadmap slides when the document structure changes. 
  
  By default, it highlights the active section while showing its context. This is fully configurable via the `transitions` dictionary.
]

= Hierarchy & Structure

== 3-Level Support
#slide("Advanced Hierarchy")[
  Miniframes supports up to 3 levels of hierarchy:
  
  1.  *Level 1 (Part)*: Acts as a global group title in the bar.
  2.  *Level 2 (Section)*: Acts as a row title in the bar.
  3.  *Level 3 (Subsection)*: Groups of dots separated by a vertical bar `|`.
]

== Automatic Titling
#slide[
  With `auto-title: true`, the theme automatically uses the current heading as the slide title.
  
  This reduces repetition and ensures your slides are always correctly labeled according to your document structure.
]

= Navigation Customization

== Compact vs Grid
#slide[
  The navigation bar offers two layout styles:
  
  - *compact*: All dots of a section are squeezed into a single line.
  - *grid*: Each unit (Section or Subsection) gets its own line for better clarity.
]

== Marker Shapes
#slide[
  Progress indicators can be customized:
  
  - `marker-shape`: Choose between `"circle"` or `"square"`.
  - `marker-size`: Adjust the size of the indicators.
]

== Alignment Options
#slide[
  You have fine-grained control over alignment:
  
  - `align-mode`: Aligns the entire navigation block (left, center, right).
  - `dots-align`: Aligns the dots *within* their respective columns.
]

== Custom Colors
#slide[
  Beyond the primary theme color, you can override specific colors:
  
  ```typ
  navigation: (
    fill: rgb("#2d3436"),
    active-color: yellow,
    inactive-color: gray,
    text-color: white
  )
  ```
]

= Layout & Spacing

== Spacing Control
#slide[
  Control the rhythm of the navigation bar:
  
  - `gap`: Horizontal space between section groups.
  - `line-spacing`: Vertical space between titles and dots.
  - `inset`: Internal padding of the navigation block.
]

== Position & Marges
#slide[
  The bar can be at the `"top"` or `"bottom"`. 
  
  When in `"bottom"`, the theme automatically adds top margin to the slide titles to maintain a balanced visual composition.
]

= Conclusion

== Summary
#slide[
  The Miniframes theme is the most sophisticated choice for long, technical, or highly structured presentations.
  
  ```typ
  #import "@preview/presentate:0.2.3": miniframes, pause
  #import miniframes: template, slide

  #show: template.with(
    title: [My Presentation],
  )

  #slide[ Hello World! ]
  ```
]