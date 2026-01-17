#import "../presentate.typ" as p
#import "../components/progressive-outline.typ": progressive-outline, register-heading

/// Slide without sidebar and margins
#let empty-slide(..args) = {
  set page(margin: 0pt, background: none, footer: none)
  p.slide(..args)
}

/// Standard slide with sidebar
#let slide(..args) = {
  let kwargs = args.named()
  let pos = args.pos()
  let title = none
  let body = none

  if pos.len() == 1 {
    body = pos.at(0)
  } else if pos.len() >= 2 {
    title = pos.at(0)
    body = pos.at(1)
  }

  p.slide(
    ..kwargs,
    {
      if title != none {
        heading(level: 2, title)
      }
      body
    }
  )
}

/// A sidebar-based template inspired by Beamer's Hannover/Marburg themes.
#let template(
  title: [Title of Presentation],
  subtitle: none,
  author: none,
  date: none,
  side: "left",
  width: 22%,
  sidebar-color: rgb("#2c3e50"),
  main-color: white,
  text-color: white,
  active-color: rgb("#f39c12"),
  completed-color: rgb("#95a5a6"),
  title-color: rgb("#2c3e50"),
  logo: none,
  logo-position: "top",
  text-font: "Lato",
  text-size: 20pt,
  numbering: "1.1",
  outline-options: (:),
  body,
  ..options
) = {
  
  // Default text styles for the sidebar
  let default-text-styles = (
    level-1: (
      active: (weight: "bold", fill: active-color),
      completed: (fill: completed-color),
      inactive: (fill: text-color)
    ),
    level-2: (
      active: (weight: "bold", fill: active-color, size: 0.9em),
      completed: (fill: completed-color, size: 0.9em),
      inactive: (fill: text-color.darken(10%), size: 0.9em)
    )
  )

  // Merge user provided outline options with defaults
  let final-outline-opts = (
    level-1-mode: "all",
    level-2-mode: "all",
    match-page-only: true,
    text-styles: default-text-styles,
    show-numbering: numbering != none,
    numbering-format: if numbering != none { numbering } else { "1.1" },
    spacing: (
      indent-2: 1.2em,
      v-between-1-1: 1.2em, 
      v-between-1-2: 0.8em,
      v-between-2-1: 1.2em, 
      v-between-2-2: 0.6em
    )
  ) + outline-options

  // The content of the sidebar
  let sidebar-content = context {
    set text(font: text-font, size: 0.7em)
    
    place(
      if side == "left" { left } else { right },
      rect(width: width, height: 100%, fill: sidebar-color, stroke: none)
    )
    
    place(
      if side == "left" { left } else { right },
      block(
        width: width, height: 100%, inset: (x: 1em, y: 2em),
        if logo != none and logo-position == "bottom" {
          stack(
            dir: ttb, spacing: 1em,
            progressive-outline(..final-outline-opts),
            v(1fr),
            align(center, logo)
          )
        } else {
          stack(
            dir: ttb, spacing: 2em,
            if logo != none { align(center, logo) },
            progressive-outline(..final-outline-opts)
          )
        }
      )
    )
  }

  let layout-margins = if side == "left" {
    (left: width + 1cm, right: 1cm, top: 1cm, bottom: 1cm)
  } else {
    (left: 1cm, right: width + 1cm, top: 1cm, bottom: 1cm)
  }

  set page(
    paper: "presentation-16-9",
    margin: layout-margins,
    fill: main-color,
    background: sidebar-content,
    footer: context {
      set text(fill: gray.darken(30%), size: 0.8em)
      align(if side == "left" { right } else { left })[
        #counter(page).display("1 / 1", both: true)
      ]
    }
  )

  set text(size: text-size, font: text-font, fill: black)
  show heading: set text(fill: title-color)
  show heading: it => register-heading(it) + it
  set heading(outlined: true, numbering: numbering)

  show heading.where(level: 1): h => {
    block(
      width: 100%, inset: (bottom: 0.5em),
      stroke: (bottom: 2pt + title-color),
      text(size: 1.5em, weight: "bold", h)
    )
    v(0.5em)
  }

  show heading.where(level: 2): h => {
    text(size: 1.2em, weight: "bold", h)
    v(0.5em)
  }

  // --- Title Slide ---
  empty-slide({
    set align(center + horizon)
    block(
      text(size: 2.5em, weight: "bold", fill: title-color, title),
      inset: (bottom: 1em),
      stroke: (bottom: 2pt + title-color)
    )
    if subtitle != none { 
      text(size: 1.2em, emph(subtitle))
      v(1em) 
    }
    
    let info = ()
    if author != none { info.push(author) }
    if date != none { info.push(date) }
    
    if info.len() > 0 {
      grid(columns: info.len() * 2 - 1, ..info.intersperse(grid.vline(stroke: 0.5pt + gray)), inset: 0.7em)
    }
  })

  body
}