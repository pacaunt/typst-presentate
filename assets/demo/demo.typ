#import "@local/presentate:0.3.0": *
#import "@preview/codly:1.3.0": codly, codly-init
#import themes.split: *

#show: codly-init
#show: template.with(
  title: [Presentate Demo],
  subtitle: [Presentation with Extensible Package Integrations],
  author: [\@pacaunt],
  text-size: 25pt,
)

#set raw(lang: "typ")

#set heading(numbering: "1.1")
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

#slide[Pause, Meanwhile, Jump][
  #utils.multicols(2)[
    You can incrementally show content with `#pause`.

    #pause
    This text appears later.
  ][
    #show: block.with(inset: 1em, stroke: 0.5pt)

    #meanwhile
    `#meanwhile` is used to show something in between.

    #pause 
    Such as this comment.
  ]
  `#jump(index)` is used to 'jump' to the specified index.

  #jump(1)
  You will see _me_ in the first subslide because of `#jump(1)`.
]

#slide[Uncover, only][
  #figure(rect(), caption: [A Caption])<fig1>
  #marker(<pin>, locatable: true)
  #pause 
  From @fig1
]

#slide[
  According to #link(<pin>)[word]
  #[#[]<a>].fields()
]

#slide[
  #labeler(figure(rect(), caption: [Another Caption]), <figx>, at: "last")
  #pause 
  @figx
]

#import "@preview/pinit:0.2.2": * 
== Link 
#slide[Pythygorean Theorem][
  $ a^2 + b^2 = #pin(1)c^2#pin(2) $

  #pause 
  #pinit-point-from(2)[It is simple.]
]