#import "@submit/presentate:0.2.1": *

#import "@preview/alchemist:0.1.6" as alc

#set page(paper: "presentation-16-9")
#set text(size: 25pt)

#let modifier(func, ..args) = func(stroke: none, ..args) // set stroke to `none`
#let (single,) = animation.animate(modifier: modifier, alc.single)
#let (fragment,) = animation.animate(modifier: (func, ..args) => none, alc.fragment) // set atom colors to white

#slide[
  = Alchemist Molecules
  #render(s => (
    {
      alc.skeletize({
        fragment(s, "H_3C")
        s.push(auto)
        single(s, angle: 1)
        fragment(s, "CH_2")
        s.push(auto)
        single(s, angle: -1, from: 0)
        fragment(s, "CH_2")
        s.push(auto)
        single(s, from: 0, angle: 1)
        fragment(s, "CH_3")
      })
    },
    s,
  ))
]

#slide[
  #let input = ("a", "b", next, "c")
  #parser(input)
]

#slide[
  #let (single, double) = make-cover(alc.single, alc.double, modifier: (func, ..args) => func(
    stroke: 0pt,
    ..args,
  ))
  #let skeletize = parser.with(func: (arr, ..args) => alc.skeletize(arr.sum(), ..args))
  #skeletize((
    single(),
    double(angle: 1),
    next,
    single(),
  ))
]

#import "@preview/cetz:0.4.1" as cetz: canvas, draw
#slide[

  #let canvas = parser.with(
    func: (arr, ..args) => canvas(arr.sum(), ..args),
    hider: draw.hide.with(bounds: true),
  )
  #import draw: *
  #canvas((
    circle((0, 0)),
    next,
    circle((1, 0)),
  ))
]

#slide[
  Hello
  #let canvas = parser.with(
    func: (arr, ..args) => canvas(arr.sum(), ..args),
    hider: draw.hide.with(bounds: true),
    // mapper: it => (it,),
  )


  #import draw: *

  #let (merge-path,) = make-cover(merge-path, modifier: (func, ..args) => func(
    args.pos().at(0),
    ..args.named(),
  ))
  #canvas({
    (
      circle((0, 0)),
      next,
      circle((1, 0), stroke: 2pt + red),
      next,
      // merge-path({
      //   circle((2, 0))
      // }),
    )
  })

 
]
