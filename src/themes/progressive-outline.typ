#import "../presentate.typ" as p
#import "../store.typ": *
#import "../components/components.typ": progressive-outline, register-heading, get-active-headings
#import "../components/title.typ": slide-title
#import "../structure.typ": structure-config, resolve-slide-title, is-role

#let config-state = state("progressive-outline-config", none)

#let empty-slide(fill: none, body) = {
  set page(margin: 0pt, header: none, footer: none, fill: fill)
  p.slide(context {
    let ts = structure-config.get().at("text-size", default: 20pt)
    set text(size: ts)
    body
  })
}

#let slide(..args) = {
  let kwargs = args.named()
  let args = args.pos()
  let manual-title = none
  let body = none

  if args.len() == 1 {
    body = args.at(0)
  } else {
    manual-title = args.at(0)
    body = args.at(1)
  }

  p.slide(
    ..kwargs,
    [
      #slide-title(resolve-slide-title(manual-title))
      #body
    ],
  )
}

#let template(
  header: auto,
  footer: auto,
  author: [Author Name],
  title: [Title of Presentation],
  subtitle: [Some description of the presentation.],
  date: datetime.today().display(),
  aspect-ratio: "16-9",
  text-font: "Lato",
  text-size: 20pt,
  show-heading-numbering: true,
  mapping: (section: 1, subsection: 2),
  auto-title: false,
  on-part-change: none,
  on-section-change: none,
  on-subsection-change: none,
  show-all-sections-in-transition: false,
  transitions: (),
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

  if header == auto {
    header = context {
      set text(size: 0.8em)
      let active = get-active-headings(here())
      let mapping = structure-config.get().mapping
      
      let format-h(lvl-key) = {
        let lvl = mapping.at(lvl-key, default: none)
        if lvl == none { return box[] }
        let h = active.at("h" + str(lvl), default: none)
        if h == none or h.location == none { return box[] }
        let num = if show-heading-numbering {
          let idx = counter(heading).at(h.location)
          numbering("1.1", ..idx.slice(0, h.level)) + " "
        } else { "" }
        [#num#h.body]
      }
      
      let h1-c = format-h("section")
      let h2-c = format-h("subsection")
      
      let final = ()
      if h1-c != box[] { final.push(text(fill: gray, weight: "bold", h1-c)) }
      if h2-c != box[] { 
        if final.len() > 0 { final.push(text(fill: gray, " / ")) }
        final.push(text(fill: luma(150), h2-c)) 
      }
      final.join()
    }
  }

  if footer == auto {
    footer = {
      set text(fill: gray, size: 0.8em)
      author
      h(1fr)
      context counter(page).display("1")
    }
  }

  set page(paper: "presentation-" + aspect-ratio, header: header, footer: footer)
  set text(size: text-size, font: text-font)
  
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
      active: (weight: "bold", fill: eastern, size: 1.1em), 
      completed: (weight: "bold", fill: luma(180), size: 1.1em),
      inactive: (weight: "bold", fill: black, size: 1.1em)
    ),
    level-2: (
      active: (weight: "regular", fill: eastern, size: 1.1em), 
      completed: (weight: "regular", fill: luma(200), size: 1.1em),
      inactive: (weight: "regular", fill: luma(100), size: 1.1em)
    ),
    level-3: (
      active: (weight: "regular", fill: eastern, size: 1.1em), 
      completed: (weight: "regular", fill: luma(200), size: 1.1em),
      inactive: (weight: "regular", fill: luma(100), size: 1.1em)
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

  // Standard Transition Slide logic
  let default-transition(h, role) = empty-slide({
    set align(top + left)
    v(25%)
    
    let get-mode(lvl) = {
      if is-role(mapping, lvl, "part") { "current" }
      else if role == "part" { "none" }
      else if role == "section" {
        if is-role(mapping, lvl, "section") { "current" }
        else if is-role(mapping, lvl, "subsection") { "current-parent" }
        else { "none" }
      } else if role == "subsection" {
        if is-role(mapping, lvl, "section") { "current" }
        else if is-role(mapping, lvl, "subsection") { "current-parent" }
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
  empty-slide({
    set align(center + horizon)
    block(text(size: 2em, weight: "bold", title), inset: (bottom: 1.2em), stroke: (bottom: 2pt + eastern))
    emph(subtitle)
    linebreak()
    grid(columns: 2, author, grid.vline(), date, inset: (x: 0.5em))
  })

  // --- Global Outline (Classic) ---
  p.slide([
    #block(width: 100%, inset: (bottom: 0.6em), stroke: (bottom: 2pt + eastern))[
      #text(weight: "bold", size: 1.2em, [Sommaire])
    ]
    #v(1em)
    #set text(size: 0.9em)
    #outline(title: none, indent: 2em, depth: 2)
  ])

  show emph: set text(fill: eastern)
  set-options(..options)
  body
}
