#import "../store.typ"
#import "progressive-outline.typ": get-active-headings

/// Global state for structure mapping and auto-titling
#let structure-config = state(store.prefix + "structure-config", (
  mapping: (section: 1, subsection: 2),
  auto-title: false,
  show-heading-numbering: true,
  numbering-format: "1.1",
))

/// Resolves the title for a slide based on manual input and global config.
#let resolve-slide-title(manual-title) = context {
  if manual-title != none { return manual-title }
  
  let config = structure-config.get()
  if not config.auto-title { return none }
  
  let active = get-active-headings(here())
  let mapping = config.mapping
  
  let format-title(h) = {
    if h == none { return none }
    let body = h.body
    if config.at("show-heading-numbering", default: false) and h.at("numbering", default: none) != none {
      let fmt = config.at("numbering-format", default: "1.1")
      return numbering(fmt, ..h.counter) + " " + body
    }
    body
  }
  
  // Try to find the title from the lowest mapped level available
  if "subsection" in mapping and mapping.subsection != none {
    let lvl = "h" + str(mapping.subsection)
    if active.at(lvl, default: none) != none { return format-title(active.at(lvl)) }
  }
  
  if "section" in mapping and mapping.section != none {
    let lvl = "h" + str(mapping.section)
    if active.at(lvl, default: none) != none { return format-title(active.at(lvl)) }
  }
  
  if "part" in mapping and mapping.part != none {
    let lvl = "h" + str(mapping.part)
    if active.at(lvl, default: none) != none { return format-title(active.at(lvl)) }
  }
  
  return none
}

/// Helper to check if a heading level matches a mapped role
#let is-role(mapping, lvl, role) = {
  return mapping.at(role, default: none) == lvl
}
