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

<img width="1479" height="850" alt="example2" src="https://github.com/user-attachments/assets/c071e008-a1eb-4c59-b693-fbeea9bf70aa" />


 

## Acknowledgement 
Thanks [Mimideck package author](https://github.com/knuesel/typst-minideck) for the `minideck` package that inspires me the syntax and examples.
[Touying package authors](https://github.com/touying-typ/touying) and [Polylux author](https://github.com/polylux-typ/polylux) for inspring me the syntax and parsing method. 
