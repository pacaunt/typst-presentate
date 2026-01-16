#import "../store.typ"

/// Extraction of the presentation structure.
/// Returns a dictionary with sections, each containing subsections, each containing logical slides.
#let get-structure() = {
  let headings = query(heading.where(outlined: true).or(heading.where(level: 1)).or(heading.where(level: 2)))
  let all-slides = query(metadata).filter(m => 
    type(m.value) == dictionary and m.value.at("t", default: none) == "LogicalSlide"
  )
  let normal-marker-pages = query(metadata.where(value: (t: "Miniframes_Normal"))).map(m => m.location().page())
  
  // Group slides by logical number to avoid duplicates from subslides (pauses)
  // and filter out transition slides
  let unique-slides = ()
  let seen-slide-numbers = ()
  for m in all-slides {
    let val = m.value.v
    let pg = m.location().page()
    if val not in seen-slide-numbers and pg in normal-marker-pages {
      seen-slide-numbers.push(val)
      unique-slides.push((number: val, loc: m.location()))
    }
  }

  let structure = ()
  let current-section = none
  let current-subsection = none

  // Sort headings by location
  let sorted-headings = headings.sorted(key: h => (h.location().page(), h.location().position().y))
  
  for h in sorted-headings {
    if h.level == 1 {
      current-section = (
        title: h.body,
        numbering: h.numbering,
        counter: counter(heading).at(h.location()),
        level: h.level,
        loc: h.location(),
        subsections: ()
      )
      structure.push(current-section)
      current-subsection = none
    } else if h.level == 2 {
      if current-section == none {
        // Subsection without section? Create a dummy section.
        current-section = (
          title: none,
          numbering: none,
          counter: (),
          level: 1,
          loc: h.location(),
          subsections: ()
        )
        structure.push(current-section)
      }
      current-subsection = (
        title: h.body,
        numbering: h.numbering,
        counter: counter(heading).at(h.location()),
        level: h.level,
        loc: h.location(),
        slides: ()
      )
      // We need to update the last section in the structure array
      structure.last().subsections.push(current-subsection)
    }
  }

  // If no sections/subsections were found, create a dummy one for slides
  if structure.len() == 0 {
    structure.push((title: none, loc: none, subsections: ((title: none, loc: none, slides: ()),)))
  }

  // Assign slides to subsections
  for s in unique-slides {
    // Find which heading this slide belongs to.
    // A slide belongs to the last heading that appears before it.
    let best-h1-idx = -1
    let best-h2-idx = -1

    for (i, h1) in structure.enumerate() {
      if h1.loc == none or s.loc.page() > h1.loc.page() or (s.loc.page() == h1.loc.page() and s.loc.position().y >= h1.loc.position().y) {
        best-h1-idx = i
        // Find H2 within this H1
        best-h2-idx = -1
        for (j, h2) in h1.subsections.enumerate() {
          if h2.loc == none or s.loc.page() > h2.loc.page() or (s.loc.page() == h2.loc.page() and s.loc.position().y >= h2.loc.position().y) {
            best-h2-idx = j
          }
        }
      }
    }

    if best-h1-idx != -1 {
      if best-h2-idx == -1 {
        // Slide belongs to H1 but no H2 yet. Create a dummy H2 if needed.
        if structure.at(best-h1-idx).subsections.len() == 0 {
          structure.at(best-h1-idx).subsections.push((title: none, loc: none, slides: (s,)))
        } else {
          // If there are H2s, but this slide is before the first H2?
          // For simplicity, attach to the first H2 or create one.
          structure.at(best-h1-idx).subsections.at(0).slides.push(s)
        }
      } else {
        structure.at(best-h1-idx).subsections.at(best-h2-idx).slides.push(s)
      }
    }
  }

  return structure
}

#let get-current-logical-slide-number() = {
  let current-page = here().page()
  let slides = query(metadata).filter(m => 
    type(m.value) == dictionary and m.value.at("t", default: none) == "LogicalSlide"
  )
  // Filter for slides on or before current page
  let past-slides = slides.filter(m => m.location().page() <= current-page)
  if past-slides.len() > 0 {
    return past-slides.last().value.v
  }
  return 1
}

#let render-miniframes(
  structure,
  current-slide-num,
  fill: black,
  text-color: white,
  text-size: 10pt,
  font: none,
  active-color: white,
  inactive-color: gray,
  marker-shape: "circle",
  marker-size: 4pt,
  style: "compact", // "compact" or "grid"
  align-mode: "left",
  dots-align: "left",
  show-section-titles: true,
  show-subsection-titles: true,
  show-numbering: false,
  gap: 1.5em,
  line-spacing: 4pt,
  inset: (x: 1em, y: 0.5em),
  width: 100%,
  outset-x: 0pt, // To cover margins
  radius: 0pt,
) = {
  let marker(is-active, is-future) = {
    let color = if is-active { active-color } else if is-future { inactive-color } else { active-color.transparentize(40%) }
    let radius = if marker-shape == "circle" { 50% } else { 0% }
    box(
      width: marker-size,
      height: marker-size,
      fill: color,
      radius: radius,
      baseline: marker-size * 0.1
    )
  }

  let render-dots(slides) = {
    stack(
      dir: ltr,
      spacing: marker-size * 0.8,
      ..slides.map(s => {
        let is-active = s.number == current-slide-num
        let is-future = s.number > current-slide-num
        let m = marker(is-active, is-future)
        if s.loc != none { link(s.loc, m) } else { m }
      })
    )
  }
  
  let fmt-title(item) = {
    let t = item.title
    if t == none { return none }
    if show-numbering and item.at("numbering", default: none) != none {
      // For miniframe bar, we usually want short numbering "1" or "1.1"
      // If the heading level is 1, use just "1". If 2, "1.1".
      let fmt = if item.at("level", default: 1) == 1 { "1" } else { "1.1" }
      let num = numbering(fmt, ..item.counter)
      t = [#num #t]
    }
    t
  }

  let content = {
    set text(fill: text-color, size: text-size)
    set par(leading: 0.8em) // Augmenté de 0.6em à 0.8em
    if font != none { set text(font: font) }
    
    let items = ()
    for section in structure {
      let is-section-active = section.subsections.any(sub => sub.slides.any(s => s.number == current-slide-num))
      
      let section-content = stack(
        dir: ttb,
        spacing: line-spacing,
        if show-section-titles and section.title != none {
          let t = fmt-title(section)
          let title-text = if is-section-active { strong(t) } else { t }
          let title-link = if section.loc != none { link(section.loc, title-text) } else { title-text }
          align(eval(dots-align), title-link)
        },
        if style == "compact" {
          // Combine all dots from all subsections
          let all-dots = section.subsections.map(sub => sub.slides).flatten()
          align(eval(dots-align), render-dots(all-dots))
        } else {
          // Grid mode: one line per subsection
          if show-subsection-titles {
            grid(
              columns: (auto, auto),
              column-gutter: 0.8em,
              row-gutter: line-spacing * 0.7,
              ..section.subsections.map(sub => (
                align(horizon, text(size: text-size * 0.85, fmt-title(sub))),
                align(horizon, render-dots(sub.slides))
              )).flatten()
            )
          } else {
            stack(
              dir: ttb,
              spacing: line-spacing * 0.7,
              ..section.subsections.map(sub => align(eval(dots-align), render-dots(sub.slides)))
            )
          }
        }
      )
      items.push(section-content)
    }

    grid(
      columns: (auto,) * items.len(),
      column-gutter: gap,
      ..items
    )
  }

  block(
    width: width,
    fill: fill,
    inset: inset,
    outset: (x: outset-x),
    radius: radius,
    // On retire height: auto et on laisse le contenu dicter la taille
    align(eval(align-mode), content)
  )
}
