#import "../../../src/export.typ": *
#import "../../../src/themes/sidebar.typ": template, slide
#import "common.typ": *

#show: template.with(
  title: [Sidebar Theme Demo],
  subtitle: [Structural & Persistent],
  author: [Presentate Team],
  mapping: (part: 1, section: 2, subsection: 3),
  auto-title: true,
  side: "left",
  sidebar-color: rgb("#2c3e50"),
  active-color: rgb("#f39c12"),
)

#part_simple_demo(slide, [The Sidebar theme provides a persistent navigation guide.])
#part_sectioned_demo(slide)
#part_nested_demo(slide)
#global_options_slides(slide)

= Sidebar Specific Options

== Layout & Dimensions
#slide("Geometric Setup")[
  ```typ
  side: "left",      // or "right"
  width: 22%,        // Sidebar width
  logo: image(...),  // Content for the sidebar
  logo-position: "top" // or "bottom"
  ```
]

== Visual Customization
#slide("Color Palette")[
  ```typ
  sidebar-color: rgb("#2c3e50"), // Bar background
  main-color: white,             // Content background
  text-color: white,             // Inactive text
  active-color: orange,          // Active text
  title-color: navy,             // Main headings
  ```
]

== Engine Tuning
#slide("Advanced Outline")[
  The `outline-options` dictionary configures the underlying engine:
  ```typ
  outline-options: (
    level-1-mode: "all",
    spacing: (v-between-1-1: 1.5em)
  )
  ```
]
