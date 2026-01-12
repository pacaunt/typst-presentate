#import "../../src/presentate.typ": *
#import "../../src/themes/sidebar.typ": template, slide

#show: doc => template(
  doc, 
  title: [The Sidebar Theme],
  subtitle: [A "Hannover/Marburg" inspired theme for Presentate],
  author: [David Hajage],
  date: [January 2026],
  side: "left",
  width: 20%,
  sidebar-color: rgb("#1a2a6c"),
  active-color: rgb("#f7b731"),
  text-color: rgb("#dfe6e9"),
  title-color: rgb("#1a2a6c"),
  logo: box(fill: rgb("#239DAD"), inset: (x: 0.5em, y: 0.2em), radius: 0.2em, text(fill: white, weight: "bold", "typst")),
  logo-position: "bottom",
  numbering: "1.1"
)

= Introduction

#slide("The Sidebar Theme")[
  This theme provides a persistent sidebar (left or right) containing a progressive outline of your presentation.
  
  It is inspired by classic LaTeX Beamer themes like *Hannover* or *Marburg*.
  
  *Key Features:*
  - Automatic navigation tracking.
  - Fully customizable colors and dimensions.
  - Logo support.
]

#slide("How to use")[
  Simply import the theme and apply it to your document:
  
  ```typ
  #import "@preview/presentate:0.2.3": *
  #import themes.sidebar: template
  
  #show: doc => template(doc, 
    title: [My Presentation],
    side: "left", 
    sidebar-color: blue
  )
  ```
]

= Layout Options

#slide("Side & Width")[
  You can control the placement and size of the sidebar.
  
  - `side`: `"left"` (default) or `"right"`.
  - `width`: The width of the sidebar column (e.g., `20%`, `4cm`). Default is `22%`.
  
  ```typ
  #show: doc => template(doc, 
    side: "right", 
    width: 25%
  )
  ```
]

#slide("Logo Positioning")[
  Add a logo to your sidebar using the `logo` parameter.
  
  Control its position with `logo-position`:
  - `"top"` (default): Puts the logo at the top.
  - `"bottom"`: Puts the logo at the very bottom.
  
  ```typ
  logo: image("logo.png", width: 80%),
  logo-position: "bottom"
  ```
]

= Styling

#slide("Colors")[
  Customize the look to match your brand identity.
  
  - `sidebar-color`: Background of the sidebar.
  - `main-color`: Background of the content area.
  - `title-color`: Color of headings.
  
  *Sidebar Text Colors:*
  - `text-color`: Color for inactive items.
  - `active-color`: Color for the current item.
]

#slide("Numbering")[
  Enable or disable section numbering globally.
  
  - `numbering`: A format string (e.g., `"1.1"`) or `none`.
  
  ```typ
  numbering: "1.1" // Default
  numbering: none  // No numbers
  ```
]

= Advanced

#slide("Outline Configuration")[
  The sidebar uses the `progressive-outline` module internally.
  
  You can override advanced options via the `outline-options` dictionary:
  
  ```typ
  outline-options: (
    level-1-mode: "current", 
    spacing: (indent-2: 0pt)
  )
  ```
]

= Content Flow

#slide("Multi-slide Topic")[
  Sometimes a single topic is too long for one slide.
  
  This is the *first slide* of this section. 
  
  Look at the sidebar: *"Multi-slide Topic"* is highlighted.
]

#slide(none)[
  This is the *second slide* of the same topic.
  
  We called `#slide(none)[...]` (or just passed body content) so no new heading was created.
  
  *Result:* The sidebar *still* highlights "Multi-slide Topic".
]

#slide(none)[
  This is the *third slide*.
  
  The context remains preserved across pages until you define a new section or slide title.
]

#slide("Enjoy!")[
  Start creating beautiful presentations with Typst and Presentate.
]
