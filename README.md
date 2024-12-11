# typst-presentate
Presentate is a Typst package for creating presentation. It provides you a variety of helper functions to create dynamic slides.
Presentate is implemented without using any  `context`, `counter`s, or `state`s, so it can be used with *any* functions in Typst, but with the correct hiding functions though.
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
This is imported from [minideck](https://github.com/knuesel/typst-minideck) package. As you can see, the `only` function also have the `self` argument.


## Internals
`presentate` uses `self.subslide` to determine when the content should be shown and `self.pauses` to keep track of number of pauses. Therefore, *all* helper functions will have a `self` argument to access the current `self.subslide`. 

## Requirements for the first release
- A proper documentation.
- more proper examples of how to use the helper functions.
- Some themes.

## Acknowledgement
Thanks [@knuesel](https://github.com/knuesel/typst-minideck) for the `minideck` package that inspires me the syntax and examples.
