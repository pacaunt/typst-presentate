#import "../../src/export.typ": *
#import "../../src/themes/structured/minimal.typ": slide, template, empty-slide
#import components: get-active-headings, progressive-outline

// --- TRANSITION HELPERS (Copied from example-custom-transition.typ) ---

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
  title: [Minimal + Custom Hooks],
  subtitle: [Combining content focus with bespoke roadmaps],
  author: [Presentate Team],
  
  // 1. Enabling custom logic via Hooks
  on-part-change: my-section-transition,
  on-section-change: my-subsection-transition,
  
  // 2. Consistent numbering options
  show-heading-numbering: true,
  numbering-format: "1.1.1",
  
  // 3. Mapping levels to roles
  // Level 3 (subsection) will now be used for slide titles
  mapping: (part: 1, section: 2, subsection: 3),
  
  // 4. Limit automatic transitions to levels 1 and 2
  transitions: (max-level: 2),
  
  auto-title: true,
)

= Theme Synergy

== The Best of Both Worlds
=== Clean Canvas
#slide[
  This example uses the `minimal` theme, which provides a clean canvas without persistent UI elements (no sidebars, headers, or footers).
]

=== Bespoke Transitions
#slide[
  We've injected the complex transition slides from the `custom-transition` example using *Hooks*.
]

== How Hooks Overlap
=== Default Engine
#slide[
  The `minimal` theme would normally use the *Unified Transition Engine* to show a simple roadmap.
]

=== Manual Override
#slide[
  By providing `on-section-change` and `on-subsection-change` functions, you override the engine's default behavior with your own logic.
]

= Configuration Details

== Injecting the Logic
#slide[
  The injection is done via the `template` parameters:
  
  ```typ
  #show: template.with(
    on-part-change: my-section-transition,
    on-section-change: my-subsection-transition,
    ...
  )
  ```
]

== Numbering Propagation
#slide[
  Even with custom hooks, the global `show-heading-numbering` and `numbering-format` options are respected.
]

== Source Code: Section Hook
#slide[
  Used for `on-part-change` (Level 1) in this mapping:
  
  ```typ
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
  ```
]

== Source Code: Subsection Hook
#slide[
  Used for `on-section-change` (Level 2) in this mapping:
  
  ```typ
  #let my-subsection-transition(h) = empty-slide({
    // ... top-left Part title and grid layout ...
    progressive-outline(
      level-1-mode: "none", level-2-mode: "current-parent",
      target-location: h.location(),
      show-numbering: h.numbering != none,
      text-styles: (level-2: (active: (fill: eastern, weight: "bold")))
    )
    // ... right column with level-3 details ...
  })
  ```
]

= Conclusion

== Summary
#slide[
  The hook system provides maximum flexibility:
  - Use `minimal` for content focus.
  - Use custom functions for high-impact transitions.
  - Maintain structural consistency via the global configuration.
]