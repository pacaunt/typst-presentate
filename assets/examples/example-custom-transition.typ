#import "../../src/export.typ": *
#import "../../src/themes/custom-transition.typ": slide, template, empty-slide
#import components: get-active-headings, progressive-outline

// --- TRANSITION HELPERS ---

// 1. Section Transition: A high-contrast part announcement
#let my-section-transition(h) = empty-slide(fill: eastern, {
  set text(fill: white)
  set align(center + horizon)
  let part-num = counter(heading).at(h.location()).at(0)
  text(size: 1.2em, white.transparentize(30%), smallcaps[Part #part-num])
  v(0.5em)
  text(size: 1.8em, weight: "bold", h.body)
  v(1em)
  line(length: 40%, stroke: 0.5pt + white)
})

// 2. Subsection Transition: A functional two-column roadmap
#let my-subsection-transition(h) = {
  let active = get-active-headings(h.location())
  let is-first = counter(heading).at(h.location()).at(1, default: 1) == 1
  
  // Design: Title at top-left, Navigation on left, Details on right
  empty-slide({
    if active.h1 != none {
      let h1-num = if h.numbering != none { numbering("1", ..active.h1.counter) + " " } else { "" }
      place(top + left, pad(left: 2cm, top: 1.5cm)[
        #text(size: 1.1em, fill: luma(150), weight: "bold", smallcaps([#h1-num#active.h1.body]))
      ])
    }

    set align(center + horizon)
    grid(
      columns: (1fr, 1fr), align: top,
      // Left Column: The overall plan of the current part
      pad(right: 2.5em, left: 2cm)[
        #set align(left)
        #text(size: 0.8em, weight: "bold", luma(150), [OUTLINE])
        #v(1.5em)
        #context {
          let sub = store.states.get().at(0).subslide
          let show-highlight = not (is-first and sub == 1)
          progressive-outline(
            level-1-mode: "none", level-2-mode: "current-parent",
            target-location: if show-highlight { h.location() } else { active.h1.location },
            // We can check the heading numbering directly from the heading in cache
            show-numbering: h.numbering != none,
            text-styles: (level-2: (
              active: (fill: eastern, weight: "bold", size: 1.2em),
              completed: (fill: if show-highlight { luma(180) } else { black }, weight: "regular", size: 1.2em),
              inactive: (fill: black, weight: "regular", size: 1.2em)
            )),
            spacing: (v-between-2-2: 1em)
          )
        }
      ],
      // Right Column: The roadmap of the upcoming subsection
      block(stroke: (left: 2pt + luma(220)), inset: (left: 2.5em, right: 2cm))[
        #set align(left)
        #text(size: 0.8em, weight: "bold", luma(150), [SECTION STRUCTURE])
        #v(1.5em)
        #uncover(if is-first { 2 } else { 1 })[
          #progressive-outline(
            level-1-mode: "none", level-2-mode: "none", level-3-mode: "current-parent",
            target-location: h.location(),
            show-numbering: h.numbering != none,
            text-styles: (level-3: (active: (fill: black, weight: "bold"), inactive: (fill: luma(120)))),
            spacing: (v-between-3-3: 0.6em)
          )
        ]
      ]
    )
  })
}

// --- THEME SETUP ---

#show: template.with(
  author: "Presentate User",
  title: "Custom Transition Theme",
  subtitle: "Guide to intermediate slide customization",
  on-section-change: my-section-transition,
  on-subsection-change: my-subsection-transition,
  show-heading-numbering: true,
)

= Theme Fundamentals

== The Purpose of Hooks
=== Bridging sections
#slide[
  The `custom-transition` theme is designed to handle the slides that appear between your sections and subsections.
  
  By default, it shows a standard outline, but you can override this behavior using *hooks*.
]

=== Hook parameters
#slide[
  The `template` accepts three main hooks:
  - `on-section-change`: Triggers on Level 1 headings.
  - `on-subsection-change`: Triggers on Level 2 headings.
  - `on-subsubsection-change`: Triggers on Level 3 headings.
]

== Creating a Transition
=== Defining the function
#slide[
  A transition function receives the current heading as an argument and returns the content to display.
  
  ```typ
  #let my-transition(h) = slide[ ... ]
  ```
]

=== Multi-step slides
#slide[
  Since transitions are standard slides, they can include animations (pauses, uncover) to guide the audience through your roadmap.
]

= Practical Application

== Numbering Control
=== Toggle Numbering
#slide[
  The `show-heading-numbering` option affects:
  - Slide titles (top of the page)
  - Breadcrumb (header)
  - Default transition slides
  
  Try setting it to `false` in the `template` to hide all structure numbers.
]

== Layout Techniques
=== Using Grids
#slide[
  Transitions often benefit from multi-column layouts to provide both global context (navigation) and local details (current section structure).
]

=== High-Impact Visuals
#slide[
  You can use `set page(fill: ...)` within your hook to create high-contrast slides that clearly signal a major change in the presentation flow.
]

= Empty Sections Test

== A section without details
#slide[
  This subsection has no Level 3 headings. 
  The transition slide will show an empty "Section Structure" column.
]

= Styling

== Font Configuration
#slide[
  You can control the global font settings via the template arguments:
  
  ```typ
  #show: template.with(
    text-font: "Roboto", // Default "Lato"
    text-size: 22pt,     // Default 20pt
    ...
  )
  ```
  
  This automatically scales headers, footers, and other UI elements.
]
