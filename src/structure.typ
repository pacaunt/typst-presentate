#import "store.typ"
#import "components/progressive-outline.typ": get-active-headings

/// Global state for structure mapping and auto-titling
#let structure-config = state(store.prefix + "structure-config", (
  mapping: (section: 1, subsection: 2),
  auto-title: false,
))

/// Resolves the title for a slide based on manual input and global config.
#let resolve-slide-title(manual-title) = context {
  if manual-title != none { return manual-title }
  
  let config = structure-config.get()
  if not config.auto-title { return none }
  
  let active = get-active-headings(here())
  let mapping = config.mapping
  
  // Try to find the title from the lowest mapped level available
  if "subsection" in mapping and mapping.subsection != none {
    let lvl = "h" + str(mapping.subsection)
    if active.at(lvl, default: none) != none { return active.at(lvl).body }
  }
  
  if "section" in mapping and mapping.section != none {
    let lvl = "h" + str(mapping.section)
    if active.at(lvl, default: none) != none { return active.at(lvl).body }
  }
  
  if "part" in mapping and mapping.part != none {
    let lvl = "h" + str(mapping.part)
    if active.at(lvl, default: none) != none { return active.at(lvl).body }
  }
  
  return none
}

/// Helper to check if a heading level matches a mapped role
#let is-role(mapping, lvl, role) = {
  return mapping.at(role, default: none) == lvl
}