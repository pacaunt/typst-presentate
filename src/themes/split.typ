#import "../presentate.typ" as p
#import "../store.typ": states, set-options
#import "../components/progressive-outline.typ": progressive-outline, register-heading, get-active-headings

// State to share configuration
#let config-state = state("split-config", none)

#let empty-slide(fill: white, ..args) = context {
  let config = config-state.get()
  let ts = if config != none and "text-size" in config { config.text-size } else { 20pt }
  set page(margin: 0pt, header: none, footer: none, fill: fill)
  set text(size: ts)
  p.slide(..args)
}

#let apply-layout(title: none, body) = context {
  let config = config-state.get()
  if config == none { return body }
  
  let primary = config.primary
  let secondary = config.secondary
  let nav-style = config.navigation-style
  let header-cols = config.header-columns
  let h-inset = config.header-inset
  let sec-align = config.section-align
  let subsec-align = config.subsection-align
  let show-num = config.show-heading-numbering
  
  let header-size = 0.45em
  let footer-size = 0.4em
  
  // Header Logic using table for equal height columns
  let header = block(width: 100%, table(
    columns: header-cols,
    inset: h-inset,
    stroke: none,
    fill: (x, y) => if x == 0 { primary } else { secondary },
    align: (col, row) => (if col == 0 { sec-align } else { subsec-align }) + horizon,
    // Left: Sections
    {
      set text(size: header-size, fill: white)
      progressive-outline(
        level-1-mode: if nav-style == "all" { "all" } else { "current" },
        level-2-mode: "none",
        level-3-mode: "none",
        show-numbering: show-num,
        text-styles: (
          level-1: (
            active: (weight: "bold", fill: white),
            inactive: (weight: "regular", fill: white.transparentize(40%)),
            completed: (weight: "regular", fill: white.transparentize(40%))
          )
        ),
        spacing: (v-between-1-1: 0.4em)
      )
    },
    // Right: Subsections
    {
      set text(size: header-size, fill: white)
      progressive-outline(
        level-1-mode: "none",
        level-2-mode: if nav-style == "all" { "current-parent" } else { "current" },
        level-3-mode: "none",
        show-numbering: show-num,
        text-styles: (
          level-2: (
            active: (weight: "bold", fill: white),
            inactive: (weight: "regular", fill: white.transparentize(40%)),
            completed: (weight: "regular", fill: white.transparentize(40%))
          )
        ),
        spacing: (v-between-2-2: 0.4em)
      )
    }
  ))

  // Footer Logic
  let footer = block(width: 100%, {
    set text(size: footer-size, fill: white)
    grid(
      columns: (1fr, 1fr, 1fr),
      block(fill: primary, width: 100%, inset: 0.6em, align(center, config.author)),
      block(fill: secondary, width: 100%, inset: 0.6em, align(center, config.title)),
      block(fill: primary, width: 100%, inset: 0.6em, align(center, counter(page).display("1 / 1", both: true)))
    )
  })

  // Title Logic
  let slide-title = if title != none {
    block(width: 100%, inset: (x: 1.5em, top: 0.8em), text(weight: "bold", size: 1.2em, title))
  } else { none }

  // Assemble the slide
  stack(
    dir: ttb,
    header,
    slide-title,
    block(width: 100%, inset: (x: 1.5em, y: 1em), {
      show heading: none
      body
    }),
    v(1fr),
    footer
  )
}

#let slide(..args) = {
  let pos = args.pos()
  let named = args.named()
  if pos.len() == 1 {
    p.slide(..named, apply-layout(pos.at(0)))
  } else {
    p.slide(..named, apply-layout(title: pos.at(0), pos.at(1)))
  }
}

#let template(
  title: none,
  subtitle: none,
  author: none,
  date: datetime.today().display(),
  primary: rgb("#202060"),
  secondary: rgb("#404090"),
  text-font: "Lato",
  text-size: 20pt,
  navigation-style: "all", // "all" or "current"
  header-columns: (1fr, 1fr),
  header-inset: (x: 1.5em, y: 0.8em),
  section-align: right,
  subsection-align: left,
  show-heading-numbering: true,
  show-all-sections-in-transition: false,
  transitions: (),
  aspect-ratio: "16-9",
  body,
  ..options,
) = {
  let trans-opts = (enabled: true, level: 1)
  if type(transitions) == dictionary { trans-opts = p.utils.merge-dicts(base: trans-opts, transitions) }

  config-state.update((
    primary: primary,
    secondary: secondary,
    navigation-style: navigation-style,
    header-columns: header-columns,
    header-inset: header-inset,
    section-align: section-align,
    subsection-align: subsection-align,
    show-heading-numbering: show-heading-numbering,
    title: title,
    author: author,
    text-size: text-size,
  ))

  set page(paper: "presentation-" + aspect-ratio, margin: 0pt, header: none, footer: none)
  set text(size: text-size, font: text-font)

  // Rule to record EVERYTHING including what's handled by other rules
  show heading: it => register-heading(it) + it
  
  show heading: set text(size: 1em, weight: "regular")
  set heading(outlined: true, numbering: (..nums) => {
    if show-heading-numbering and nums.pos().len() < 3 { numbering("1.1", ..nums) }
  })
  
  show heading.where(level: 3): it => register-heading(it)

  let outline-styles = (
    level-1: (
      active: (weight: "bold", fill: white, size: 1.1em), 
      completed: (weight: "bold", fill: white.transparentize(50%), size: 1.1em),
      inactive: (weight: "bold", fill: white.transparentize(50%), size: 1.1em)
    ),
    level-2: (
      active: (weight: "regular", fill: white, size: 1.1em), 
      completed: (weight: "regular", fill: white.transparentize(50%), size: 1.1em),
      inactive: (weight: "regular", fill: white.transparentize(50%), size: 1.1em)
    ),
  )

  let outline-spacing = (
    indent-1: 0pt, indent-2: 1.5em,
    v-between-1-1: 1.8em, 
    v-between-1-2: 1.5em, 
    v-between-2-1: 1.8em, 
    v-between-2-2: 0.8em, 
  )

  let l1-mode = if show-all-sections-in-transition { "all" } else { "current" }

  // --- H1 Transition ---
  show heading.where(level: 1): h => {
    register-heading(h)
    if trans-opts.enabled {
      empty-slide(fill: primary, {
        set text(fill: white)
        v(25%)
        pad(left: 15%)[
          #progressive-outline(
            level-1-mode: l1-mode, 
            level-2-mode: "current-parent",
            show-numbering: show-heading-numbering, numbering-format: "1.1 ",
            target-location: h.location(),
            text-styles: (
              level-1: outline-styles.level-1,
              // Subsections are NORMAL (white) during chapter transition
              level-2: (
                active: (weight: "regular", fill: white, size: 1.1em), 
                inactive: (weight: "regular", fill: white, size: 1.1em)
              )
            ),
            spacing: outline-spacing,
          )
        ]
      })
    } else { place(hide(h)) }
  }

  // --- H2 Transition ---
  show heading.where(level: 2): h => {
    register-heading(h)
    if trans-opts.enabled and trans-opts.level >= 2 {
      empty-slide(fill: primary, {
        set text(fill: white)
        v(25%)
        pad(left: 15%)[
          #progressive-outline(
            level-1-mode: l1-mode,
            level-2-mode: "current-parent",
            show-numbering: show-heading-numbering, numbering-format: "1.1 ",
            target-location: h.location(),
            text-styles: outline-styles,
            spacing: outline-spacing,
          )
        ]
      })
    } else { place(hide(h)) }
  }

  // --- Title Slide ---
  empty-slide(fill: primary, {
    set std.align(center + horizon)
    set text(fill: white)
    block(text(size: 2em, weight: "bold", title), inset: (bottom: 1.2em), stroke: (bottom: 2pt + white.transparentize(50%)))
    emph(subtitle)
    linebreak()
    grid(columns: 2, author, grid.vline(), date, inset: (x: 0.5em))
  })

  set-options(..options)
  body
}