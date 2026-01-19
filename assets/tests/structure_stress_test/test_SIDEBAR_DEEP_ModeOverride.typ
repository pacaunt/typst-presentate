
#import "../../../src/themes/structured/sidebar.typ": template, slide

#show: template.with(
  title: [Deep Test: Sidebar: Mode Override (Accordion)],
  author: [Gemini Agent],
  outline-options: (level-2-mode: "current-parent")
)

#slide("CONTEXTE")[
  *Test :* Sidebar: Mode Override (Accordion)
  *Attendu :* Au début, seules les sections sont visibles. Les sous-sections n'apparaissent que lorsqu'on entre dans leur section parent.
]

= Section 1
#slide[Slide 1.0]
== Subsection 1.1
#slide[Slide 1.1]
= Section 2
== Subsection 2.1
#slide[Slide 2.1]
