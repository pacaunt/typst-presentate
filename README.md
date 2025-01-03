# typst-presentate
Presentate is a Typst package for creating presentation. It provides you a variety of helper functions to create dynamic slides.
Presentate's helper functions are implemented without using any  `context`, `counter`s, or `state`s, so it can be used with *any* functions in Typst, but with the correct hiding functions though.
## Basic Usage 

Let's start with `pause` 
```typst
#import "path-to-presentate-package": *

// unpack and configure the slides.
#let (presentate-slide,) = presentate-config()

#set text(size: 25pt)
#set page(paper: "presentation-16-9")

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
```
![image](https://github.com/user-attachments/assets/881be028-927f-40d7-bdb5-209f4baea421)

You have to specify the number of repetitions of the slide in `steps` argument. This is because I cannot think of a way to access the repetitions without using `state` or `counter` (Those always cause the limitation of using the helper functions since it only returns `content`).
- `presentate-config` is used to specify the modes such as `handout` and `drafted`.

More examples with `pinit` 

```typst
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
```
![image](https://github.com/user-attachments/assets/47d5fb40-42db-4312-9f5e-a3604c8aa515)

This is imported from [minideck](https://github.com/knuesel/typst-minideck) package. As you can see, the `only` function also have the `self` argument. The `self` is required to access the current `self.subslide`. `only` is used for revealing the content at the specific subslides. 

Lets introduce you the `one-by-one`. 
```typst
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
```
![image](https://github.com/user-attachments/assets/78cf6e60-a866-40bc-8e72-8292fdef77b2)

Basically what it does is accepting an array of information, and return the information one by one. As you can see, I modified the `hider` argument of the `one-by-one` function to fully cover the enumeration list. *All helper functions in Presentate can be modified in its hiding method to appropriately "hide" the information*. Therefore, `cetz` functions can be hidden too, but with some modifications. 

```typst
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
```
![image](https://github.com/user-attachments/assets/a3e38b56-89b9-4c87-aff7-3c2a12ab1b4c)

This snippet is imported from, again, Minideck package. I modified the `hider` function used by `uncover` for hiding the elements in canvas of CeTZ package. This also can be applied to `pause`. 

```typst
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
```
![image](https://github.com/user-attachments/assets/268f9b06-8066-4935-b3b0-8bc22313e8f6)
![image](https://github.com/user-attachments/assets/87a356f1-a9eb-43f6-b2f4-8bc06707ae85)

This one is a bit long, but it is very simple. I modified the `hider` function used by `pause` so that it is conpatible with the `canvas` of `cetz`. Despite our helper functions flexibility, *they can only take effect on the content inside its scope*. Therefore, I have to update the number of pauses in the `self.pauses` variable by `#{ self.pauses += 2 }` so that the content outside the `cetz-pause` function appears on the correct subslide.

## Heading Numbering

This is the only place where `presentate` uses `context`. Let's see the example
```typst
#set heading(numbering: "1.1")

#presentate-slide(
  steps: 4,
  self => [
    = Hello Typst!
    #alter(self, 4, [
        This is the first slide in `presentate`

        #one-by-one(
          self,
          [
            You can see this time the heading has numbered!

          ],
          [
            By default, `page`, `equation` `figure`, `quote`, and `heading` counters are frozen.
          ],
          [
            By the way, you can change the layout by `alter` function
          ],
        )],
      it => align(horizon, it),
    )
  ],
)
```
![image](https://github.com/user-attachments/assets/6b921c6a-c454-47e8-9aab-2c8f96b03a9c)  
Let's see more examples on equations:

```typst
#set math.equation(numbering: "(1)")

#let my-label(self, x) = if self.subslide == 1 {
  label(x)
}

#presentate-slide(
  steps: 5,
  self => [
    == `math.equation` example
    #my-label(self, "first")


    For example, the following equation:

    #one-by-one(
      self,
      [

        $ E = m c^2 $#my-label(self, "eq1")
        $ a^2 + b^2 = c^2 $#my-label(self, "eq2")
      ],
      [
        It is shown with the same number!
      ],
      [
        However, it is still not referencable.
        Typst will complain you about the labeled content occuring in the document.
      ],
      [
        So I hacked with `self.subslide`:

        @eq1 is from Eistein. \
        @eq2 is from Pythagoras.
      ],
    )
  ],
)
```
This snippet produce the first slide on topic 1.1, and 
```typst
#presentate-slide(
  steps: 2,
  self => [
    == More equations
    #set align(horizon)

    $ K E = 1 / 2 m v^2 $
    #pause(
      self,
      self => [
        As mentioned in @first, the equation numbering is working!
      ],
    )
  ],
)
```
produces the 1.2 topic. 
![image](https://github.com/user-attachments/assets/1a5fd284-e2b8-48fa-b287-b911172eac42)
![image](https://github.com/user-attachments/assets/11c5b141-5ff7-49f3-89de-d0dc5d9cfe57)


As you can see, the power of function-based implementation allows users to *modify* anything, even the label so that we can reference through slides!.  
Currently, only element function counters are frozen through subslides, and it cannot detect manual updates of the original counters.


## List of all functions 
- `presentate-slide(steps: 1, func)`
  - `steps` : an integer indicates the number of subslides needed.
- `presentate-config(handout: false, drafted: false, theme: it => it, ..args)`
  - `handout` : if set to `true`, only the last subslide is printed.
  - `drafted` : if set to `true`, there will be a transparent number printed on each subslides to indicate current subslide number.
  - `theme` : is a function for theme system (for further implementation).
- `pause(self, func)`
- `only(self, ..when, from: none, hider: it => none, func)`
- `uncover(self, ..when, from: none, hider: hide, func)`
- `change(self, before, after)` 
- `alter(self, ..when, from: none, before, after)`
- `one-by-one(self, when, ..funcs)`

Note that: 
- `func` arguments in the helper functions can be any information, but using callback `self => { .. }` gives you an access to the current subslide by `self.subslide` variable.
- `from:` argument is used like `from` argument in the `minideck` package.  


## Internals
`presentate` uses `self.subslide` to determine when the content should be shown and `self.pauses` to keep track of number of pauses. Therefore, *all* helper functions will have a `self` argument to access the current `self.subslide`. 

## Requirements for the first release
- A proper documentation.
- more proper examples of how to use the helper functions.
- Some themes.

## Acknowledgement
Thanks [@knuesel](https://github.com/knuesel/typst-minideck) for the `minideck` package that inspires me the syntax and examples.
