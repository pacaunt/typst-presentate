#import "../../src/progressive-outline.typ": progressive-outline, register-heading
#show heading: it => { register-heading(it); it }

#set page(paper: "a4", margin: 1.5cm)
#set text(font: "Lato", size: 10pt)
#set heading(numbering: "1.1")

// --- DEMONSTRATION COMPONENT ---
#let demo(title, code-str, result) = block(width: 100%, breakable: false)[
  #grid(
    columns: (1fr, 1.5fr),
    column-gutter: 1.5em,
    block(fill: luma(248), inset: 10pt, radius: 4pt, width: 100%,
      text(size: 7pt, font: "DejaVu Sans Mono", code-str)),
    block(stroke: 0.5pt + gray, inset: 10pt, radius: 4pt, width: 100%, [
      #text(weight: "bold", fill: navy, title)
      #v(0.5em)
      #result
    ])
  )
  #v(1.5em)
]

#align(center)[
  #text(size: 26pt, weight: "bold", fill: navy)[Guide: Progressive Outline] \ 
]
#v(2em)

= Function documentation
This section details all the parameters available for the `progressive-outline` function.

#table(
  columns: (1.5fr, 1fr, 3fr),
  inset: 8pt,
  align: horizon,
  fill: (x, y) => if y == 0 { navy.lighten(90%) },
  table.header([*Option*], [*Type*], [*Effect & Expected Values*]),
  [`level-X-mode`], [string], [Defines the visibility of level X (1, 2, or 3). \ Values: `"all"`, `"current"`, `"current-parent"`, `"none"`.],
  [`text-styles`], [dict], [Dictionary of Typst `text(...)` styles for each level. \ Structure: `(level-X: (active: (...), inactive: (...)))`.],
  [`spacing`], [dict], [Controls vertical space (`v-between-X-Y`) and horizontal indentation (`indent-X`) between elements.],
  [`show-numbering`], [bool], [Enables or disables the display of heading numbering.],
  [`numbering-format`], [str | func], [Typst numbering format (e.g., `"1.1"`) or custom function `(..n) => ...`.],
)

#v(2em)

= Visibility
This section covers the `level-X-mode` parameters.

== The 'current-parent' mode
The `current-parent` mode is the most powerful: it only displays the "siblings" of the current element. This allows you to see the plan of the current section without being distracted by other chapters.

#demo("Visibility Demonstration H2",
"progressive-outline(
  level-1-mode: 'all',
  level-2-mode: 'current-parent'
)",
progressive-outline(level-1-mode: "all", level-2-mode: "current-parent"))

== Isolation via 'current' mode
If you want an ultra-minimalist rendering, the `current` mode hides everything except the exact entry where you are located.

#demo("Isolated Visibility Demonstration",
"progressive-outline(
  level-1-mode: 'current',
  level-2-mode: 'none'
)",
progressive-outline(level-1-mode: "current", level-2-mode: "none"))

= Style Customization
The function allows you to modify the appearance of headings based on their state (active/inactive).

== The anti-jitter mechanism
Anti-jitter ensures that switching from a thin font to a bold one doesn't move the text. We use a ghost box to reserve the maximum space required.

#demo("Stability Test H1",
"text-styles: (
  level-1: (
    active: (weight: 'black', fill: eastern, size: 1.2em),
    inactive: (weight: 'light', fill: gray, size: 1.2em)
  )
)",
progressive-outline(level-2-mode: "none", text-styles: (level-1: (active: (weight: "black", fill: eastern, size: 1.2em), inactive: (weight: "light", fill: gray, size: 1.2em)))))

== Colors and decorations
Each level can have its own rules for colors, italics, or bold.

#demo("Creative Style H2",
"text-styles: (
  level-2: (
    active: (style: 'italic', fill: blue, weight: 'bold'),
    inactive: (fill: luma(200))
  )
)",
progressive-outline(level-2-mode: "all", text-styles: (level-2: (active: (style: "italic", fill: blue, weight: "bold"), inactive: (fill: luma(200))))))

= Fine-grained spacing management
The `spacing` dictionary sculpts the rhythm.

== Inter-level spacing
You can define the exact space between an H1 heading and an H2 heading, or between two headings of the same level.

#demo("Airy Vertical Rhythm",
"spacing: (
  v-between-1-1: 2em,
  v-between-1-2: 1.2em,
  v-between-2-2: 0.8em
)",
progressive-outline(level-2-mode: "all", spacing: (v-between-1-1: 2em, v-between-1-2: 1.2em, v-between-2-2: 0.8em)))

== Horizontal indentation
Indentation defines the offset to the right for each depth level.

#demo("Marked Indentation",
"spacing: (
  indent-2: 3em,
  indent-3: 6em
)",
progressive-outline(level-2-mode: "all", level-3-mode: "all", spacing: (indent-2: 3em, indent-3: 6em)))

= Numbering system
The function relies on Typst's native engine.

== Complex hierarchical formats
The `numbering-format` parameter accepts all standard Typst models (1, a, i, I, A).

#demo("Legal Format",
"show-numbering: true,
numbering-format: 'I.a.1. '",
progressive-outline(level-2-mode: "all", level-3-mode: "all", show-numbering: true, numbering-format: "I.a.1. "))

== Advanced textual prefixes
To use long words like "Chapter" without errors, pass a function. This prevents Typst from interpreting letters like 'a' or 'i' as numbering models.

#demo("Secure 'Chapter' Prefix",
"show-numbering: true,
numbering-format: (..n) => 'Chapter ' + numbering('1', ..n) + ' : '",
progressive-outline(
  level-1-mode: "all", 
  level-2-mode: "none", 
  show-numbering: true, 
  numbering-format: (..n) => "Chapter " + numbering("1", ..n) + " : "
))

= Additional information

It is optimized to work within presentation themes (like `progressive-outline`), but can be used in any standard Typst document.
