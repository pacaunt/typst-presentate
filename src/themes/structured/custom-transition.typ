#import "../../presentate.typ" as p
#import "../../store.typ": *
#import "../../components/components.typ": progressive-outline, register-heading, get-active-headings, structure-config, resolve-slide-title, is-role
#import "../../components/title.typ": slide-title
#import "../../components/transition-engine.typ": render-transition

#let empty-slide(fill: none, body) = {
  set page(margin: 0pt, header: none, footer: none, fill: fill)
  p.slide(context {
    let ts = structure-config.get().at("text-size", default: 20pt)
    set align(top + left)
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
  numbering-format: "1.1",
  mapping: (section: 1, subsection: 2),
  auto-title: false,
  on-part-change: none,
  on-section-change: none,
  on-subsection-change: none,
  on-subsubsection-change: none,
  transitions: (),
  body,
  ..options,
) = {
  
  structure-config.update(conf => (
    mapping: mapping,
    auto-title: auto-title,
    text-size: text-size,
    show-heading-numbering: show-heading-numbering,
    numbering-format: numbering-format,
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
          numbering(numbering-format, ..h.counter) + " "
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
    
    let hook = none
    if is-role(mapping, h.level, "part") { hook = on-part-change }
    else if is-role(mapping, h.level, "section") { hook = on-section-change }
    else if is-role(mapping, h.level, "subsection") { hook = on-subsection-change }

    if hook != none {
      hook(h)
    } else {
      render-transition(
        h,
        transitions: transitions,
        mapping: mapping,
        show-heading-numbering: show-heading-numbering,
        numbering-format: numbering-format,
        theme-colors: (primary: eastern, accent: eastern),
        slide-func: empty-slide
      )
    }
  }
  
  show heading: set text(size: 1em, weight: "regular")
  
  // Apply numbering settings globally to all headings in mapping
  set heading(outlined: true, numbering: (..nums) => {
    if show-heading-numbering {
      let lvl = nums.pos().len()
      let mapped-lvls = mapping.values()
      if lvl in mapped-lvls {
        numbering(numbering-format, ..nums)
      }
    }
  })
  
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