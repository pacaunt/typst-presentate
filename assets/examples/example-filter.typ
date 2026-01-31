#import "../../src/presentate.typ": *
#import "../../src/themes/structured/sidebar.typ": template, slide

#show: template.with(
  title: [Filtering Demo],
  subtitle: [Hiding sections from the outline],
  author: [David Hajage],
  side: "left",
  width: 20%,
  sidebar-color: rgb("#2d3436"),
  active-color: rgb("#00cec9"),
  text-color: rgb("#dfe6e9"),
  numbering: "1.1",
  // Configure the filter here
  outline-options: (
    // Filter out any heading with the label <secret>
    filter: h => h.label != <secret>
  )
)

= Public Introduction
#slide("Intro")[
  This section is visible in the sidebar.
]

= Secret Section <secret>
#slide("Hidden Slide")[
  This section title ("Secret Section") should *NOT* appear in the sidebar.
  
  However, the slide itself is part of the presentation.
]

= Conclusion
#slide("Final Words")[
  This section is visible again.
  
  The numbering might skip the secret section if Typst's native numbering counts it, 
  but the sidebar will simply ignore it.
]
