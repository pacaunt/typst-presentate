#import "../presentate.typ" as p
#import "../store.typ": states, set-options
#import "../components/components.typ": progressive-outline, register-heading, get-active-headings
#import "../components/title.typ": slide-title
#import "../structure.typ": structure-config, resolve-slide-title, is-role

// State to share configuration
#let config-state = state("split-config", none)

#let empty-slide(fill: white, body) = {
  set page(margin: 0pt, header: none, footer: none, fill: fill)
  p.slide(context {
    let config = config-state.get()
    let ts = if config != none and "text-size" in config { config.text-size } else { 20pt }
    set text(size: ts)
    body
  })
}

#let apply-layout(title: none, body) = context {
  let config = config-state.get()
  if config == none { return body }
  
  let primary = config.primary
  let secondary = config.secondary
  let nav-style = config.navigation-style
  let h-inset = config.header-inset
  let sec-align = config.section-align
  let subsec-align = config.subsection-align
  let show-num = config.show-heading-numbering
  
  let header-size = 0.45em
  let footer-size = 0.4em
  
  let mapping = structure-config.get().mapping
  let roles = ()
  if "part" in mapping and mapping.part != none { roles.push("part") }
  if "section" in mapping and mapping.section != none { roles.push("section") }
  if "subsection" in mapping and mapping.subsection != none { roles.push("subsection") }
  
  let header-cols = config.header-columns
  if header-cols == (1fr, 1fr) and roles.len() == 3 {
    header-cols = (1fr, 1fr, 1fr)
  }

  // Header Logic using table for equal height columns
  let header = block(width: 100%, table(
    columns: header-cols,
    inset: h-inset,
    stroke: none,
    fill: (x, y) => if calc.even(x) { primary } else { secondary },
    align: (col, row) => {
      if col == 0 { return sec-align + horizon }
      if col == roles.len() - 1 { return subsec-align + horizon }
      return center + horizon
    },
    ..roles.map(role => {
      let lvl = mapping.at(role)
      let mode = if nav-style == "all" {
        if role == "part" { "all" }
        else if role == "section" { if "part" in mapping { "current-parent" } else { "all" } }
        else if role == "subsection" { "current-parent" }
        else { "all" }
      } else { "current" }
      
      {
        set text(size: header-size, fill: white)
        progressive-outline(
          level-1-mode: if lvl == 1 { mode } else { "none" },
          level-2-mode: if lvl == 2 { mode } else { "none" },
          level-3-mode: if lvl == 3 { mode } else { "none" },
          show-numbering: show-num,
          text-styles: (
            ("level-" + str(lvl)): (
              active: (weight: "bold", fill: white),
              inactive: (weight: "regular", fill: white.transparentize(40%)),
              completed: (weight: "regular", fill: white.transparentize(40%))
            )
          ),
          spacing: (v-between-1-1: 0.4em, v-between-2-2: 0.4em, v-between-3-3: 0.4em)
        )
      }
    })
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
  let st = slide-title(resolve-slide-title(title), size: 1.2em, weight: "bold", inset: (x: 1.5em, top: 0.8em))

  // Assemble the slide
  stack(
    dir: ttb,
    header,
    st,
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
  mapping: (section: 1, subsection: 2),
  auto-title: false,
  on-part-change: none,
  on-section-change: none,
  on-subsection-change: none,
  show-all-sections-in-transition: false,
  transitions: (),
  aspect-ratio: "16-9",
  body,
  ..options,
) = {
  let trans-opts = (enabled: true, level: 2)
  if type(transitions) == dictionary { trans-opts = p.utils.merge-dicts(base: trans-opts, transitions) }

  structure-config.update(conf => (
    mapping: mapping,
    auto-title: auto-title,
    text-size: text-size,
  ))

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
  
  let mapped-levels = mapping.values()
  if 3 in mapped-levels {
    show heading.where(level: 3): it => register-heading(it)
  }

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
      level-3: (
        active: (weight: "regular", fill: white, size: 1.1em), 
        completed: (weight: "regular", fill: white.transparentize(50%), size: 1.1em),
        inactive: (weight: "regular", fill: white.transparentize(50%), size: 1.1em)
      ),
    )

    let outline-spacing = (
      indent-1: 0pt, indent-2: 1.5em, indent-3: 3em,
      v-between-1-1: 1.8em, 
      v-between-1-2: 1.5em, 
      v-between-2-1: 1.8em, 
      v-between-2-2: 0.8em, 
      v-between-2-3: 0.6em,
      v-between-3-3: 0.4em,
    )

    let l1-mode = if show-all-sections-in-transition { "all" } else { "current" }
    let l2-mode = if show-all-sections-in-transition { "all" } else { "current-parent" }
    let l3-mode = if show-all-sections-in-transition { "all" } else { "current-parent" }

      // Standard Transition Slide logic
      let default-transition(h, role) = empty-slide(fill: primary, {
        set text(fill: white)
        set align(top + left)
        v(25%)

        let get-mode(lvl) = {
          if is-role(mapping, lvl, "part") { l1-mode }
          else if role == "part" { "none" }
          else if role == "section" {
            if is-role(mapping, lvl, "section") { l2-mode }
            else if is-role(mapping, lvl, "subsection") { l3-mode }
            else { "none" }
          } else if role == "subsection" {
            if is-role(mapping, lvl, "section") { l2-mode }
            else if is-role(mapping, lvl, "subsection") { l3-mode }
            else { "none" }
          } else { "none" }
        }

        pad(left: 15%)[
          #progressive-outline(
            level-1-mode: get-mode(1),
            level-2-mode: get-mode(2),
            level-3-mode: get-mode(3),
            show-numbering: show-heading-numbering, numbering-format: "1.1 ",
            target-location: h.location(),
            text-styles: outline-styles,
            spacing: outline-spacing,
          )
        ]
        place(hide(h))
      })

  

    // Unified Transition Rule

    show heading: h => {

      register-heading(h)

      if is-role(mapping, h.level, "part") {

        if on-part-change != none { on-part-change(h) }

        else if trans-opts.enabled { default-transition(h, "part") }

        else { place(hide(h)) }

      } else if is-role(mapping, h.level, "section") {

        if on-section-change != none { on-section-change(h) }

        else if trans-opts.enabled { default-transition(h, "section") }

        else { place(hide(h)) }

      } else if is-role(mapping, h.level, "subsection") {

        if on-subsection-change != none { on-subsection-change(h) }

        else if trans-opts.enabled and trans-opts.level >= 2 { default-transition(h, "subsection") }

        else { place(hide(h)) }

      } else {

        h

      }

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