#import "../presentate.typ" as p
#import "../store.typ": *
#import "../progressive-outline.typ": progressive-outline

#let save-headings = state("progressive-outline-headings", ())

#let current-heading() = {
  let hs = save-headings.get()
  if hs != () and hs.last().level == 3 {
    hs.last()
  } else { none }
}

#let current-section-element() = {
  let hs = query(heading.where(level: 1).before(here()))
  if hs.len() > 0 { hs.last() } else { none }
}

#let current-subsection-element() = {
  let h1 = current-section-element()
  let h2s = query(heading.where(level: 2).before(here()))
  
  if h2s.len() > 0 {
    let last-h2 = h2s.last()
    if h1 != none {
      if last-h2.location().page() > h1.location().page() or (last-h2.location().page() == h1.location().page() and last-h2.location().position().y > h1.location().position().y) {
        return last-h2
      } else {
        return none
      }
    }
    return last-h2
  }
  none
}

#let empty-slide(..args) = {
  set page(margin: 0pt, header: none, footer: none)
  p.slide(..args)
}

#let slide(..args, align: top) = {
  let kwargs = args.named()
  let args = args.pos()
  let body

  let title-content = context {
    let hs = save-headings.get()
    let t = none
    
    if args.len() == 1 {
      if hs != () and hs.last().level == 3 {
        t = hs.last().body
      }
    } else if args.at(0) == none {
      t = none
    } else if args.len() == 2 {
      t = args.at(0)
    }
    
    if t != none {
      block(width: 100%, inset: (bottom: 0.6em), stroke: (bottom: 2pt + eastern))[
        #text(weight: "bold", size: 24pt, t)
      ]
    }
  }

  if args.len() == 1 {
    (body,) = args
  } else {
    (_, body) = args
  }

  context save-headings.update(query(selector.or(heading.where(level: 1, outlined: true), heading.where(level: 2, outlined: true), heading.where(level: 3, outlined: true)).before(here())))

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
  show-heading-numbering: true,
  show-all-sections-in-transition: false,
  ..options,
) = {
  if header == auto {
    header = context {
      set text(size: 0.8em)
      let h1 = current-section-element()
      let h2 = current-subsection-element()
      
      let format-h(h) = {
        if h == none { return box[] }
        let num = if show-heading-numbering {
          let idx = counter(heading).at(h.location())
          numbering("1.1", ..idx.slice(0, h.level)) + " "
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
  set text(size: 20pt, font: "Lato")
  
  show heading: set text(size: 20pt, weight: "regular")
  set heading(outlined: true, numbering: (..nums) => {
    if show-heading-numbering and nums.pos().len() < 3 { numbering("1.1", ..nums) }
  })
  
  show heading.where(level: 3): it => []

  let outline-styles = (
    level-1: (
      active: (weight: "bold", fill: eastern, size: 30pt), 
      inactive: (weight: "bold", fill: luma(180), size: 30pt)
    ),
    level-2: (
      active: (weight: "regular", fill: eastern, size: 22pt), 
      inactive: (weight: "regular", fill: luma(200), size: 22pt)
    ),
  )

  let outline-spacing = (
    indent-1: 0pt, indent-2: 1.5em,
    v-between-1-1: 1.8em, 
    v-between-1-2: 1.5em, 
    v-between-2-1: 1.8em, 
    v-between-2-2: 0.8em, 
  )

  // --- Title Slide ---
  empty-slide({
    set align(center + horizon)
    block(text(size: 40pt, weight: "bold", title), inset: (bottom: 1.2em), stroke: (bottom: 2pt + eastern))
    emph(subtitle)
    linebreak()
    grid(columns: 2, author, grid.vline(), date, inset: (x: 0.5em))
  })

  // --- Global Outline (Classic) ---
  p.slide([
    #block(width: 100%, inset: (bottom: 0.6em), stroke: (bottom: 2pt + eastern))[
      #text(weight: "bold", size: 24pt, [Sommaire])
    ]
    #v(1em)
    #set text(size: 18pt)
    #outline(title: none, indent: 2em, depth: 2)
  ])

  let l1-mode = if show-all-sections-in-transition { "all" } else { "current" }

  // --- H1 Transition ---
  show heading.where(level: 1): h => {
    empty-slide({
      v(25%)
      pad(left: 15%)[
        #progressive-outline(
          level-1-mode: l1-mode, 
          level-2-mode: "current-parent",
          show-numbering: show-heading-numbering, numbering-format: "1.1 ",
          text-styles: (
            level-1: outline-styles.level-1,
            // Subsections are NORMAL (black) during chapter transition
            level-2: (
              active: (weight: "regular", fill: black, size: 22pt), 
              inactive: (weight: "regular", fill: black, size: 22pt)
            )
          ),
          spacing: outline-spacing,
        )
      ]
    })
  }

  // --- H2 Transition ---
  show heading.where(level: 2): h => {
    empty-slide({
      v(25%)
      pad(left: 15%)[
        #progressive-outline(
          level-1-mode: l1-mode,
          level-2-mode: "current-parent",
          show-numbering: show-heading-numbering, numbering-format: "1.1 ",
          text-styles: outline-styles, // Normal logic (active is colored, others gray)
          spacing: outline-spacing,
        )
      ]
    })
  }

  show emph: set text(fill: eastern)
  set-options(..options)
  body
}
