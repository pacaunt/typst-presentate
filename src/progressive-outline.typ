/// Global state to cache headings data
#let progressive-outline-cache = state("progressive-outline-cache", ())

/// Registers a heading into the cache. Returns the update content.
#let register-heading(it) = {
  if it.outlined {
    context {
      let loc = it.location()
      let count = counter(heading).at(loc)
      progressive-outline-cache.update(cache => {
        if cache.any(h => h.location == loc) { return cache }
        let new-h = (
          body: it.body,
          level: it.level,
          counter: count,
          numbering: it.numbering,
          location: loc,
        )
        cache.push(new-h)
        cache
      })
    }
  } else {
    []
  }
}

/// Helper function to notify a heading occurrence to the state and return the heading
#let notify-heading(it) = register-heading(it) + it

/// Returns the active headings (h1, h2, h3) at a given location using the cache.
#let get-active-headings(loc) = {
  let all-headings = progressive-outline-cache.final()
  let active-h1 = none
  let active-h2 = none
  let active-h3 = none
  
  for h in all-headings {
    let h-loc = h.location
    let is-match = (h-loc == loc)
    let is-before = false
    
    if not is-match {
      if h-loc.page() < loc.page() {
        is-before = true
      } else if h-loc.page() == loc.page() {
        let h-pos = h-loc.position()
        let loc-pos = loc.position()
        if h-pos != none and loc-pos != none and h-pos.y <= loc-pos.y {
          is-before = true
        }
      }
    }

    if is-match or is-before {
      if h.level == 1 { active-h1 = h; active-h2 = none; active-h3 = none }
      else if h.level == 2 { active-h2 = h; active-h3 = none }
      else if h.level == 3 { active-h3 = h }
    } else {
      break
    }
  }
  (h1: active-h1, h2: active-h2, h3: active-h3)
}

/// Renders an item with jitter prevention.
#let render-item(
  body, 
  is-active: false, 
  is-completed: false,
  text-style: (:), 
  active-text-style: (:),
  completed-text-style: none,
  numbering-format: none,
  index: none,
) = {
  let base-style = text-style
  let active-style = active-text-style
  let completed-style = if completed-text-style != none { completed-text-style } else { text-style }

  let fmt-num = if numbering-format != none and index != none {
    numbering(numbering-format, ..index) + " "
  } else { "" }

  let content-normal = text(..base-style)[#fmt-num#body]
  let content-active = text(..active-style)[#fmt-num#body]
  let content-completed = text(..completed-style)[#fmt-num#body]

  let target-content = if is-active { 
    content-active 
  } else if is-completed {
    content-completed
  } else { 
    content-normal 
  }

  block(width: 100%, {
    hide(content-active)
    place(top + left, target-content)
  })
}

#let progressive-outline(
  level-1-mode: "all", 
  level-2-mode: "current-parent",
  level-3-mode: "none",
  text-styles: (
    level-1: (
      active: (fill: rgb("#000000"), weight: "bold"), 
      completed: (fill: rgb("#888888"), weight: "bold"),
      inactive: (fill: rgb("#000000"), weight: "bold")
    ),
    level-2: (
      active: (fill: rgb("#000000"), weight: "bold"), 
      completed: (fill: rgb("#aaaaaa"), weight: "regular"),
      inactive: (fill: rgb("#333333"), weight: "regular")
    ),
    level-3: (
      active: (fill: rgb("#000000"), weight: "bold"), 
      completed: (fill: rgb("#cccccc"), weight: "regular"),
      inactive: (fill: rgb("#555555"), weight: "regular")
    ),
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
      let is-completed = false
      let should-render = false
      let h-loc = h.location

      if h.level == 1 {
        if active-h1 != none and h-loc == active-h1.location { is-active = true }
        else {
           if active-h1 != none {
             if h-loc.page() < active-h1.location.page() or (h-loc.page() == active-h1.location.page() and h-loc.position() != none and active-h1.location.position() != none and h-loc.position().y < active-h1.location.position().y) { is-completed = true }
           }
        }
        
        if level-1-mode == "all" { should-render = true }
        else if level-1-mode == "current" and is-active { should-render = true }
      } else if h.level == 2 {
        if active-h2 != none and h-loc == active-h2.location { is-active = true }
        else {
           if active-h2 != none {
             if h-loc.page() < active-h2.location.page() or (h-loc.page() == active-h2.location.page() and h-loc.position() != none and active-h2.location.position() != none and h-loc.position().y < active-h2.location.position().y) { is-completed = true }
           }
        }
        
        let is-child-of-active-h1 = false
        if active-h1 != none {
          if h.counter.at(0) == active-h1.counter.at(0) {
            is-child-of-active-h1 = true
          }
        }
        
        if level-2-mode == "all" { should-render = true }
        else if level-2-mode == "current-parent" and is-child-of-active-h1 { should-render = true }
        else if level-2-mode == "current" and is-active { should-render = true }
      } else if h.level == 3 {
        if active-h3 != none and h-loc == active-h3.location { is-active = true }
        else {
           if active-h3 != none {
             if h-loc.page() < active-h3.location.page() or (h-loc.page() == active-h3.location.page() and h-loc.position() != none and active-h3.location.position() != none and h-loc.position().y < active-h3.location.position().y) { is-completed = true }
           }
        }
        
        let is-child-of-active-h2 = false
        if active-h2 != none {
          if h.counter.slice(0, 2) == active-h2.counter.slice(0, 2) {
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
        let s-completed = styles-lvl.at("completed", default: none)
        let indent = spacing.at("indent-" + str(h.level), default: 0pt)
        
        let trimmed-idx = h.counter.slice(0, h.level)

        items-to-render.push(block(
          inset: (top: spacing-top, left: indent),
          render-item(
            h.body, 
            is-active: is-active,
            is-completed: is-completed,
            text-style: s-inactive, 
            active-text-style: s-active,
            completed-text-style: s-completed,
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