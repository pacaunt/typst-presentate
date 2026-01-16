#import "../presentate.typ" as p
#import "../store.typ": *
#import "../components/progressive-outline.typ": progressive-outline, register-heading, progressive-outline-cache, get-active-headings

#let config-state = state("progressive-outline-config", none)

#let empty-slide(..args) = context {
  let config = config-state.get()
  let ts = if config != none and "text-size" in config { config.text-size } else { 20pt }
  set page(margin: 0pt, header: none, footer: none)
  set text(size: ts)
  p.slide(..args)
}

#let slide(..args, align: top) = {
  let kwargs = args.named()
  let args = args.pos()
  let body

  let title-content = context {
    let active = get-active-headings(here())
    let t = none
    
    if args.len() == 1 {
      if active.h3 != none {
        t = active.h3.body
      }
    } else if args.at(0) == none {
      t = none
    } else if args.len() == 2 {
      t = args.at(0)
    }
    
    if t != none {
      block(width: 100%, inset: (bottom: 0.6em), stroke: (bottom: 2pt + eastern))[
        #text(weight: "bold", size: 1.2em, t)
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
  show-all-sections-in-transition: false,
  ..options,
) = {
  let trans-opts = (enabled: true, level: 1) // default unused but good practice
  
  config-state.update((
    text-size: text-size
  ))

  if header == auto {
    header = context {
      set text(size: 0.8em)
      let active = get-active-headings(here())
      let h1 = active.h1
      let h2 = active.h2
      
      let format-h(h) = {
        if h == none or h.location == none { return box[] }
        let num = if show-heading-numbering {
          let idx = counter(heading).at(h.location)
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
      active: (weight: "bold", fill: eastern, size: 1.1em), 
      completed: (weight: "bold", fill: luma(180), size: 1.1em),
      inactive: (weight: "bold", fill: black, size: 1.1em)
    ),
    level-2: (
      active: (weight: "regular", fill: eastern, size: 1.1em), 
      completed: (weight: "regular", fill: luma(200), size: 1.1em),
      inactive: (weight: "regular", fill: luma(100), size: 1.1em)
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

  let l1-mode = if show-all-sections-in-transition { "all" } else { "current" }

  // --- H1 Transition ---
  show heading.where(level: 1): h => {
    register-heading(h)
    empty-slide({
      v(25%)
      pad(left: 15%)[
        #progressive-outline(
          level-1-mode: l1-mode, 
          level-2-mode: "current-parent",
          show-numbering: show-heading-numbering, numbering-format: "1.1 ",
          target-location: h.location(),
          text-styles: (
            level-1: outline-styles.level-1,
            // Subsections are NORMAL (black) during chapter transition
            level-2: (
              active: (weight: "regular", fill: black, size: 1.1em), 
              inactive: (weight: "regular", fill: black, size: 1.1em)
            )
          ),
          spacing: outline-spacing,
        )
      ]
    })
  }

  // --- H2 Transition ---
  show heading.where(level: 2): h => {
    register-heading(h)
    empty-slide({
      v(25%)
      pad(left: 15%)[
        #progressive-outline(
          level-1-mode: l1-mode,
          level-2-mode: "current-parent",
          show-numbering: show-heading-numbering, numbering-format: "1.1 ",
          target-location: h.location(),
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