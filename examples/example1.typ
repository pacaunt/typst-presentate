#import "../export.typ": * 

#let (presentate-slide,) = presentate-config()

#set text(size: 25pt)
#set page(paper: "presentation-16-9", numbering: "1")

#presentate-slide(steps: 3, self => [
  = Hello Typst!

  #set align(horizon)

  This is the first `presentate` presentation!

  #pause(self, self => [
    You can use `pause` to make the content appear after.
    
    #pause(self, self => [
      However, the `pause`s must be nested to take effect. 
    ])
  ])
])

#import "@preview/pinit:0.2.2": *

#presentate-slide(steps: 3, self => [
  = Works well with `pinit`

  Pythagorean theorem:

  $ #pin(1)a^2#pin(2) + #pin(3)b^2#pin(4) = #pin(5)c^2#pin(6) $

  #pause(self, self =>[
    $a^2$ and $b^2$ : squares of triangle legs
  

    #only(self, 2, {
      pinit-highlight(1,2)
      pinit-highlight(3,4)
    })

    #pause(self, self => [
      $c^2$ : square of hypotenuse

      #pinit-highlight(5,6, fill: green.transparentize(80%))
      #pinit-point-from(6)[larger than $a^2$ and $b^2$]
    ])
  ])
])

#presentate-slide(steps: 4, self => [
  = Lists and Enum 
  To fully cover the `list` and `enum`, you can modify the `hider` argument in *all* of the helper functions!
  #one-by-one(self, hider: it => hide(block(it)),[
    + First Item
  ], [
    + Second Item
  ], [
    + Third Item
  ])
])

#import "@preview/cetz:0.3.1": canvas, draw

#presentate-slide(steps: 3, self =>[
  #let cetz-uncover = uncover.with(hider: draw.hide.with(bounds: true))
  = In a CeTZ figure

  Above canvas
  #canvas({
    import draw: *
    only(self, 3, rect((0,-2), (14,4), stroke: 3pt))
    cetz-uncover(self, from: 2, rect((0,-2), (16,2), stroke: blue+3pt))
    content((8,0), box(stroke: red+3pt, inset: 1em)[
      A typst box #only(self, 2)[on 2nd subslide]
    ])
  })
  Below canvas
])

#presentate-slide(steps: 7, self => [
  = `pause` in CeTZ

  #let cetz-pause = pause.with(hider: draw.hide.with(bounds: true))
  #canvas({
    import draw: * 
    circle((), fill: red) 
    cetz-pause(self, self => {
      circle((rel: (1, 0)), fill: green)
      cetz-pause(self, self => {
        circle((rel: (1, 0)), fill: blue)
      })
    })
  })

  #{ self.pauses += 2 }

  #pause(self, self => [
    Or you can use `one-by-one`. 
    #let cetz-one-by-one = one-by-one.with(hider: draw.hide.with(bounds: true))

    #canvas({
      import draw: * 
      cetz-one-by-one(self, 
        rect((0, 0), (rel: (3, 2)), fill: red), 
        rect((), (rel: (3, 2)), fill: green), 
        rect((rel: (0, -2)), (rel: (-3, -2)), fill: blue),
      )
    })
  ])
])

#set math.equation(numbering: "(1)")
#set heading(numbering: "1.1")

#presentate-slide(self => [
  #outline()
])

#presentate-slide(steps: 4, self => [
  = Hello
  $ a^2 + b^2 $
  #pause(self, 3, self => [
    $ c^2 + d^2 $
  ])
])


