#import "../../src/themes/structured/minimal.typ": template, slide

#show: template.with(
  title: [The Minimal Theme],
  subtitle: [Content-first design with smart transitions],
  author: [David Hajage],
  auto-title: true,
  show-heading-numbering: true,
  text-font: "Fira Sans",
  text-size: 28pt,
  show-all-sections-in-transition: true,
  transitions: (
    background: rgb("#2d3436"),
    style: (active-color: white)
  )
)

= Introduction

== Theme Philosophy
#slide[
  The *Minimal* theme is designed for presenters who want zero distractions.
  
  There are no persistent headers, sidebars, or footers. The entire slide is your canvas.
]

== Transitions
#slide[
  Despite its simplicity, it fully integrates the *Unified Transition Engine*. 
  
  Roadmap slides appear automatically between sections, providing context without cluttering your content slides.
]

= Features

== Full-screen Focus
#slide[
  By removing all navigation elements, this theme provides the maximum possible area for your text, images, and diagrams.
]

== Dynamic Titling
#slide[
  With `auto-title: true`, your headings automatically become slide titles, keeping your code clean and your slides consistent.
]

= Customization

== Hooks Support
#slide[
  You can still use hooks to create custom transition slides:
  
  ```typ
  #show: template.with(
    on-section-change: (h) => {
      empty-slide(fill: black)[ #h.body ]
    }
  )
  ```
]

= Conclusion

== Summary
#slide[
  Minimal is the "clean slate" theme of Presentate.
  
  ```typ
  #import "@preview/presentate:0.2.3": minimal
  #import minimal: template, slide

  #show: template.with(
    title: [My Presentation],
  )

  #slide[ Focus on what matters. ]
  ```
]
