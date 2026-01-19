#import "../../src/themes/structured/progressive-outline.typ": template, slide
#import "../../src/render.typ": pause

#show: template.with(
  author: "David Hajage",
  title: "Progressive Outline Demo",
  subtitle: "Hierarchy-aware navigation with breadcrumbs",
  mapping: (part: 1, section: 2, subsection: 3),
  auto-title: true,
)

= Introduction

== Theme Philosophy
#slide[
  The *Progressive Outline* theme focuses on document progression. 
  
  It features a clean layout with a dynamic breadcrumb header that shows exactly where you are in the hierarchy.
]

== Roadmap Transitions
#slide[
  Transition slides are automatically generated when moving between parts, sections, or subsections. 
]

= Dynamic Header

== Breadcrumb Support
#slide[
  The header (breadcrumb) automatically adapts to your `mapping`. 
  
  It can display up to 3 levels: Part, Section, and Subsection.
]

= Conclusion

== Summary
#slide[
  The Progressive Outline theme is perfect for clean, professional presentations.
  
  ```typ
  #import "@preview/presentate:0.2.3": `progressive-outline`, pause
  #import `progressive-outline`: template, slide

  #show: template.with(
    title: [My Presentation],
  )

  #slide[ Hello World! ]
  ```
]
