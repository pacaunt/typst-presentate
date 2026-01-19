#import "structure.typ": is-role
#import "../utils.typ": merge-dicts
#import "progressive-outline.typ": progressive-outline

/// Default configuration for the transition engine
#let default-transitions = (
  enabled: true,
  max-level: 3,
  show-numbering: true,
  background: "theme",
  filter: none,
  parts: (
    enabled: true,
    visibility: (part: "all", section: "none", subsection: "none"),
    background: auto, // Use auto to detect if user provided a specific one
  ),
  sections: (
    enabled: true,
    visibility: (part: "current", section: "current", subsection: "current-parent"),
    background: auto,
  ),
  subsections: (
    enabled: true,
    visibility: (part: "current", section: "current", subsection: "current-parent"),
    background: auto,
  ),
  style: (
    inactive-opacity: 0.3,
    completed-opacity: 0.6,
    active-weight: "bold",
    active-color: none, 
  ),
)

/// Resolves the background color based on configuration and theme colors
#let resolve-background(bg-option, theme-colors) = {
  if bg-option == "theme" {
    theme-colors.at("primary", default: white)
  } else if bg-option == "none" {
    none 
  } else if bg-option == none {
    none
  } else {
    bg-option // Explicit color
  }
}

/// Resolves the active color based on priority
#let resolve-active-color(style-options, theme-colors, final-bg-option) = {
  if style-options.active-color != none {
    style-options.active-color
  } else {
     // Auto-resolution: if background is theme (usually colored), default to white
     // if background is none/white, default to theme accent/primary
     if final-bg-option == "theme" {
       white 
     } else {
       if "accent" in theme-colors { theme-colors.accent }
       else if "primary" in theme-colors { theme-colors.primary }
       else { black }
     }
  }
}

/// Main function to render a transition slide
#let render-transition(
  h, 
  transitions: (:), 
  mapping: (:), 
  show-heading-numbering: true,
  numbering-format: "1.1",
  theme-colors: (:),
  slide-func: none, 
) = {
  // 1. Merge options
  let options = merge-dicts(transitions, base: default-transitions)
  
  // Use global toggle if not explicitly overridden in transitions dict
  let final-show-numbering = if "show-numbering" in transitions { options.show-numbering } else { show-heading-numbering }

  // 2. Global checks
  if not options.enabled { return place(hide(h)) }
  if h.level > options.max-level { return place(hide(h)) }
  if options.filter != none and not (options.filter)(h) { return place(hide(h)) }

  // 3. Role identification
  let role = none
  if is-role(mapping, h.level, "part") { role = "parts" }
  else if is-role(mapping, h.level, "section") { role = "sections" }
  else if is-role(mapping, h.level, "subsection") { role = "subsections" }

  // If not mapped or unknown role, hide
  if role == none { return place(hide(h)) }

  // 4. Role-specific configuration
  let role-config = options.at(role)
  if not role-config.enabled { return place(hide(h)) }

  // 5. Resolve styles and colors
  // Logic: Role background > Global background
  let final-bg-option = if role-config.background != auto {
    role-config.background
  } else {
    options.background
  }
  
  let bg-color = resolve-background(final-bg-option, theme-colors)
  let final-active-color = resolve-active-color(options.style, theme-colors, final-bg-option)

  // Define text styles for progressive-outline
  let common-active = (
    weight: options.style.active-weight, 
    fill: final-active-color,
    size: 1.2em, // Increase size for transition slides
  )
  
  // Calculate inactive/completed opacity
  let inactive-style = (opacity: options.style.inactive-opacity, size: 1.2em)
  let completed-style = (opacity: options.style.completed-opacity, size: 1.2em)

  let text-styles = (
    level-1: (active: common-active, inactive: inactive-style, completed: completed-style),
    level-2: (active: common-active, inactive: inactive-style, completed: completed-style),
    level-3: (active: common-active, inactive: inactive-style, completed: completed-style),
  )

  // 6. Map visibility to progressive-outline modes
  let vis = role-config.visibility
  let level-modes = (
    level-1-mode: "none",
    level-2-mode: "none",
    level-3-mode: "none"
  )
  
  if "part" in mapping { level-modes.insert("level-" + str(mapping.part) + "-mode", vis.at("part", default: "none")) }
  if "section" in mapping { level-modes.insert("level-" + str(mapping.section) + "-mode", vis.at("section", default: "none")) }
  if "subsection" in mapping { level-modes.insert("level-" + str(mapping.subsection) + "-mode", vis.at("subsection", default: "none")) }

  // 7. Render
  slide-func(fill: bg-color, {
    set align(top + left)
    v(40%)
    
    pad(x: 10%, {
       progressive-outline(
        level-1-mode: level-modes.level-1-mode,
        level-2-mode: level-modes.level-2-mode,
        level-3-mode: level-modes.level-3-mode,
        show-numbering: final-show-numbering,
        numbering-format: numbering-format,
        target-location: h.location(),
        text-styles: text-styles,
        filter: options.filter,
      )
    })
    
    place(hide(h)) 
  })
}