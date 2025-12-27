#let progressive-outline(
  h1-style: "all",
  h2-style: "all",
  h3-style: "all",
  scope-h2: "current-h1",
  scope-h3: "current-h2",
  show-numbering: true,
  h1-text-style: (:),
  h2-text-style: (:),
  h3-text-style: (:),
  current-h2-text-style: (:),
  current-h3-text-style: (:),
) = {
  context {
    let loc = here()
    let all-headings = query(heading.where(outlined: true))

    let is-before(loc1, loc2) = {
      if loc1.page() < loc2.page() {
        return true
      }
      if loc1.page() == loc2.page() and loc1.position().y < loc2.position().y {
        return true
      }
      return false
    }

    let current-h1 = if query(heading.where(outlined: true, level: 1).before(loc)).len() > 0 {
      query(heading.where(outlined: true, level: 1).before(loc)).last()
    } else { none }

    let current-h2 = if query(heading.where(outlined: true, level: 2).before(loc)).len() > 0 {
      query(heading.where(outlined: true, level: 2).before(loc)).last()
    } else { none }

    let current-h3 = if query(heading.where(outlined: true, level: 3).before(loc)).len() > 0 {
      query(heading.where(outlined: true, level: 3).before(loc)).last()
    } else { none }

    let style-heading(heading, style, current, custom-style, current-custom-style) = {
      let content = if show-numbering {
        numbering("1.1.1", ..counter(heading.func()).at(heading.location())) + " " + heading.body
      } else {
        heading.body
      }
      
      let apply-style(content, style) = {
        return text(..style, content)
      }

      if style == "all" {
        return apply-style(content, custom-style)
      } else if style == "current" {
        if heading == current {
          return apply-style(content, custom-style)
        } else {
          return none
        }
      } else if style == "current-and-grayed" {
        if heading == current {
           return apply-style(content, current-custom-style)
        } else {
          return apply-style(content, custom-style)
        }
      } else if style == "none" {
        return none
      } else {
        return apply-style(content, custom-style)
      }
    }

    for heading in all-headings {
      let styled-heading = if heading.level == 1 {
        style-heading(heading, h1-style, current-h1, h1-text-style, h1-text-style)
      } else if heading.level == 2 {
        if scope-h2 == "current-h1" and current-h1 != none {
          let parent-h1 = all-headings.rev().find(h => h.level == 1 and is-before(h.location(), heading.location()))
          if parent-h1 != current-h1 {
            continue
          }
        }
        style-heading(heading, h2-style, current-h2, h2-text-style, current-h2-text-style)
      } else if heading.level == 3 {
        if scope-h3 == "current-h2" and current-h2 != none {
          let parent-h2 = all-headings.rev().find(h => h.level == 2 and is-before(h.location(), heading.location()))
          if parent-h2 != current-h2 {
            continue
          }
        }
        style-heading(heading, h3-style, current-h3, h3-text-style, current-h3-text-style)
      } else {
        heading.body
      }

      if styled-heading != none {
        let indent = 2em * (heading.level - 1)
        block(pad(left: indent, styled-heading))
      }
    }
  }
}