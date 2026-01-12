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
          label: if it.has("label") { it.label } else { none },
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
#let get-active-headings(loc, match-page-only: false) = {
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
        if match-page-only {
          is-before = true
        } else {
          let h-pos = h-loc.position()
          let loc-pos = loc.position()
          if h-pos != none and loc-pos != none and h-pos.y <= loc-pos.y {
            is-before = true
          }
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
  clickable: false,
  dest: none,
) = {
  let base-style = text-style
  let active-style = active-text-style
  let completed-style = if completed-text-style != none { completed-text-style } else { text-style }

  let fmt-num = if numbering-format != none and index != none {
    numbering(numbering-format, ..index) + " "
  } else { "" }

  let wrap-link(content) = {
    if clickable and dest != none {
      link(dest, content)
    } else {
      content
    }
  }

  let content-normal = wrap-link(text(..base-style)[#fmt-num#body])
  let content-active = wrap-link(text(..active-style)[#fmt-num#body])
  let content-completed = wrap-link(text(..completed-style)[#fmt-num#body])

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

/// Helper to resolve styles with opacity/inheritance logic
#let resolve-state-style(active-style, target-style) = {
  if type(target-style) == float or type(target-style) == int {
    // Case 1: Float shortcut -> Clone active style + apply opacity
    let new-style = active-style
    let c = new-style.at("fill", default: black)
    // opacity 0.3 means 70% transparency
    new-style.insert("fill", c.transparentize((1.0 - float(target-style)) * 100%))
    new-style
  } else if type(target-style) == dictionary {
    // Case 2: Dictionary -> Check for 'opacity' key
    if "opacity" in target-style {
      let new-style = (:)
      let alpha = 1.0
      // Copy properties except 'opacity'
      for (k, v) in target-style {
        if k == "opacity" {
          alpha = float(v)
        } else {
          new-style.insert(k, v)
        }
      }
      
      // Resolve color: Target fill > Active fill > Black
      let base-color = if "fill" in new-style {
        new-style.fill
      } else {
        active-style.at("fill", default: black)
      }
      
      new-style.insert("fill", base-color.transparentize((1.0 - alpha) * 100%))
      new-style
    } else {
      // Case 3: Standard dictionary without opacity
      target-style
    }
  } else {
    target-style
  }
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
  match-page-only: false,
  filter: none,
  headings: auto,
  clickable: true,
) = {
  context {
    let loc = if target-location == auto { here() } else { target-location }
    let active-state = get-active-headings(loc, match-page-only: match-page-only)
    let active-h1 = active-state.h1
    let active-h2 = active-state.h2
    let active-h3 = active-state.h3
    
    let all-headings = if headings == auto { progressive-outline-cache.final() } else { headings }
    let items-to-render = ()
    let last-level = 0

    let current-h1 = none
    let current-h2 = none
    let is-h1-filtered = false
    let is-h2-filtered = false

    for h in all-headings {
      if h.level == 1 { 
        current-h1 = h; current-h2 = none
        is-h1-filtered = false; is-h2-filtered = false
      } else if h.level == 2 { 
        current-h2 = h; is-h2-filtered = false 
      }

      let explicitly-filtered = (filter != none and not filter(h + (parent-h1: current-h1, parent-h2: current-h2)))
      let implicitly-filtered = (h.level > 1 and is-h1-filtered) or (h.level > 2 and is-h2-filtered)

      if explicitly-filtered or implicitly-filtered { 
        if h.level == 1 { is-h1-filtered = true }
        else if h.level == 2 { is-h2-filtered = true }
        continue 
      }

      let is-active = false
      let is-completed = false
      let should-render = false
      let h-loc = h.location

      if h.level == 1 {
        if active-h1 != none and h-loc == active-h1.location { is-active = true }
        else {
           if active-h1 != none and h-loc != none {
             if h-loc.page() < active-h1.location.page() or (h-loc.page() == active-h1.location.page() and h-loc.position() != none and active-h1.location.position() != none and h-loc.position().y < active-h1.location.position().y) { is-completed = true }
           }
        }
        
        if level-1-mode == "all" { should-render = true }
        else if level-1-mode == "current" and is-active { should-render = true }
      } else if h.level == 2 {
        if active-h2 != none and h-loc == active-h2.location { is-active = true }
        else {
           if active-h2 != none and h-loc != none {
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
           if active-h3 != none and h-loc != none {
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
        let raw-active = styles-lvl.at("active", default: (:))
        let raw-inactive = styles-lvl.at("inactive", default: (:))
        let raw-completed = styles-lvl.at("completed", default: none)
        
        // Resolve intelligent styles
        let s-active = raw-active
        let s-inactive = resolve-state-style(s-active, raw-inactive)
        let s-completed = resolve-state-style(s-active, raw-completed)
        
        let indent = spacing.at("indent-" + str(h.level), default: 0pt)
        
        let trimmed-idx = if h.counter.len() >= h.level {
          h.counter.slice(0, h.level)
        } else {
          h.counter
        }

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
            clickable: clickable,
            dest: h-loc,
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