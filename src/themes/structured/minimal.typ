#import "../../presentate.typ" as p
#import "../../store.typ": set-options
#import "../../components/components.typ": register-heading, structure-config, resolve-slide-title, is-role
#import "../../components/title.typ": slide-title
#import "../../components/transition-engine.typ": render-transition

// State to share configuration between template and slides
#let config-state = state("minimal-config", none)

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

/// Internal layout engine for minimal slides
#let apply-layout(title: none, body) = context {
  let config = config-state.get()
  if config == none { return body }
  
  let footer-content = config.footer-content
  
  block(width: 100%, height: 100%, {
    // Marker for miniframes dot production
    metadata((t: "Miniframes_Normal"))
    
    stack(
      dir: ttb,
      // 1. Title zone
      slide-title(resolve-slide-title(title), inset: (x: 5%, top: 1.5em, bottom: 1em)),
      
      // 2. Content zone
      pad(x: 5%, body),
      
      v(1fr),
      
      // 3. Footer zone
      if footer-content != none {
        set text(fill: gray, size: 0.8em)
        pad(x: 5%, bottom: 1em, footer-content)
      }
    )
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
    apply-layout(title: manual-title, {
      set std.align(align)
      body
    }),
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
  header: none,
  footer: auto,
  show-heading-numbering: true,
  numbering-format: "1.1",
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
  
  structure-config.update(conf => (
    mapping: mapping,
    auto-title: auto-title,
    text-size: text-size,
    show-heading-numbering: show-heading-numbering,
    numbering-format: numbering-format,
  ))

  let footer-content = if footer == auto {
    context grid(
      columns: (1fr, 1fr, 1fr),
      align(left, if author != none { author }),
      align(center, if title != none { title }),
      align(right, counter(page).display("1"))
    )
  } else {
    footer
  }

  config-state.update((
    footer-content: footer-content,
  ))

  set page(paper: "presentation-" + aspect-ratio, margin: 0pt, header: header, footer: none)
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
  
  set-options(..options)

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
