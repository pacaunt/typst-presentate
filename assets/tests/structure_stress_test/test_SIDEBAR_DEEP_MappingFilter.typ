
#import "../../../src/themes/structured/sidebar.typ": template, slide

#show: template.with(
  title: [Deep Test: Sidebar: Mapping Filter (L1 only)],
  author: [Gemini Agent],
  mapping: (section: 1), numbering: "1."
)

#slide("CONTEXTE")[
  *Test :* Sidebar: Mapping Filter (L1 only)
  *Attendu :* Sidebar montre uniquement '1. Section Test'. La sous-section est masquée.
]

= Section 1
#slide[Slide 1.0]
== Subsection 1.1
#slide[Slide 1.1]
= Section 2
== Subsection 2.1
#slide[Slide 2.1]
