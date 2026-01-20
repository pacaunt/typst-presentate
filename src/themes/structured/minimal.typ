#import "../../presentate.typ" as p
#import "../../components/components.typ": register-heading, structure-config, resolve-slide-title, is-role
#import "../../components/title.typ": slide-title
#import "../../components/transition-engine.typ": render-transition

/// Slide with absolute top-left alignment and no margins
#let empty-slide(fill: none, body) = {
  set page(margin: 0pt, header: none, footer: none, fill: fill)
  p.slide(context {
    let ts = structure-config.get().at("text-size", default: 20pt)
    set align(top + left)
    set text(size: ts)
    body
  })
}

/// Standard slide for the minimal theme
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
      #slide-title(resolve-slide-title(manual-title), inset: (x: 5%, top: 1.5em, bottom: 1em))
      #set std.align(align)
      #pad(x: 5%, body)
    ],
  )
}

/// Minimalist theme focused on content and roadmap transitions
#let template(
  author: none,
  title: none,
  subtitle: none,
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

  set page(paper: "presentation-" + aspect-ratio, margin: 0pt, header: none, footer: none)
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
        theme-colors: (primary: black, accent: blue),
        slide-func: empty-slide
      )
    }
  }
  
  show heading: set text(size: 1em, weight: "regular")
  set heading(outlined: true, numbering: (..nums) => {
    if show-heading-numbering {
      let lvl = nums.pos().len()
      if lvl in mapping.values() {
        numbering(numbering-format, ..nums)
      }
    }
  })
  
  // --- Title Slide ---
  empty-slide({
    set align(center + horizon)
    pad(x: 10%)[
      #block(text(size: 2.5em, weight: "bold", title), inset: (bottom: 1em))
      #if subtitle != none { text(size: 1.2em, emph(subtitle)) }
      #v(2em)
      #grid(columns: 2, author, date, inset: (x: 1em))
    ]
  })

  body
}
