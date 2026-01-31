
#import "../../../src/themes/structured/sidebar.typ": template, slide

#show: template.with(
  title: [Deep Test: Sidebar: No Numbering],
  author: [Gemini Agent],
  outline-options: (show-numbering: false), numbering: "1.1"
)

#slide("CONTEXTE")[
  *Test :* Sidebar: No Numbering
  *Attendu :* Titres: '1. Section'. Sidebar: 'Section' (sans numéro).
]

= Section 1
#slide[Slide 1.0]
== Subsection 1.1
#slide[Slide 1.1]
= Section 2
== Subsection 2.1
#slide[Slide 2.1]
