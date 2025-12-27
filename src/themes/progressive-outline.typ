#import "../presentate.typ" as p
#import "../store.typ": *
#import "../progressive-outline.typ": progressive-outline

#let save-headings = state("progressive-outline-headings", ())

#let current-heading() = {
  context {
    let hs = save-headings.get()
    if hs != () and hs.last().level == 3 {
      hs.last()
    }
  }
}

// This function correctly prevents the header from showing titles from previous pages.
#let current-subsubsection() = {
  context {
    let h3s = query(heading.where(level: 3).before(here()))
    let last-h3 = h3s.at(-1, default: none)
    if last-h3 != none and last-h3.location().page() == here().page() {
      last-h3.body
    } else {
      box[]
    }
  }
}

#let current-section() = {
  query(heading.where(level: 1).before(here())).at(-1, default: box[]).body
}

#let current-subsection() = {
  query(heading.where(level: 2).before(here())).at(-1, default: box[]).body
}

#let empty-slide(..args) = {
  set page(margin: 0pt, header: none, footer: none)
  p.slide(..args)
}

#let slide(..args, align: top) = {
  let kwargs = args.named()
  let args = args.pos()
  let title
  let body

  if args.len() == 1 {
    (body,) = args
    title = current-heading()
  } else if args.at(0) == none {
    (_, body) = args
    title = none
  } else if args.len() == 2 {
    (title, body) = args
    title = heading(level: 3, title)
  }

  // Save the headings state (persistently, by removing `context`)
  context save-headings.update(query(selector.or(heading.where(level: 1, outlined: true), heading.where(level: 2, outlined: true), heading.where(level: 3, outlined: true)).before(here())))

  p.slide(
    ..kwargs,
    [
      // Show rule to style the h3 title
      #show heading.where(level: 3): block.with(inset: (bottom: 0.65em), stroke: (bottom: 2pt + eastern))
      #title
      #set std.align(align)
      #body
    ],
  )
}

#let focus-slide(..args, fill: eastern, body) = {
  set page(fill: fill)
  empty-slide(
    ..args,
    {
      set align(center + horizon)
      show: emph
      set text(fill: white, size: 1.5em)
      body
    },
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
  enable-section-slide: true,
  aspect-ratio: "16-9",
  ..options,
) = {
  if header == auto {
    header = {
      set text(size: 0.8em) // Set base size
      let h1-title = context current-section()
      let h2-title = context current-subsection()
      let h3-title = context current-subsubsection() // Get H3 title

      let header-parts = ()
      if h1-title != box[] {
        header-parts.push(text(fill: gray, weight: "bold", h1-title))
      }
      if h2-title != box[] {
        header-parts.push(text(fill: luma(180), weight: "regular", h2-title))
      }
      if h3-title != box[] {
        header-parts.push(text(fill: luma(200), weight: "regular", h3-title))
      }

      if header-parts.len() > 0 {
        let final-header = ()
        for i in range(header-parts.len()) {
          final-header.push(header-parts.at(i))
          if i < header-parts.len() - 1 {
            final-header.push(h(0.5em) + text(fill: luma(180), " / ") + h(0.5em))
          }
        }
        final-header.join()
      }
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
  set heading(outlined: true)
  show math.equation: set text(font: "Lete Sans Math")

  empty-slide(
    {
      set align(center + horizon)
      block(
        text(size: 2em, weight: "bold", title),
        inset: (bottom: 1.2em),
      )

      emph(subtitle)
      linebreak()
      grid(
        columns: 2,
        author, grid.vline(), date,
        inset: (x: 0.5em),
      )
    },
  )

  show heading.where(level: 1): h => {
    set page(fill: white)
    empty-slide(
      {
        set align(center + horizon)
        v(1fr)
        block(
          text(size: 40pt, weight: "bold", progressive-outline(h1-style: "current", h2-style: "none", h3-style: "none", show-numbering: false)),
                  inset: (bottom: 10pt),
                  stroke: (bottom: 2pt + eastern),
        )
        v(0.3fr)
        block(
          text(size: 20pt, weight: "regular", progressive-outline(h1-style: "none", h2-style: "all", h3-style: "none", show-numbering: false, scope-h2: "current-h1")),
                  inset: (bottom: 10pt),
        )
        v(1fr)
      }
    )
  }

  show heading.where(level: 2): h => {
    set page(fill: white) // Change background to white
    empty-slide(
      {
        set align(center + horizon)
        v(1fr)
        block(
          text(size: 40pt, weight: "bold", progressive-outline(h1-style: "current", h2-style: "none", h3-style: "none", show-numbering: false)),
                  inset: (bottom: 10pt),
                  stroke: (bottom: 2pt + eastern), // Add blue underline
        )
        v(0.3fr)
        block(
          text(size: 20pt, weight: "regular", progressive-outline(h1-style: "none", h2-style: "current-and-grayed", h3-style: "none", show-numbering: false, scope-h2: "current-h1", h2-text-style: (fill: gray))),
                  inset: (bottom: 10pt),
        )
        v(1fr)
      }
    )
  }

  show emph: set text(fill: eastern)

  set-options(..options)

  body
}
