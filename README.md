# Presentate
**Presentate** is a package for creating presentation in Typst. It provides a framework for creating dynamic animation that is compatible with other packages. 
For usage, please refer to [demo.pdf](https://github.com/user-attachments/files/21795556/demo.pdf)


## Simple Usage 
Import the package with 
```typst
#import "@preview/presentate:0.2.0": *
```
and then, the functions are automatically available. 

### Creating slides 
You can create a slide using `slide` function. For simple animation, you can use `pause` function to show show some content later.
The easiest is to type `#show: pause`. For example,
```typst
#set page(paper: "presentation-16-9")
#set text(size: 25pt)

#slide[
  Hello World!
  #show: pause;

  This is `presentate`.
]
```

which results in 
<img width="1620" height="464" alt="example1" src="https://github.com/user-attachments/assets/8bc0d428-cf3f-4e49-96b2-093cbbf10e2e" />

You can style the slides as you would do with normal Typst document. For example, 

```typst
#set page(paper: "presentation-16-9")
#set text(size: 25pt, font: "FiraCode Nerd Font Mono")
#set align(horizon)

#slide[
  = Welcome to Presentate! 
  \
  A lazy author \
  #datetime.today().display()
]

#set align(top)

#slide[
  == Tips for Typst.

  #set align(horizon)
  Do you know that $pi != 3.141592$?

  #show: pause 
  Yeah. Certainly.

  #show: pause 
  Also $pi != 22/7$.
]


```

<img width="1479" height="850" alt="example2" src="https://github.com/user-attachments/assets/c071e008-a1eb-4c59-b693-fbeea9bf70aa" />

### Relative Index Specification 
You can use `none` and `auto` to specify the index as *with previous animation* or *after previous animation*. 
This is useful for modifying steps of the animation so that some contents appear with or after another. 
One application is to hide the marker of `enum` and `list`: 

```typst

#slide[
  = List Hacks with Relative Index
  #set list(marker: uncover(from: auto, update-pause: false, [-]))

  - #show: pause; First Item.
  - #show: pause; Second Item. 
  - #show: pause; Third Item.
]
```

<img width="1322" height="764" alt="image" src="https://github.com/user-attachments/assets/de1710c1-b6aa-4585-8a74-acfb3a394f72" />




### Package Integration 

Use can use the `render` function to create a workspace, and import the `animation` module of Presentate to create animation with other packages. 
For example, Integration with [CeTZ](https://typst.app/universe/package/cetz) and [Fletcher](https://typst.app/universe/package/fletcher)  
```typst
#import "@preview/cetz:0.4.1": canvas, draw
#import "@preview/fletcher:0.5.8": diagram, edge, node

#slide[
  = CeTZ integration
  #render(s => ({
      import animation: *
      let (pause,) = settings(hider: draw.hide.with(bounds: true))
      canvas({
        import draw: *
        pause(s, circle((0, 0), fill: green))
        s.push(auto) // update s
        pause(s, circle((1, 0), fill: red))
      })
    },s)
  )
]

#slide[
  = Fletcher integration
  #render(s => ({
    import animation: *
    diagram($
        pause(#s, A edge(->)) #s.push(auto)
          & pause(#s, B edge(->)) #s.push(auto)
            pause(#s, edge(->, "d") & C) \
          & pause(#s, D)
    $,)
  }, s,))
]
```
Results: 

<img width="833" height="973" alt="image" src="https://github.com/user-attachments/assets/971a4739-1c13-45f6-9699-308760dc34d9" />

You can incrementally show the content from other package by wrap the functions in the `animate` function, with a modifiers that modifies the function's arguments to hide the content using `modifier`. 
For example, this molecule animation is created compatible with [Alchemist](https://typst.app/universe/package/alchemist) package: 

```typst
#import "@preview/alchemist:0.1.6" as alc

#let modifier(func, ..args) = func(stroke: none, ..args) // hide the bonds with `stroke: none`
#let (single,) = animation.animate(modifier: modifier, alc.single)
#let (fragment,) = animation.animate(modifier: (func, ..args) => func(colors: (white,),..args), alc.fragment) // hide the molecule with `fill: white`

#slide[
  = Alchemist Molecules
  #render(s => ({
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
    },s)
  )
]
```

which results in 

<img width="1073" height="927" alt="image" src="https://github.com/user-attachments/assets/7a79c210-c16d-4dca-959c-c26ba6752886" />



## Acknowledgement 
Thanks [Mimideck package author](https://github.com/knuesel/typst-minideck) for the `minideck` package that inspires me the syntax and examples.
[Touying package authors](https://github.com/touying-typ/touying) and [Polylux author](https://github.com/polylux-typ/polylux) for inspring me the syntax and parsing method. 
