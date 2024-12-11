# typst-presentate
Presentate is a Typst package for creating presentation. It provides you a variety of helper functions to create dynamic slides.
Presentate is implemented without using any  `context`, `counter`s, or `state`s, so it can be used with *any* functions in Typst, but with the correct hiding functions though.
## Basic Usage 

Let's start with 
```typst
#import "path-to-presentate-package": * 

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
## Internals
`presentate` uses `self.subslide` to determine when the content should be shown and `self.pauses` to keep track of number of pauses. Therefore, *all* helper functions will have a `self` argument to access the current `self.subslide`. 

## Requirements for the first release
- A proper documentation.
- more proper examples of how to use the helper functions.
- Some themes.

## Acknowledgement
Thanks [@knuesel](https://github.com/knuesel/typst-minideck) for the `minideck` package that inspires me the syntax and examples.
