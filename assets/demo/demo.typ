#import "@local/presentate:0.3.1": *
#import "@preview/codly:1.3.0": codly, codly-init
#import "@preview/calloutly:1.2.0" as cly
#import themes.progressive-outline: *

#let important = bridge(mode: "content", cly.important)
#let tip = bridge(mode: "content", cly.tip)
#let caution = bridge(mode: "content", cly.caution)
#let note = bridge(mode: "content", cly.note)

// #show: codly-init
#show: cly.calloutly.with(style: "quarto")
#show: template.with(
  title: [Presentate Demo],
  subtitle: [Presentation with Extensible Package Integrations],
  author: [\@pacaunt],
  text-size: 25pt,
)

#set raw(lang: "typ")

#set heading(numbering: "1.1")

#slide[Agenda][
  #outline(title: none)
]

= Quick Start

#slide[Import the Package][
  To follow this demo,
  Simply import Presentate from Typst Universe and set the theme:
  ```typst
  #import "@preview/presentate:0.3.0": *
  #import themes.progressive-outline: *
  #show: template
  ```
  Then, all functionality becomes available.
]

= Simple animations

#slide[Using `#pause` and `#meanwhile`][
  You can use `#pause` to reveal contents chunk by chunk, and `#meanwhile` to reveal another sequence in parallel.

  #pause
  - First Chunk #pause
  - Second Chunk #pause
  - Third Chunk
  #meanwhile
  ...Meanwhile, another... #pause
  parallel... #pause text... #pause is revealed.
]

#slide[Precise animation with `#uncover` and `#only`][
  You can see #uncover(1, 3)[this text] in subslide 1 and 3,

  This line has a #only(2)[*BIG*] surprise.
  #jump(4)
  #note[
    `#uncover()` reserves the space because it uses `#hide()` by default,
    while `#only()` *does not reserve space* because it deletes the content by applying `it => none` as hider.
  ]
]

#slide[Alert/Transform --- Change the Look][
  This line is #alert(auto, update: true)[important.] #pause

  Which of this is irrational? #transform(start: auto, [$pi$], it => it, [$22/7$], text.with(fill: olive))
  #meanwhile
  #note[
    `#alert()` applies `#emph()` function on the text, while `#transform()` applies the specified functions/replaces the contents step by step.
  ]
]

#slide[Index Specifications][
  In Presentate, apart from interger-based indices, there are also #pause 
  - ```typc auto``` --- to display after the current pauses, #pause 
  - ```typc none``` --- to display with the current pauses, #pause 
  - ```typc <name>``` --- to display with the marker ```typc <name>```, defined by using `#marker(<name>, at: index)` at anywhere on the same slide, #pause
  - ```typc (rel: int, to: index)``` --- display `int` subslide relative to the `index`. 
]

#slide[Relative Index Example][
  #set text(size: 0.8em)
  #grid(columns: (1fr,) * 3, gutter: 1em)[
    *First Column* #pause 

    This step is named ```typc <first>```
    #marker(<first>)

    #pause 
    It has its own timeline.
  ][
    #jump(<first>)
    *Second Column* 

    This is shown _with_ ```typc <first>```
  ][
    #jump((rel: 1, to: <first>))
    *Third Column*

    This is shown _after_ ```typc <first>```
    It was `#jump((rel: 1, to: <first>))`
  ]
  #note[
    - `#pause` and `#jump()` _work_ across containers.
    - `#jump(index)` sets the current pauses to `index`. 
  ]
]

= Package Integration
#slide[CeTZ Example][
  #set text(size: 16pt)
  ```
  #import "@preview/cetz:0.5.2": canvas, draw 
  #let canvas = interface(canvas, inner: "array", hider: draw.hide.with(bounds: true))
  #let uncover = uncover.with(mode: "array", hider: draw.hide.with(bounds: true))
  ``` 
  #set align(center + horizon) 

  #import "@preview/cetz:0.5.2": canvas, draw 
  #let canvas = interface(canvas, inner: "array", hider: draw.hide.with(bounds: true))
  #canvas({
    let uncover = uncover.with(mode: "array", hider: draw.hide.with(bounds: true))
    import draw: * 
    circle((0, 0), radius: 2)
    (pause,) 
    circle((3, 0), radius: 2)
    (pause,)
    circle((6, 0), radius: 2)
    uncover(none, line((-2, 0), (8, 0)))
  })
]

#slide[Alchemist Example][

]

#slide[Fletcher Example][

]

= Advanced Animation

#slide[
  Paragraph before the list 
  - First Item 


  Paragraph after the list
]

  Paragraph before the list  
  - First Item 

  - Second Item 
  - Third Item 

  Paragraph after the list