#import "../presentate.typ" as p
#import "../store.typ": *
#import "../components/progressive-outline.typ": progressive-outline, register-heading, progressive-outline-cache, get-active-headings

#let empty-slide(fill: none, ..args) = {
  set page(margin: 0pt, header: none, footer: none, fill: fill)
  p.slide(..args)
}

#let slide(..args, align: top) = {
  let kwargs = args.named()
  let args = args.pos()
  let body

  let title-content = context {
    let active = get-active-headings(here())
    let t = none
    let h-num = ""
    
    if args.len() == 1 {
      if active.h3 != none {
        t = active.h3.body
        // Check if numbering should be displayed (based on heading numbering setting)
        // Since we don't have direct access to show-heading-numbering here easily 
        // without state, we check if the heading has a numbering defined.
        if active.h3.numbering != none {
          h-num = numbering(active.h3.numbering, ..active.h3.counter) + " "
        }
      }
    } else if args.at(0) == none {
      t = none
    } else if args.len() == 2 {
      t = args.at(0)
    }
    
    if t != none {
      block(width: 100%, inset: (bottom: 0.6em), stroke: (bottom: 2pt + eastern))[
        #text(weight: "bold", size: 1.2em, [#h-num#t])
      ]
    }
  }

  if args.len() == 1 {
    (body,) = args
  } else {
    (_, body) = args
  }

  p.slide(
    ..kwargs,
    [
      #title-content
      #set std.align(align)
      #body
    ],
  )
}

#let template(
  body,
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
  on-section-change: auto,
  on-subsection-change: auto,
  on-subsubsection-change: none,
  ..options,
) = {
  // Use the parameter to define local default transitions if auto
  let on-section-change = if on-section-change == auto {
    (h) => empty-slide({
      v(25%)
      pad(left: 15%)[
        #progressive-outline(
          level-1-mode: "current", 
          level-2-mode: "current-parent",
          show-numbering: show-heading-numbering,
          target-location: h.location,
        )
      ]
    })
  } else { on-section-change }

  let on-subsection-change = if on-subsection-change == auto {
    (h) => empty-slide({
      v(25%)
      pad(left: 15%)[
        #progressive-outline(
          level-1-mode: "current",
          level-2-mode: "current-parent",
          show-numbering: show-heading-numbering,
          target-location: h.location,
        )
      ]
    })
  } else { on-subsection-change }

  if header == auto {
    header = context {
      set text(size: 0.8em)
      let active = get-active-headings(here())
      let h1 = active.h1
      let h2 = active.h2
      
      let format-h(h) = {
        if h == none or h.location == none { return box[] }
        let num = if show-heading-numbering {
          numbering("1.1", ..h.counter) + " "
        } else { "" }
        [#num#h.body]
      }
      
      let h1-c = format-h(h1)
      let h2-c = format-h(h2)
      
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
  
  // Unified rule to handle registration and transitions
  show heading: h => {
    let update = register-heading(h)
    if h.level == 1 and on-section-change != none {
      update + on-section-change(h)
    } else if h.level == 2 and on-subsection-change != none {
      update + on-subsection-change(h)
    } else if h.level == 3 {
      update
      if on-subsubsection-change != none {
        on-subsubsection-change(h)
      }
    } else {
      update + h
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