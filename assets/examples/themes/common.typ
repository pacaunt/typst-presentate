// Common content for all theme demonstrations

/// --- 1. PRESENTATION CONTENT SAMPLES ---

#let introduction_slides(slide_fn, rationale) = {
  [= Introduction]
  slide_fn("About Presentate")[
    Presentate is a flexible Typst template for professional presentations.
    - *Zero-Jitter*: Transitions are engineered for perfect pixel-alignment.
    - *Mapping*: Explicit role assignment for heading levels.
  ]
  slide_fn("Theme Rationale")[
    #rationale
  ]
}

#let part_simple_demo(slide_fn, rationale) = {
  [= Part 1: Simple Overview]
  slide_fn("About Presentate")[
    Presentate is a flexible Typst template for professional presentations.
    - *Zero-Jitter*: Transitions are engineered for perfect pixel-alignment.
    - *Mapping*: Explicit role assignment for heading levels.
  ]
  slide_fn("Theme Rationale")[
    #rationale
  ]
}

#let part_sectioned_demo(slide_fn) = {
  [= Part 2: Core Features]
  [== Standard Formatting]
  slide_fn("Text & Math")[
    - *Emphasis*, _italics_, and `code` blocks.
    - Math equations: $phi = (1 + sqrt(5)) / 2$.
  ]
  [== Advanced Layouts]
  slide_fn("Columns & Blocks")[
    #block(fill: luma(240), inset: 1em, radius: 4pt, width: 100%)[
      Use blocks to highlight important notes.
    ]
  ]
}

#let part_nested_demo(slide_fn) = {
  [= Part 3: Nested Structure]
  [== Navigation Logic]
  [=== Structure Mapping]
  slide_fn("The Mapping Contract")[
    Map heading levels to logical roles in the template.
  ]
  [=== Auto-Titling]
  slide_fn("Dynamic Headers")[
    `auto-title: true` synchronizes slide headers with the current subsection.
  ]
}

/// 2-LEVEL DEMO: Simple Section (Section only, no subsections)
#let section_simple_demo(slide_fn) = {
  [= 1. Simple Section]
  slide_fn("About Presentate")[
    This is a level 1 heading acting as a *Section*.
    In a 2-level mapping, this triggers the main transition slides.
  ]
}

/// 2-LEVEL DEMO: Nested Section (Section and Subsections)
#let section_nested_demo(slide_fn) = {
  [= 2. Nested Section]
  [== 2.1 First Subsection]
  slide_fn("Sub-slide A")[
    This is a level 2 heading acting as a *Subsection*.
  ]
  [== 2.2 Second Subsection]
  slide_fn("Sub-slide B")[
    Another subsection to demonstrate progress tracking.
  ]
}

/// MIXED LEVELS DEMO: 3 levels of headings with 2 levels of mapping
#let mixed_levels_demo(slide_fn) = {
  [= 1. Mapped Section (L1)]
  slide_fn("Observation")[
    Level 1 is mapped to *Section*. It creates a transition slide.
  ]
  
  [== 1.1 Mapped Subsection (L2)]
  slide_fn("Observation")[
    Level 2 is mapped to *Subsection*. It appears in the navigation.
  ]
  
  [=== 1.1.1 Unmapped Heading (L3)]
  slide_fn("Invisible Level 3")[
    Level 3 is *NOT* mapped. 
    - It does not trigger a transition.
    - It does not appear in the navigation bar.
    - It is hidden from the slide body by default.
  ]
}

/// FEATURE DEMO: Showcases Context-Switching and In-Slide Headings
#let feature_demo_slides(slide_fn) = {
  [= 1. Structural Heading (Root)]
  
  slide_fn("Context-Switching Demo")[
    This slide demonstrates how headings behave differently inside a slide.
    
    = Level 1 In-Slide
    This is rendered as a *Block Title* with a sidebar.
    
    == Level 2 In-Slide
    This is rendered as a *Sub-title*.
    
    === Level 3 In-Slide
    This is rendered as *Emphasized* content.
  ]
  
  [== Sub-Structure (Root)]
  
  slide_fn("Visual Validation")[
    The headings above organized the content without creating new slides or polluting the sidebar.
  ]
}

/// --- 2. GLOBAL OPTIONS DOCUMENTATION ---

#let global_options_slides(slide_fn) = {
  [= Global Configuration]
  
  [== Metadata & Layout]
  slide_fn("Document Setup")[
    Common arguments for all templates:
    - `title`, `subtitle`, `author`, `date`: Document information.
    - `aspect-ratio`: `"16-9"` (default) or `"4-3"`.
    - `show-heading-numbering`: `true` or `false`.
  ]

  [== Typography]
  slide_fn("Font Settings")[
    Presentate UI scales automatically with these options:
    - `text-font`: Base font family (default: `"Lato"`).
    - `text-size`: Base font size (default: `20pt`).
    
    ```typ
    #show: template.with(
      text-font: "Roboto",
      text-size: 22pt,
    )
    ```
  ]

  [== Structural Mapping]
  slide_fn("Level Roles")[
    Explicitly define what each `=` level represents:
    - `mapping: (part: 1, section: 2, subsection: 3)`
    - `auto-title: true`: Automatically titles slides using the lowest mapped level.
  ]

  [== Transition Logic]
  slide_fn("Transitions & Hooks")[
    Control automatic transition slides:
    - `transitions: (enabled: true, level: 2)`
    - `on-part-change`: Custom hook for level 1.
    - `on-section-change`: Custom hook for level 2.
    - `on-subsection-change`: Custom hook for level 3.
  ]
}