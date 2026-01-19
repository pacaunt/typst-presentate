#import "../../src/themes/structured/sidebar.typ": template, slide
#import "../../src/render.typ": pause

#show: template.with(
  title: [The Sidebar Theme],
  subtitle: [Persistent navigation for long talks],
  author: [David Hajage],
  date: [January 2026],
  side: "left",
  width: 20%,
  sidebar-color: rgb("#1a2a6c"),
  active-color: rgb("#f7b731"),
  // Enable auto-title to simplify slide creation
  mapping: (section: 1, subsection: 2),
  auto-title: true,
)

= Introduction

== Theme Overview
#slide[
  This theme provides a persistent sidebar (left or right) containing a progressive outline of your presentation.
  
  The presentation title is automatically displayed at the top of the sidebar for better branding.
]

== Dynamic Tracking
#slide[
  The sidebar automatically tracks your progress through the document. 
  Items are highlighted based on your current position, and the transition engine provides a full roadmap when switching sections.
]

= Layout Options

== Sidebar Placement
#slide[
  You can control the placement and size of the sidebar:
  
  - `side`: `"left"` or `"right"`.
  - `width`: Percentage or fixed length (default `22%`).
]

== Logo Support
#slide[
  Add a logo using the `logo` parameter. It can be positioned at the `"top"` or `"bottom"` of the sidebar.
]

= Styling

== Colors & Fonts
#slide[
  Customize colors (`sidebar-color`, `active-color`, `text-color`) and typography (`text-font`, `text-size`) globally. 
  
  All elements, including the sidebar entries, scale proportionally.
]

= Conclusion

== Summary
#slide[
  The Sidebar theme is ideal for long presentations where the audience needs constant structural context.
  
  ```typ
  #import "@preview/presentate:0.2.3": sidebar, pause
  #import sidebar: template, slide

  #show: template.with(
    title: [My Presentation],
    side: "left",
  )

  #slide[ Hello World! ]
  ```
]