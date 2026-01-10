/// Global state to cache headings data
#let progressive-outline-cache = state("progressive-outline-cache", ())

/// Registers a heading into the cache. Returns the update content.
#let register-heading(it) = {
  if it.outlined {
    progressive-outline-cache.update(cache => {
      let loc = it.location()
      if cache.any(h => h.location() == loc) { return cache }
      cache.push(it)
      cache
    })
  } else {
    []
  }
}

/// Helper function to notify a heading occurrence to the state and return the heading
#let notify-heading(it) = {
  register-heading(it)
  it
}

/// Renders an item with jitter prevention.
#let render-item(
  body, 
  is-active: false, 
  text-style: (:), 
  active-text-style: (:),
  numbering-format: none,
  index: none,
) = {
  let base-style = text-style
  let active-style = active-text-style

  let fmt-num = if numbering-format != none and index != none {
    numbering(numbering-format, ..index) + " "
  } else { "" }

  let content-normal = text(..base-style)[#fmt-num#body]
  let content-active = text(..active-style)[#fmt-num#body]

  // Use a block with 100% width to allow wrapping and correct height calculation
  block(width: 100%, {
    // 1. Reserve space using the hidden active version (often the widest)
    hide(content-active)
    // 2. Place the visible version on top
    place(top + left, if is-active { content-active } else { content-normal })
  })
}

/// Returns the active headings (h1, h2, h3) at a given location using the cache.
#let get-active-headings(loc) = {
  let all-headings = progressive-outline-cache.final()
  let active-h1 = none
  let active-h2 = none
  let active-h3 = none
  
  for h in all-headings {
    // Basic location comparison
    if h.location().page() < loc.page() or (h.location().page() == loc.page() and h.location().position().y <= loc.position().y) {
      if h.level == 1 { active-h1 = h; active-h2 = none; active-h3 = none }
      else if h.level == 2 { active-h2 = h; active-h3 = none }
      else if h.level == 3 { active-h3 = h }
    } else {
      break
    }
  }
  (h1: active-h1, h2: active-h2, h3: active-h3)
}

#let progressive-outline(
  level-1-mode: "all", 
  level-2-mode: "current-parent",
  level-3-mode: "none",
  text-styles: (
    level-1: (active: (fill: rgb("#000000")), inactive: (fill: rgb("#888888"))),
    level-2: (active: (fill: rgb("#333333")), inactive: (fill: rgb("#aaaaaa"))),
    level-3: (active: (fill: rgb("#555555")), inactive: (fill: rgb("#cccccc"))),
  ),
  spacing: (
    indent-1: 0pt, indent-2: 1.5em, indent-3: 3em,
    v-between-1-1: 1em, v-between-1-2: 0.6em, v-between-2-1: 1em,
    v-between-2-2: 0.5em, v-between-2-3: 0.4em, v-between-3-3: 0.3em, 
    v-between-3-2: 0.8em, v-between-3-1: 1.2em,
    v-after-block: 0.5em,
  ),
  show-numbering: false,
  numbering-format: "1.1.1",
  target-location: auto,
) = {
  context {
    let loc = if target-location == auto { here() } else { target-location }
    let active-state = get-active-headings(loc)
    let active-h1 = active-state.h1
    let active-h2 = active-state.h2
    let active-h3 = active-state.h3
    
    let all-headings = progressive-outline-cache.final()
    let items-to-render = ()
    let last-level = 0

    for h in all-headings {
      let is-active = false
      let should-render = false
      let h-loc = h.location()

      if h.level == 1 {
        if active-h1 != none and h-loc == active-h1.location() { is-active = true }
        if level-1-mode == "all" { should-render = true }
        else if level-1-mode == "current" and is-active { should-render = true }
      } else if h.level == 2 {
        if active-h2 != none and h-loc == active-h2.location() { is-active = true }
        
        let is-child-of-active-h1 = false
        if active-h1 != none {
          let h2-count = counter(heading).at(h-loc)
          let h1-count = counter(heading).at(active-h1.location())
          if h2-count.at(0) == h1-count.at(0) {
            is-child-of-active-h1 = true
          }
        }
        
        if level-2-mode == "all" { should-render = true }
        else if level-2-mode == "current-parent" and is-child-of-active-h1 { should-render = true }
        else if level-2-mode == "current" and is-active { should-render = true }
      } else if h.level == 3 {
        if active-h3 != none and h-loc == active-h3.location() { is-active = true }
        
        let is-child-of-active-h2 = false
        if active-h2 != none {
          let h3-count = counter(heading).at(h-loc)
          let h2-count = counter(heading).at(active-h2.location())
          if h3-count.slice(0, 2) == h2-count.slice(0, 2) {
            is-child-of-active-h2 = true
          }
        }
        
        if level-3-mode == "all" { should-render = true }
        else if level-3-mode == "current-parent" and is-child-of-active-h2 { should-render = true }
        else if level-3-mode == "current" and is-active { should-render = true }
      }

      if should-render {
        let spacing-top = 0pt
        if items-to-render.len() > 0 {
          let key = "v-between-" + str(last-level) + "-" + str(h.level)
          spacing-top = spacing.at(key, default: spacing.at("v-after-block", default: 0.5em))
        }

        let styles-lvl = text-styles.at("level-" + str(h.level), default: (:))
        let s-active = styles-lvl.at("active", default: (:))
        let s-inactive = styles-lvl.at("inactive", default: (:))
        let indent = spacing.at("indent-" + str(h.level), default: 0pt)
        
        let idx = counter(heading).at(h-loc)
        let trimmed-idx = idx.slice(0, h.level)

        items-to-render.push(block(
          inset: (top: spacing-top, left: indent),
          render-item(
            h.body, 
            is-active: is-active,
            text-style: s-inactive, 
            active-text-style: s-active,
            numbering-format: if show-numbering { numbering-format } else { none },
            index: trimmed-idx,
          )
        ))
        last-level = h.level
      }
    }

    if items-to-render.len() > 0 {
      grid(columns: 1, ..items-to-render)
    }
  }
}
