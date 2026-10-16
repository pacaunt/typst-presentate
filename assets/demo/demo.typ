#import "@local/presentate:0.3.0": *
#import "@preview/codly:1.3.0": codly, codly-init
#import themes.progressive-outline: *

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


]

#slide[Alert/Transform][

]

= Package Integration
#slide[][

]

= Advanced Animation 

#slide[Chemical Bonding][
  Atoms are weird, they want to join with each other to become more stable. Why? 
]