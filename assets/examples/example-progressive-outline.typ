#import "../../src/export.typ": *
#import "../../src/themes/progressive-outline.typ": slide, template

#show: template.with(
  author: "David",
  title: "Progressive Outline Demo",
  subtitle: "Show a progressive-outline use case",
  show-all-sections-in-transition: true,
  // aspect-ratio: "4-3" // Change aspect ratio to 4:3
)

= Introduction to Physics

== Classical Mechanics
#slide[
  Welcome to Classical Mechanics. This is the first slide.
]

=== Newton's Laws
#slide[
  Newton's laws are the foundation.
  - First law: Inertia
  - Second law: F=ma
]

#slide(none)[
  *This is a titleless slide.*
  
  It was generated with `#slide(none)[...]`. 
  Even though we are still in the Newton's Laws subsubsection, the header title has disappeared.
]

=== Lagrangian Mechanics
#slide[
  A more abstract formulation using energy.
]

== Electromagnetism
#slide[
  Maxwell's equations rule here.
]

= Modern Physics

== Relativity
#slide[
  Things get weird near the speed of light.
]

=== Special Relativity
#slide[
  - Time dilation
  - Length contraction
  - E = mc²
]

=== General Relativity
#slide[
  Gravity is curvature of spacetime.
]

== Quantum Mechanics
#slide[
  Probabilities and wavefunctions.
]

= Future Research
#slide[
  This section has no subsections. 
]
