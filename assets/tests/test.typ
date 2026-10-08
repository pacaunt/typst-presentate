#import "../../src/export.typ": *
#import "../../src/presentate.typ": *

#set page(paper: "presentation-16-9")
#set text(size: 25pt)
// #set heading(numbering: "1 ")

// #show heading.where(level: 1): it => {
//   slide(context { it })
// }
// CHORES: Check the compatibility of themes...
= Topic

// #slide[
//   == Welcome
//   #show: body => element.applier(body, it => context { it })
//   Hello, this is presentate.
//   #pause

//   Another presentation framework.
// ]

// #set page(fill: yellow)

// #slide[
//   == Everything is easy and configurable..

//   #set align(horizon)
//   #show: block.with(height: 1fr)

//   #grid(columns: (1fr,) * 2, rows: 1fr, fill: white, gutter: 2em, inset: 1em)[
//     This is the first column.
//     #pause
//   ][
//     This is the second column.
//   ]

// ]

// #slide[
//   #step-item[
//     - A
//     - #alert(auto)[B]
//     - C
//   ]
// ]

#context {
  let s = store.states.get()
  let body = [
    #step-item[
      - A
      - #alert(auto)[B]
      - C
    ]
  ]

  let (post, tree) = make-tree(body, states: s)
  post.at(0).steps = indices.resolve(post).steps
  // raw(repr(tree), lang: "typc")
  // for i in range(1, post.at(0).steps + 1) {
  s.at(0).subslide = 1
  let (_, new-body) = reconstruct(tree, states: s)
  new-body
  repr(new-body)
  pagebreak()
  // subslide(s, i, tree)
  // }
}

#context {
  let body = [
    #pause
    #grid(columns: (1fr, 1fr), gutter: 1em)[
      A
      #pause
      B
    ][
      // #meanwhile
      // #pause
      #rect[
      #uncover((rel: -1))[It's 5 choose 3.]
      ]
      D
      // #pause
    ]
    E
  ]

  let s = store.states.get()
  s.at(0).subslide = 1
  let (sts, tree) = make-tree(body, states: s)
  // [#tree]
  [#reconstruct(tree, states: s)]
}

#pagebreak()

#slide[
  = Test Visibility
  A #pause B 
]