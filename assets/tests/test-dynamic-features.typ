#import "../../src/themes/structured/progressive-outline.typ": template, slide, empty-slide
#import "../../src/render.typ": pause, uncover, only, fragments, step-item, alert, transform, render
#import "../../src/animation.typ"
#import "../../src/utils.typ"

#show: template.with(
  title: [Presentate: Dynamic Features],
  subtitle: [A systematic test of animation tools],
  author: [David Hajage],
  mapping: (section: 1, subsection: 2),
  auto-title: true,
)

= Introduction

#slide[Welcome][
  This presentation demonstrates the dynamic capabilities of *Presentate*.
  
  We will cover:
  #step-item[
    - Basic flow control (`pause`, `fragments`)
    - Precise visibility (`uncover`, `only`)
    - Relative indices and timeline synchronization
    - Content transformations (`alert`, `transform`)
    - Advanced package integration (`render`)
  ]
]

= Basic Flow Control

#slide[Using `#pause`][
  The `#pause` function (or `#show: pause`) allows you to reveal content in chunks.
  
  #show: pause
  Chunk 1: First, this line appears.
  
  #show: pause
  Chunk 2: Then, this second line is revealed.
  
  #show: pause
  Chunk 3: Finally, you see this one.
  
  #show: pause
  You can even pause inside math:
  $ (a + b)^2 pause( = a^2 + 2 a b + b^2 ) $
]

#slide[Using `#fragments`][
  `#fragments` is a shorthand for revealing multiple pieces of content one after another.
  
  #fragments(
    [Fragment A: Individual content...],
    [Fragment B: ...revealed one by one...],
    [Fragment C: ...without multiple pause calls.]
  )
]

#slide[Using `#step-item`][
  `#step-item` is optimized for lists. It can even hide list markers and supports nesting.
  
  #step-item[
    - Outer Item 1
      #step-item[
        - Nested A
        - Nested B
      ]
    - Outer Item 2
    - Outer Item 3
  ]
]

= Precise Visibility

#slide[`#uncover` vs `#only`][
  These functions allow you to show content on specific subslides.
  
  #utils.multicols(2)[
    *#uncover(none, [uncover])*
    - Preserves space when hidden.
    - Uses `hide()` by default.
    
    #uncover(2, 4)[Shown on subslides 2 and 4.]
    #uncover(from: 3)[Shown from subslide 3 onwards.]
  ][
    *#only(none, [only])*
    - Discards space when hidden.
    - Content is completely removed.
    
    #only(2, 4)[Shown on subslides 2 and 4.]
    #only(from: 3)[Shown from subslide 3 onwards.]
  ]
]

= Relative Indices

#slide[Relative Indices: `auto`, `none`, `rel`][
  Instead of hardcoding subslide numbers, use relative indices.
  
  - Current pause state: Content A #show: pause; Content B
  
  - #uncover(auto)[`auto`]: Shown *after* the current pause (next step).
  - #only(none)[`none`]: Shown *at* the same time as the current pause.
  - #uncover((rel: 2))[ `(rel: 2)`]: Shown 2 steps after the current pause.
]

#slide[Timeline Synchronization][
  Use `update-pause: true` to make subsequent pauses "aware" of the subslides added by `uncover` or `only`.
  
  1. Regular Step #show: pause;
  2. Hidden Step #uncover(auto, [SURPRISE!], update-pause: true)
  3. This step waits for the surprise because of `update-pause`.
]

= Content Transformations

#slide[Alerts and Emphasis][
  `#alert` wraps content in a function (default is `emph`) on a specific subslide.
  
  #step-item[
    - Item 1
    - #alert(auto)[Item 2 (Alerted!)]
    - Item 3
  ]
  
  #show: pause
  You can customize the alert function:
  #alert(auto, func: text.with(fill: red))[DANGER ALERT]
]

#slide[Complex Transformations][
  `#transform` allows a sequence of functions to be applied to content across subslides.
  
  #let blue-text(body) = text(fill: blue, body)
  #let red-text(body) = text(fill: red, body)
  
  #transform([DYNAMISM], blue-text, red-text, it => strike(it))
]

= Advanced Integration

#slide[The `#render` Workspace][
  `#render` is the most powerful tool for integrating other packages (CeTZ, Fletcher).
  It lets you manually update the subslide state `s`.
  
  #render(s => {
    let sub = s.at(0).subslide
    let (fill-color, label) = if sub == 1 { 
      (gray, [Subslide 1: Cooling Down]) 
    } else if sub == 2 { 
      (orange, [Subslide 2: Heating Up!]) 
    } else { 
      (red, [Subslide 3: BOILING POINT!]) 
    }
    
    let content = rect(
      width: 100%, 
      height: 2em, 
      fill: fill-color,
      align(center + horizon, text(white, label))
    )
    s.push(auto)
    return (content, s)
  })
]

= Conclusion

#slide[Summary][
  Presentate provides a robust framework for:
  #step-item[
    - Chaining animations easily.
    - Targeting specific subslides.
    - Synchronizing multiple components.
    - Hooking into external drawing libraries.
  ]
  
  #show: pause
  Happy Presenting!
]