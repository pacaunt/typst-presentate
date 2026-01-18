/// Standardized slide title component (visual only, no heading)
#let slide-title(content, size: 1.2em, weight: "bold", color: black, inset: (bottom: 0.8em)) = {
  if content == none { return none }
  block(
    width: 100%, 
    inset: inset, 
    text(size: size, weight: weight, fill: color, content)
  )
}
