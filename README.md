# Presentate
**Presentate** is a package for creating presentation in Typst. It provides a framework for creating dynamic animation that is compatible with other packages. 
For usage, please refer to [demo.pdf](https://github.com/user-attachments/files/21792851/demo.pdf).

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

### Package Integration 

Use can use the `render` function to create a workspace, and import the `animation` module of Presentate to create animation with other packages. 
For example, Integration with [CeTZ](https://typst.app/universe/package/cetz) and [Fletcher](https://typst.app/universe/package/fletcher)  
```typst
#import "@preview/cetz:0.4.1": canvas, draw
  #render(s => ({
    import animation: *
    let (pause,) = settings(hider: draw.hide.with(bounds: true))
    canvas({
      import draw: *
      pause(s, circle((0, 0), fill: green,))
      s.push(auto) // update s
      pause(s, circle((1, 0), fill: red))
    })
  }, s))
```
Results: 
<img width="833" height="973" alt="image" src="https://github.com/user-attachments/assets/971a4739-1c13-45f6-9699-308760dc34d9" />

 

## Acknowledgement 
Thanks [Mimideck package author](https://github.com/knuesel/typst-minideck) for the `minideck` package that inspires me the syntax and examples.
[Touying package authors](https://github.com/touying-typ/touying) and [Polylux author](https://github.com/polylux-typ/polylux) for inspring me the syntax and parsing method. 
