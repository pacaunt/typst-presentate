#import "../presentate.typ" as p
#import "../store.typ": states, set-options
#import "../components/components.typ": get-structure, get-current-logical-slide-number, render-miniframes, progressive-outline, register-heading, get-active-headings
#import "../components/title.typ": slide-title
#import "../structure.typ": structure-config, resolve-slide-title, is-role

// États pour partager la config entre le template et les fonctions slide
#let structure-cache = state("miniframes-structure-cache", none)
#let config-state = state("miniframes-config", none)

// Layout standard avec barre et footer
#let apply-layout(title: none, body) = context {
  let config = config-state.get()
  if config == none { return body }
  
  let struct = structure-cache.get()
  let current = get-current-logical-slide-number()
  
  let nav-opts = config.nav-opts
  let margin-x = config.margin-x
  let gap-zone = config.gap-zone
  let footer-content = config.footer-content
  let show-num = config.show-heading-numbering
  
  let footer-size = 0.75em

  // Gestion du titre manuel / auto
  let st = slide-title(resolve-slide-title(title), size: 1.2em, weight: "bold", inset: (bottom: 0.8em))

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
      show-level1-titles: nav-opts.show-level1-titles,
      show-level2-titles: nav-opts.show-level2-titles,
      show-numbering: show-num,
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
  set text(weight: "regular", fill: black)

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
        st
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
  let text-size = config.at("text-size", default: 20pt)
  
  block(width: 100%, height: 100%, fill: color, inset: 0pt, {
    set text(fill: white, size: text-size, weight: "regular")
    set align(center + horizon)
    body
  })
}

#let slide(..args) = {
  let pos = args.pos()
  let named = args.named()
  if pos.len() == 1 {
    p.slide(..named, apply-layout(pos.at(0)))
  } else {
    p.slide(..named, apply-layout(title: pos.at(0), pos.at(1)))
  }
}

#let template(
  title: none,
  subtitle: none,
  author: none,
  date: datetime.today().display(),
  color: rgb("#1a5fb4"),
  aspect-ratio: "16-9",
  text-font: "Lato",
  text-size: 20pt,
  show-heading-numbering: true,
  show-level1-titles: true,
  show-level2-titles: true,
  mapping: (section: 1, subsection: 2),
  auto-title: false,
  on-part-change: none,
  on-section-change: none,
  on-subsection-change: none,
  navigation: (),
  transitions: (),
  show-all-sections-in-transition: false,
  body,
  ..options,
) = {
  let nav-opts = (
    position: "top", fill: color, text-color: white, text-size: 0.6em,
    font: none, active-color: white, inactive-color: white.transparentize(60%),
    marker-shape: "circle", marker-size: 4pt, style: "compact",
    align-mode: "left", dots-align: "left", 
    show-level1-titles: show-level1-titles,
    show-level2-titles: show-level2-titles,
    gap: 2em, line-spacing: 0.8em,
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

  structure-config.update(conf => (
    mapping: mapping,
    auto-title: auto-title,
    text-size: text-size,
  ))

  config-state.update((
    nav-opts: nav-opts, margin-x: 2.5em, gap-zone: 1.5em,
    footer-content: context grid(
      columns: (1fr, 1fr, 1fr),
      align(left, if author != none { author }),
      align(center, if title != none { title }),
      align(right, counter(page).display("1 / 1", both: true))
    ), 
    color: color,
    text-size: text-size,
    show-heading-numbering: show-heading-numbering,
  ))

  set page(paper: "presentation-" + aspect-ratio, margin: 0pt, header: none, footer: none)
  set text(size: text-size, font: text-font)

  // Rule to record EVERYTHING including what's handled by other rules
  // This ensures headings are registered in the cache and their counters advance
  show heading: it => register-heading(it) + it
  
  show heading: set text(size: 1em, weight: "regular")
  set heading(outlined: true, numbering: (..nums) => {
    if show-heading-numbering and nums.pos().len() < 3 { numbering("1.1", ..nums) }
  })
  
  // Level 3 headings are registered but typically not rendered to avoid slide clutter IF mapped
  let mapped-levels = mapping.values()
  if 3 in mapped-levels {
    show heading.where(level: 3): it => register-heading(it)
  }

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
  let l2-mode = if show-all-sections-in-transition { "all" } else { "current-parent" }
  let l3-mode = if show-all-sections-in-transition { "all" } else { "current-parent" }

  let outline-styles = (
    level-1: (
      active: (weight: "bold", fill: white, size: 1.5em), 
      completed: (weight: "bold", fill: white.transparentize(50%), size: 1.5em),
      inactive: (weight: "bold", fill: white.transparentize(50%), size: 1.5em)
    ),
    level-2: (
      active: (weight: "regular", fill: white, size: 1.2em), 
      completed: (weight: "regular", fill: white.transparentize(50%), size: 1.2em),
      inactive: (weight: "regular", fill: white.transparentize(50%), size: 1.2em)
    ),
    level-3: (
      active: (weight: "regular", fill: white, size: 1.1em), 
      completed: (weight: "regular", fill: white.transparentize(50%), size: 1.1em),
      inactive: (weight: "regular", fill: white.transparentize(50%), size: 1.1em)
    ),
  )

  let outline-spacing = (
    indent-1: 0pt, indent-2: 1.5em, indent-3: 3em,
    v-between-1-1: 1.8em, 
    v-between-1-2: 1.5em, 
    v-between-2-1: 1.8em, 
    v-between-2-2: 0.8em, 
    v-between-2-3: 0.6em,
    v-between-3-3: 0.4em,
  )

  // Standard Transition Slide logic
  let default-transition(h, role) = p.slide(plain-layout({
    set align(top + left)
    v(25%)
    
    let get-mode(lvl) = {
      if is-role(mapping, lvl, "part") { l1-mode }
      else if role == "part" { "none" }
      else if role == "section" {
        if is-role(mapping, lvl, "section") { l2-mode }
        else if is-role(mapping, lvl, "subsection") { l3-mode }
        else { "none" }
      } else if role == "subsection" {
        if is-role(mapping, lvl, "section") { l2-mode }
        else if is-role(mapping, lvl, "subsection") { l3-mode }
        else { "none" }
      } else { "none" }
    }

    pad(left: 15%)[
      #progressive-outline(
        level-1-mode: get-mode(1),
        level-2-mode: get-mode(2),
        level-3-mode: get-mode(3),
        show-numbering: show-heading-numbering, numbering-format: "1.1 ",
        target-location: h.location(),
        text-styles: outline-styles,
        spacing: outline-spacing,
      )
    ]
    place(hide(h))
  }))

  // Unified Transition Rule
  show heading: h => {
    register-heading(h)
    if is-role(mapping, h.level, "part") {
      if on-part-change != none { on-part-change(h) }
      else if trans-opts.enabled { default-transition(h, "part") }
      else { place(hide(h)) }
    } else if is-role(mapping, h.level, "section") {
      if on-section-change != none { on-section-change(h) }
      else if trans-opts.enabled { default-transition(h, "section") }
      else { place(hide(h)) }
    } else if is-role(mapping, h.level, "subsection") {
      if on-subsection-change != none { on-subsection-change(h) }
      else if trans-opts.enabled and trans-opts.level >= 2 { default-transition(h, "subsection") }
      else { place(hide(h)) }
    } else {
      h
    }
  }

  set-options(..options)
  body
}