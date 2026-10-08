// IDEA: There are two modes of parsing: array and content mode. Content mode
// assumes every parsable element is a content, so the parser terminates when
// the data is not a content. However, array mode assumes every element is an
// array with only one member, which must not be an array or parsable.
#import "utils.typ" as utils: strfmt
#import "indices.typ"
#import "element.typ": *
#import "render.typ": *

#let sequence = [].func()
#let styled = [#set text(fill: red)].func()

#let base-states = (
  subslide: 1,
  sequence: (),
  steps: 1,
  default-hider: hide,
  pause-state: (
    hidden: false,
    default-hider: hide,
    hider: hide,
  ),
  parsing-state: (shown: false),
)

/// ----------- APPLICATIONS --------------

#let reveal(from: none, body, hider: auto, mode: "content") = mode-wrapper(
  mode,
  generic(
    {
      mode-wrapper(mode, state-updater(s => s + ((from,),)))
      body
    },
    mode: mode,
    real: false,
    contextual: true,
    (s, body) => {
      let (results: (idx,)) = indices.resolve(s, from)
      let hider = if hider == auto { s.at(0).default-hider } else { hider }

      if s.at(0).subslide >= idx {
        body
      } else {
        hider(body)
      }
    },
  ),
)

#let pause = jump(auto)


#title[TESTS]

// #content-tree[
//   Hi
//   - Hello
//   - Hi
//   #set text(fill: red)
//   Good
//   #context { [d] }
//   #metadata("Hello")
// ]

// #pagebreak()

#{ base-states.subslide = 3 }

#let (sts, tree) = make-tree(states: (base-states,))[
  First
  #uncover(2)[ONLY TWO]
  #pause
  #context [ALLA]
  #set text(fill: red)
  Second #pause
  #mode-wrapper("content", state-getter(s => [#s.at(0).pause-state]))
  #line()
  Third
  // #[
  //   A #pause B
  // ]
  #table(
    [A],
    [#pause B],
    [C],
  )
  $ a^(#pause 2) grave(a) $
]

#sts
#let updated-states = base-states
#{
  let (steps,) = indices.resolve((base-states, ..sts.slice(1, none)))
  updated-states.steps = steps
}

#tree

= RESULTS

#reconstruct(tree, states: (updated-states,)).last()

#pagebreak()

= Test 2

#{ base-states.subslide = 3 }

#let body = [
  First #pause Word
  #set text(fill: red)
  Hey #pause Ho #line()
]

// #body.fields()

#let (sts, tree) = make-tree(body, states: (base-states,))
// #tree

#reconstruct(tree, states: (base-states,)).last()

#pagebreak()
= Test 3
#{ base-states.subslide = 1 }

#let (sts, tree) = make-tree(states: (base-states,))[
  - Hello
  #pause
  - It's Me
  - It's you
  #jump(1)
  Alligator
]

#reconstruct(tree, states: (base-states,))

#pagebreak()

= Test 4
#{ base-states.subslide = 3 }

#let (sts, tree) = make-tree(states: (base-states,))[
  - Hello
  #pause
  Bankai Lalala
  #set text(fill: red)
  Hi
  #jump(1)
  Alligator
  #jump(3)
  Hi2
]

#reconstruct(tree, states: (base-states,)).last()

#pagebreak()

= CeTZ Test

#import "@preview/cetz:0.5.2": canvas, draw

#let join-canvas(..args) = canvas(args.pos().sum(), ..args.named())

#let my-canvas = interface(canvas, inner: "array", outer: "content", hider: draw.hide.with(bounds: true), )

// #let (sts, tree) = make-tree(((([A], [B]),),), mode: "array")

// #tree

// #reconstruct(tree, states: (base-states,))

// #my-canvas({
//   import draw: *
//   circle((0, 0))
// })

#{ base-states.subslide = 4 }

#let body = [
  First #pause Second #pause
  #my-canvas({
    import draw: *
    // let pause = pause.with(mode: "array", hider: hide.with(bounds: true))
    circle((0, 0))
    (pause,)
    circle((1, 0))
  })
  H
]

#let (sts, tree) = make-tree(body, states: (base-states,))
// #tree
#reconstruct(tree, states: (base-states,)).last()


#pagebreak()

= Test Nested uncover

#{ base-states.subslide = 3 }

#let body = [
  Hello
  #reveal(from: 2)[
    This is from Two

    #uncover(3, [This is at three])

    This is from Two
  ]

  This is after
]

#let (sts, tree) = make-tree(body, states: (base-states,))

// #tree

== Result

#reconstruct(tree, states: (base-states,)).last()

#pagebreak()

= Test Nested Uncover in CeTZ

#{ base-states.subslide = 4 }

#let body = [#my-canvas({
  import draw: *
  let uncover = uncover.with(mode: "array", hider: hide.with(bounds: true))
  // let reveal = reveal.with(mode: "array", hider: hide.with(bounds: true))
  line((0, 0), (1, 0))
  uncover(from: 2, {
    line((0, -1), (rel: (1, 0)))
    uncover(3, {
      line((0, -2), (rel: (1, 0)))
    })
  })
})]

#let (sts, tree) = make-tree(body, states: (base-states,))

// #tree

#reconstruct(tree, states: (base-states,)).last()

#pagebreak()

= Fletcher Test

#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#let my-diagram = interface(diagram, inner: "content", hider: fletcher.hide)

#{ base-states.subslide = 4 }

#let body = [
  #let f-uncover = uncover.with(hider: fletcher.hide)
  First
  #pause

  #my-diagram(
    node((0, 0), [First], name: "A"),
    pause,
    edge("->"),
    node((1, 0), [Second]),
    pause,
    edge("->"),
    node((2, 0), [Third], name: "C"),
    f-uncover(4, edge(<A>, "u,r,r,d", "->")),
  )
]

#let (sts, tree) = make-tree(body, states: (base-states,))

#reconstruct(tree, states: (base-states,)).last()

#pagebreak()

= Alchemist Molecule

#import "@preview/alchemist:0.2.0" as alchemist: skeletize

#let my-skeletize = interface(skeletize, hider: alchemist.hide)

// #let my-skeletize(body, ..args) = mode-wrapper("content", element(
//   fields: (
//     body: {
//       mode-wrapper("array", state-updater(s => {
//         s.at(0).pause-state.hider = alchemist.hide
//         s
//       }))
//       body
//     },
//     ..args.named(),
//   ),
//   positionals: ("body",),
//   skeletize,
//   mode: "array",
// ))


#let my-branch = adapt(alchemist.branch)

// #let my-branch(body, ..args) = mode-wrapper("array", element(
//   fields: (
//     body: {
//       // mode-wrapper("array", state-updater(s => {
//       //   s.at(0).pause-state.hider = draw.hide.with(bounds: true)
//       //   s
//       // }))
//       body
//     },
//     ..args.named(),
//   ),
//   positionals: ("body",),
//   alchemist.branch,
//   mode: "array",
// ))

#{ base-states.subslide = 2 }

#let body = [
  #my-skeletize({
    // let pause = pause.with(mode: "array")
    import alchemist: *
    single(angle: 1)
    (pause,)
    my-branch({
      single(angle: 3)
      (pause,)
      single(angle: 1)
      (pause,)
    })
    single(angle: -1)
  })
]

#let (sts, tree) = make-tree(body, states: (base-states,))

// #tree
#reconstruct(tree, states: (base-states,)).last()

#pagebreak()

= Handling Items Positions

#let mblock = block.with(stroke: .5pt)

- Hello
#mblock(spacing: 1.2em)[- It's Me]

- Malangua
- End
/ terms: item
/ terms: item


+ A
// #set text(fill: green)
+ B
Hello

#{ base-states.subslide = 1 }
#{ base-states.pause-state.hider = text.with(fill: red) }

#let body = [
  1. First Item #pause
    + First List #pause
    + Second List
    #set text(fill: blue)
    + Third List
    Text
  2. Second Item
    #jump(1)
  3. Third Item
]

#let (sts, tree) = make-tree(body, states: (base-states,))

// #tree

#reconstruct(tree, states: (base-states,)).last()

#pagebreak()

= Test Item

#{ base-states.subslide = 4 }

#let body = [
  H
  #step-item(hider: text.with(fill: red), start: none)[
    + First
    + Second
    + Third
  ]
  ---
  #reveal-item[
    + First
    + Second
  ][
    + Third
  ]

  // #uncover(from: auto, update-pause: true)[First]

  // #uncover(from: auto,)[Second]
  Hi
]

#let (sts, tree) = make-tree(body, states: (base-states,))

#reconstruct(tree, states: (base-states,)).last()

= Waypoints

#{ base-states.subslide = 1 }

#let body = [
  Hi #pause Hello #marker(<first>)
  #pause Third
  // #meanwhile
  #uncover(<first>)[with hello!]
  #link("https://typst.app/docs/reference/visualize/curve/")
]

#let (sts, tree) = make-tree(body, states: (base-states,))

#reconstruct(tree, states: (base-states,)).last()


#pagebreak() 

= Test Children 

#let my-join-canvas = interface(join-canvas, inner: "array", hider: draw.hide.with(bounds: true), )

#{ base-states.subslide = 2 }

#let body = [
  #my-join-canvas({
    import draw: * 
    circle((0, 0))
    (pause,)
  }, {
    import draw: *
    circle((1, 0))
  })
  #pause
  After
]

#let (sts, tree) = make-tree(body, states: (base-states,))
#tree
#reconstruct(tree, states: (base-states,)).last()

#pagebreak()

= Test Nested Items and uncover 

#{ base-states.subslide = 4 }

#let body = [
  #step-item[
    - First Item 
    - #uncover(auto, [Alert])
    - Second Item
  ]
]
#let (sts, tree) = make-tree(body, states: (base-states,))

#reconstruct(tree, states: (base-states,)).last()