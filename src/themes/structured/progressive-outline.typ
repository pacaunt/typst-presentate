#import "../../presentate.typ" as p
#import "../../store.typ": *
#import "../../components/components.typ": progressive-outline, register-heading, get-active-headings, structure-config, resolve-slide-title, is-role
#import "../../components/structure.typ": empty-slide
#import "../../components/title.typ": slide-title
#import "../../components/transition-engine.typ": render-transition

#let config-state = state("progressive-outline-config", none)

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
  numbering-format: auto,
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
    text-font: text-font,
    show-heading-numbering: show-heading-numbering,
    numbering-format: numbering-format,
  ))

  config-state.update((
    text-size: text-size,
    text-font: text-font,
  ))

  if header == auto {
    header = context {
      set text(size: 0.8em)
      let active = get-active-headings(here())
      let mapping = structure-config.get().mapping
      
      let breadcrumb = ()
      let roles = ("part", "section", "subsection")
      
      for role in roles {
        let lvl = mapping.at(role, default: none)
        if lvl != none {
          let h = active.at("h" + str(lvl), default: none)
          if h != none and h.location() != none {
            let num = if show-heading-numbering {
              let idx = counter(heading).at(h.location())
              let fmt = if numbering-format == auto { h.numbering } else { numbering-format }
              if fmt != none and idx.any(v => v > 0) { numbering(fmt, ..idx.slice(0, h.level)) + " " } else { "" }
            } else { "" }
            
            let col = if role == "part" { gray.darken(20%) } else if role == "section" { gray } else { luma(150) }
            let weight = if role == "part" or role == "section" { "bold" } else { "regular" }
            
            breadcrumb.push(text(fill: col, weight: weight, [#num#h.body]))
          }
        }
      }
      
      breadcrumb.join(text(fill: gray, " / "))
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
  
  // Register headings
  show heading: it => register-heading(it) + it
  show heading: set text(size: 1em, weight: "regular")
  
  // Wrap the document to ensure heading numbering is global
  show: doc => {
    if show-heading-numbering {
      if numbering-format != auto {
        set heading(outlined: true, numbering: (..nums) => {
          let lvl = nums.pos().len()
          if lvl in mapping.values() {
            numbering(numbering-format, ..nums)
          }
        })
        doc
      } else {
        set heading(outlined: true)
        doc
      }
    } else {
      set heading(numbering: none)
      doc
    }
  }
  
  let mapped-levels = mapping.values()
  if 3 in mapped-levels {
    show heading.where(level: 3): it => register-heading(it)
  }

  // Unified Transition Rule
  show heading: h => {
    register-heading(h)
    let hook = none
    if is-role(mapping, h.level, "part") { hook = on-part-change }
    else if is-role(mapping, h.level, "section") { hook = on-section-change }
    else if is-role(mapping, h.level, "subsection") { hook = on-subsection-change }

    if hook != none {
      hook(h)
    } else {
      let final-trans = transitions
      if show-all-sections-in-transition {
        let all-vis = (part: "all", section: "all", subsection: "all")
        let override = (parts: (visibility: all-vis), sections: (visibility: all-vis), subsections: (visibility: all-vis))
        if type(transitions) == dictionary {
          final-trans = p.utils.merge-dicts(base: final-trans, override)
        } else {
          final-trans = override
        }
      }

      render-transition(
        h,
        transitions: final-trans,
        mapping: mapping,
        show-heading-numbering: show-heading-numbering,
        numbering-format: numbering-format,
        theme-colors: (primary: eastern, accent: eastern),
        slide-func: empty-slide.with(text-size: text-size, text-font: text-font)
      )
    }
  }

  // --- Title Slide ---
  empty-slide(text-size: text-size, text-font: text-font, {
    set align(center + horizon)
    pad(x: 10%)[
      #block(text(size: 2em, weight: "bold", title), inset: (bottom: 1.2em), stroke: (bottom: 2pt + eastern))
      #emph(subtitle)
      #linebreak()
      #grid(columns: 2, author, grid.vline(), date, inset: (x: 0.5em))
    ]
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
