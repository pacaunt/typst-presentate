/// Helper to compare two locations
#let is-after(loc-target, loc-reference) = {
  if loc-target.page() > loc-reference.page() { return true }
  if loc-target.page() == loc-reference.page() and loc-target.position().y > loc-reference.position().y { return true }
  return false
}

/// Calculates the current state of headings based on the current location.
#let get-current-headings(loc) = {
  let before-h1 = query(heading.where(outlined: true, level: 1).before(loc))
  let before-h2 = query(heading.where(outlined: true, level: 2).before(loc))
  let before-h3 = query(heading.where(outlined: true, level: 3).before(loc))

  let cur-h1 = if before-h1.len() > 0 { before-h1.last() } else { none }
  let cur-h2 = if before-h2.len() > 0 { before-h2.last() } else { none }
  let cur-h3 = if before-h3.len() > 0 { before-h3.last() } else { none }

  // Strict Parent-Child check
  if cur-h1 != none and cur-h2 != none {
    if not is-after(cur-h2.location(), cur-h1.location()) { cur-h2 = none }
  }
  if cur-h2 != none and cur-h3 != none {
    if not is-after(cur-h3.location(), cur-h2.location()) { cur-h3 = none }
  }
  if cur-h1 != none and cur-h3 != none {
    if not is-after(cur-h3.location(), cur-h1.location()) { cur-h3 = none }
  }

  (h1: cur-h1, h2: cur-h2, h3: cur-h3)
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
) = {
  context {
    let loc = here()
    let all-headings = query(heading.where(outlined: true))
    let active-state = get-current-headings(loc)

    let items-to-render = ()
    let last-level = 0

    for h in all-headings {
      let is-active = false
      let should-render = false
      let h-loc = h.location()

      if h.level == 1 {
        if active-state.h1 != none and h.location() == active-state.h1.location() { is-active = true }
        if level-1-mode == "all" { should-render = true }
        else if level-1-mode == "current" and is-active { should-render = true }
      } else if h.level == 2 {
        if active-state.h2 != none and h.location() == active-state.h2.location() { is-active = true }
        let is-child-of-current-h1 = false
        if active-state.h1 != none {
            let prev-h1 = query(heading.where(level: 1).before(h-loc))
            if prev-h1.len() > 0 and prev-h1.last().location() == active-state.h1.location() {
              is-child-of-current-h1 = true
            }
        }
        if level-2-mode == "all" { should-render = true }
        else if level-2-mode == "current-parent" and is-child-of-current-h1 { should-render = true }
        else if level-2-mode == "current" and is-active { should-render = true }
      } else if h.level == 3 {
        if active-state.h3 != none and h.location() == active-state.h3.location() { is-active = true }
        let is-child-of-current-h2 = false
        if active-state.h2 != none {
            let prev-h2 = query(heading.where(level: 2).before(h-loc))
            if prev-h2.len() > 0 and prev-h2.last().location() == active-state.h2.location() {
              is-child-of-current-h2 = true
            }
        }
        if level-3-mode == "all" { should-render = true }
        else if level-3-mode == "current-parent" and is-child-of-current-h2 { should-render = true }
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
        
        let idx = counter(heading).at(h.location())
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