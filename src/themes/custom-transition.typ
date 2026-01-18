#import "../presentate.typ" as p
#import "../store.typ": *
#import "../components/progressive-outline.typ": progressive-outline, register-heading, progressive-outline-cache, get-active-headings
#import "../components/title.typ": slide-title
#import "../structure.typ": structure-config, resolve-slide-title, is-role

#let empty-slide(fill: none, body) = {
  set page(margin: 0pt, header: none, footer: none, fill: fill)
  p.slide(context {
    let ts = structure-config.get().at("text-size", default: 20pt)
    set text(size: ts)
    body
  })
}

#let slide(..args, align: top) = {
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
      #set std.align(align)
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
  on-section-change: auto,
  on-subsection-change: auto,
  on-subsubsection-change: none,
  show-all-sections-in-transition: false,
  body,
  ..options,
) = {
  
  structure-config.update(conf => (
    mapping: mapping,
    auto-title: auto-title,
    text-size: text-size,
  ))

  let l1-mode = if show-all-sections-in-transition { "all" } else { "current" }
  let l2-mode = if show-all-sections-in-transition { "all" } else { "current-parent" }
  let l3-mode = if show-all-sections-in-transition { "all" } else { "current-parent" }

  // Default transition logic
  let on-section-change = if on-section-change == auto {
    (h) => empty-slide({
      set align(top + left)
      v(25%)
      
      let get-mode(lvl) = {
        if is-role(mapping, lvl, "part") { l1-mode }
        else if is-role(mapping, lvl, "section") { l2-mode }
        else if is-role(mapping, lvl, "subsection") { l3-mode }
        else { "none" }
      }

      pad(left: 15%)[
        #progressive-outline(
          level-1-mode: get-mode(1), 
          level-2-mode: get-mode(2),
          level-3-mode: get-mode(3),
          show-numbering: show-heading-numbering,
          target-location: h.location(),
        )
      ]
      place(hide(h))
    })
  } else { on-section-change }

  let on-subsection-change = if on-subsection-change == auto {
    (h) => empty-slide({
      set align(top + left)
      v(25%)

      let get-mode(lvl) = {
        if is-role(mapping, lvl, "part") { l1-mode }
        else if is-role(mapping, lvl, "section") { l2-mode }
        else if is-role(mapping, lvl, "subsection") { l3-mode }
        else { "none" }
      }

      pad(left: 15%)[
        #progressive-outline(
          level-1-mode: get-mode(1),
          level-2-mode: get-mode(2),
          level-3-mode: get-mode(3),
          show-numbering: show-heading-numbering,
          target-location: h.location(),
        )
      ]
      place(hide(h))
    })
  } else { on-subsection-change }

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
          numbering("1.1", ..h.counter) + " "
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
  
  // Unified Transition Rule
  show heading: h => {
    register-heading(h)
    if is-role(mapping, h.level, "part") {
      if on-part-change != none { on-part-change(h) } else { place(hide(h)) }
    } else if is-role(mapping, h.level, "section") {
      if on-section-change != none { on-section-change(h) } else { place(hide(h)) }
    } else if is-role(mapping, h.level, "subsection") {
      if on-subsection-change != none { on-subsection-change(h) } else { place(hide(h)) }
    } else {
      h
    }
  }
  
  show heading: set text(size: 1em, weight: "regular")
  
  // Apply numbering settings globally to all headings
  set heading(outlined: true, numbering: if show-heading-numbering { "1.1" } else { none })
  
  show emph: set text(fill: eastern)
  set-options(..options)

  // --- Title Slide ---
  empty-slide({
    set align(center + horizon)
    block(text(size: 2em, weight: "bold", title), inset: (bottom: 1.2em), stroke: (bottom: 2pt + eastern))
    if subtitle != none {
      emph(subtitle)
      linebreak()
    }
    grid(columns: 2, author, grid.vline(), date, inset: (x: 0.5em))
  })

  // --- Global Outline (Classic Summary) ---
  p.slide([
    #block(width: 100%, inset: (bottom: 0.6em), stroke: (bottom: 2pt + eastern))[
      #text(weight: "bold", size: 1.2em, [Sommaire])
    ]
    #v(1em)
    #set text(size: 0.9em)
    #outline(title: none, indent: 2em, depth: 2)
  ])

  body
}