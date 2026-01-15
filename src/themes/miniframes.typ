#import "../presentate.typ" as p
#import "../store.typ": states, set-options
#import "../miniframes.typ": get-structure, get-current-logical-slide-number, render-miniframes
#import "../progressive-outline.typ": progressive-outline, register-heading, get-active-headings

// États pour partager la config entre le template et les fonctions slide
#let structure-cache = state("miniframes-structure-cache", none)
#let config-state = state("miniframes-config", none)

// Layout standard avec barre et footer
#let apply-layout(body) = context {
  let config = config-state.get()
  if config == none { return body }
  
  let struct = structure-cache.get()
  let current = get-current-logical-slide-number()
  
  let nav-opts = config.nav-opts
  let margin-x = config.margin-x
  let gap-zone = config.gap-zone
  let footer-content = config.footer-content
  
  let base-size = 20pt
  let footer-size = 15pt

  // Récupération automatique du titre de la slide (H2 actuel)
  let active = get-active-headings(here())
  let slide-title = if active.h2 != none {
    block(width: 100%, inset: (bottom: 0.8em), text(weight: "bold", size: 24pt, active.h2.body))
  } else { none }

  let bar = if struct != none {
    render-miniframes(
      struct,
      current,
      fill: nav-opts.fill,
      text-color: nav-opts.text-color,
      text-size: nav-opts.text-size,
      font: nav-opts.font,
      active-color: nav-opts.active-color,
      inactive-color: nav-opts.inactive-color,
      marker-shape: nav-opts.marker-shape,
      marker-size: nav-opts.marker-size,
      style: nav-opts.style,
      align-mode: nav-opts.align-mode,
      dots-align: nav-opts.dots-align,
      show-section-titles: nav-opts.show-section-titles,
      show-subsection-titles: nav-opts.show-subsection-titles,
      gap: nav-opts.gap,
      line-spacing: nav-opts.line-spacing,
      inset: nav-opts.inset,
      width: nav-opts.width,
      outset-x: nav-opts.outset-x,
      radius: nav-opts.radius,
    )
  } else { 
    block(width: 100%, height: 3em, []) 
  }

  // Style global de la slide
  set text(size: base-size, font: "Lato", weight: "regular", fill: black)

  block(width: 100%, height: 100%, fill: white, {
    // Marqueur pour indiquer que cette slide doit produire un dot
    metadata((t: "Miniframes_Normal"))
    stack(
      dir: ttb,
      // 1. Zone Haute: BARRE DE MINIFRAMES (TOUT EN HAUT)
      if nav-opts.position == "top" {
        stack(dir: ttb, block(width: 100%, { set text(weight: "regular"); bar }), v(gap-zone))
      } else { none },
      
      // 2. Zone Milieu: TITRE + CORPS
      block(width: 100%, inset: (x: margin-x), {
        slide-title
        // On cache les titres éventuellement présents dans body pour éviter les doublons
        show heading: none
        body
      }),
      
      v(1fr),
      
      // 3. Zone Basse: FOOTER / BARRE BASSE
      {
        set text(size: footer-size, fill: gray, weight: "regular")
        let footer-block = block(width: 100%, inset: (x: margin-x, bottom: 1em), footer-content)
        if nav-opts.position == "bottom" {
          stack(dir: ttb, footer-block, v(gap-zone/2), bar)
        } else {
          footer-block
        }
      }
    )
  })
}

// Layout "Plain" pour les transitions (fond coloré, texte blanc)
#let plain-layout(body) = context {
  let config = config-state.get()
  let color = config.at("color", default: black)
  let margin-x = config.at("margin-x", default: 2.5em)
  
  block(width: 100%, height: 100%, fill: color, inset: (x: margin-x, y: 0pt), {
    set text(fill: white, font: "Lato", size: 20pt, weight: "regular")
    set align(center + horizon)
    body
  })
}

#let slide(body, ..args) = p.slide(..args, apply-layout(body))

#let template(
  body,
  title: none,
  subtitle: none,
  author: none,
  date: datetime.today().display(),
  color: rgb("#1a5fb4"),
  aspect-ratio: "16-9",
  navigation: (),
  transitions: (),
  show-all-sections-in-transition: false,
  ..options,
) = {
  let nav-opts = (
    position: "top", fill: color, text-color: white, text-size: 9pt,
    font: none, active-color: white, inactive-color: white.transparentize(60%),
    marker-shape: "circle", marker-size: 4pt, style: "compact",
    align-mode: "left", dots-align: "left", show-section-titles: true,
    show-subsection-titles: true, gap: 2em, line-spacing: 0.8em,
    inset: (x: 1.5em, y: 1.2em), radius: 0pt, width: 100%, outset-x: 0pt,
  )
  if type(navigation) == dictionary { 
    // Handle both 'align' and 'align-mode' for convenience
    if "align" in navigation and "align-mode" not in navigation {
      navigation.insert("align-mode", navigation.align)
    }
    nav-opts = p.utils.merge-dicts(base: nav-opts, navigation) 
  }

  let trans-opts = (enabled: true, level: 2)
  if type(transitions) == dictionary { trans-opts = p.utils.merge-dicts(base: trans-opts, transitions) }

  config-state.update((
    nav-opts: nav-opts, margin-x: 2.5em, gap-zone: 1.5em,
    footer-content: context grid(
      columns: (1fr, 1fr, 1fr),
      align(left, if author != none { author }),
      align(center, if title != none { title }),
      align(right, counter(page).display("1 / 1", both: true))
    ), 
    color: color,
  ))

  set page(paper: "presentation-" + aspect-ratio, margin: 0pt, header: none, footer: none)
  set text(size: 20pt, font: "Lato")

  // Rule to record EVERYTHING including what's handled by other rules
  // This ensures headings are registered in the cache and their counters advance
  show heading: it => register-heading(it) + it
  
  show heading: set text(size: 20pt, weight: "regular")
  set heading(outlined: true)
  
  // Level 3 headings are registered but typically not rendered to avoid slide clutter
  show heading.where(level: 3): it => register-heading(it)

  show: doc => { context structure-cache.update(get-structure()); doc }
  
  // Title slide
  p.slide[
    #set align(center + horizon)
    #pad(x: 10%)[
      #block(fill: color, inset: (x: 2em, y: 1.5em), radius: 15pt, width: 100%)[
        #set text(fill: white)
        #if title != none { text(size: 2.2em, weight: "bold", title) }
        #if subtitle != none { 
          v(0.6em)
          line(length: 30%, stroke: 1pt + white.transparentize(50%))
          v(0.6em)
          text(size: 1.3em, style: "italic", subtitle) 
        }
      ]
    ]
    #v(2em)
    #pad(x: 12%)[
      #grid(
        columns: (1fr, 1fr), 
        align(left, if author != none { 
          set text(size: 1.1em)
          strong(author)
        }), 
        align(right, if date != none {
          set text(fill: gray)
          date
        })
      )
    ]
  ]

  // Styles for white-on-dark transitions (adapted from progressive-outline)
  let l1-mode = if show-all-sections-in-transition { "all" } else { "current" }

  let outline-styles = (
    level-1: (
      active: (weight: "bold", fill: white, size: 30pt), 
      completed: (weight: "bold", fill: white.transparentize(50%), size: 30pt),
      inactive: (weight: "bold", fill: white.transparentize(50%), size: 30pt)
    ),
    level-2: (
      active: (weight: "regular", fill: white, size: 22pt), 
      completed: (weight: "regular", fill: white.transparentize(50%), size: 22pt),
      inactive: (weight: "regular", fill: white.transparentize(50%), size: 22pt)
    ),
  )

  let outline-spacing = (
    indent-1: 0pt, indent-2: 1.5em,
    v-between-1-1: 1.8em, 
    v-between-1-2: 1.5em, 
    v-between-2-1: 1.8em, 
    v-between-2-2: 0.8em, 
  )

  // Transitions H1
  show heading.where(level: 1): h => {
    let reg = register-heading(h)
    if trans-opts.enabled {
      reg + p.slide(plain-layout({
        place(hide(h)) // Render hiddenly to advance counter and register in tree
        v(25%)
        pad(left: 15%)[
          #progressive-outline(
            level-1-mode: l1-mode, 
            level-2-mode: "current-parent",
            show-numbering: false,
            target-location: h.location(),
            text-styles: (
              level-1: outline-styles.level-1,
              // Subsections are NORMAL (white) during chapter transition
              level-2: (
                active: (weight: "regular", fill: white, size: 22pt), 
                inactive: (weight: "regular", fill: white, size: 22pt)
              )
            ),
            spacing: outline-spacing,
          )
        ]
      }))
    } else {
      reg + place(hide(h))
    }
  }

  // Transitions H2
  show heading.where(level: 2): h => {
    let reg = register-heading(h)
    if trans-opts.enabled and trans-opts.level >= 2 {
      reg + p.slide(plain-layout({
        place(hide(h)) // Render hiddenly to advance counter and register in tree
        v(25%)
        pad(left: 15%)[
          #progressive-outline(
            level-1-mode: l1-mode,
            level-2-mode: "current-parent",
            show-numbering: false,
            target-location: h.location(),
            text-styles: outline-styles,
            spacing: outline-spacing,
          )
        ]
      }))
    } else {
      reg + place(hide(h))
    }
  }

  set-options(..options)
  body
}