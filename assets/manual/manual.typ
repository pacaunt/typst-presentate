#import "@preview/muchpdf:0.1.2": muchpdf
#import "@preview/zebraw:0.6.1": zebraw
#import "@preview/oxifmt:1.0.0": strfmt

#let info = toml("../../typst.toml")

#let footlink(url, body) = {
  link(url, body)
  footnote(link(url))
}

#let render-pdf(
  path,
  pages: 1,
  columns: (1fr,) * 3,
  background: gray.lighten(70%),
  stroke: 0.5pt,
  gutter: .5em,
  numbered: true,
  ..styles,
) = {
  let file = read(path, encoding: none)
  let imgs = ()
  for i in range(pages) {
    imgs.push(block(stroke: stroke, {
      image(path, page: i + 1)
      if numbered { place(center + horizon, text(.5in, gray.transparentize(70%))[#{ i + 1 }]) }
    }))
  }
  grid(
    gutter: gutter,
    columns: columns,
    ..imgs,
    ..styles
  )
}

#let rawfmt(listing, ..args) = {
  let styles = args.named()
  let vars = args.pos()
  let fields = listing.fields()
  let text = fields.remove("text")
  let formatted-text = strfmt(text, ..vars)
  raw(
    ..fields,
    formatted-text,
  )
}

#let source-example(path, ..styles) = {
  let content = read(path)
  let read-lines = content.split("\n")
  let start-idx = read-lines.position(a => a.starts-with("// start-example"))
  raw(block: true, read-lines.slice(start-idx + 1, none).join("\n"), lang: "typ", ..styles)
}

#set page(margin: 2cm)
#set text(font: "Lato")
#show raw: set text(font: "JetBrainsMono NF")
#set raw(lang: "typc")
#let Typst = text(font: "Libertinus Serif", weight: "bold", "Typst")

#set document(title: [Presentate #info.package.version User Manual])

// title-page

#[
  #set page(fill: eastern)
  #set align(horizon)
  #set text(fill: white, size: 1.5em)
  #show link: underline

  #text(size: .8em)[Version #info.package.version]
  #v(1fr)
  #text(size: 2.2em, fill: white, weight: "bold")[
    Presentate
  ]
  #v(-1.7em)
  Simple dynamic presentation in #Typst, \
  with flexible package integration framework.

  #v(1em)

  #text(size: 1.2em)[*User Manual*] \

  #v(1fr)
  #text(size: .8em)[
    GitHub: #link("https://github.com/pacaunt/typst-presentate") \
    Compiled on #datetime.today().display("[day] [month repr:long] [year]")
  ]
]

// Document
#set page(numbering: "1")
#set heading(numbering: "1.1 ")
#show heading: set block(above: 1.4em, below: 1em)
#show heading.where(level: 3): set heading(numbering: none)
#set par(justify: true, first-line-indent: 1.2em)
#show figure.caption: it => {
  align(center, block(align(left, grid(
    columns: (auto, 1fr),
    strong[#it.supplement #it.counter.display("1")#it.separator], [#it.body],
  ))))
}
#show link: underline
#show raw: zebraw.with(lang: false)


#outline(depth: 2)

#pagebreak()

= Introduction

`Presentate` is a Typst package for creating _dynamic_ PDF presentation that is compatible with other packages. The word _dynamic_ means the compiled PDF contains _animated_ content. But PDF is a static document format, how can it contains animations? Presentate will look into the content, and create a set of pages that reveal or hide some content based on the current number of frames called _subslides_, so that when going through the pages, it seems like the content is showing or hiding like a simple animation.

#figure(
  image("../examples/example-pdf-animation.png"),
  caption: [Example of fake animation in PDF format. Each page contains its own content and rules controlling them to hide, show, or decorated in some ways.],
)

Dynamic PDF presentation packages have been in the Typst community for a long time, with the similar strategy for creating the animations, so why Presentate existed? The answer lies on the fact that presentation contains many kinds of visualization like plots, drawings, or chemistry molecules. These elements are usually created from other packages which have their own functions and data types. Therefore, to create animation with these visualization, the presentation framework must be able to handle _any_ data types:
- be able to _hide_ or _show_ any elements, not only `content`,
- be able to generate the number of required subslides _automatically_.
Presentate is created for that purpose. It provides not only the slide animation engine, but also a framework and functions to interact with content from other packages. For example, here is some animation of drawing molecules integrated with the #footlink("https://typst.app/universe/package/alchemist")[Alchemist] package.

#render-pdf("img/alchemist-example.pdf", pages: 5)

Note that the gray text represents the subslide (frame) of that page.

== Acknowledgements


The package was created by mixing my original motivation and insprations from many existing presentation packages.
Thanks to:
- #footlink("https://github.com/polylux-typ/polylux", [Polylux]) for  `subslide` implementation and pdfpc support, \
- #footlink("https://github.com/touying-typ/touying")[Touying] for idea of render frame, fake frozen states, and \
- #footlink("https://github.com/knuesel/typst-minideck")[Minideck] for `only`, and `uncover` functions.
- #footlink("https://github.com/eusebe/typst-navigator")[Navigator] for the navigation system, progressive-outline, and the structured themes.


= Getting Started

Import the package by
#rawfmt(
  ```typ
  #import "@preview/presentate:{}": *
  ```,
  info.package.version,
)
Or download a zip file of Presentate's #footlink("https://github.com/pacaunt/typst-presentate")[repository], install the `src` folder and import the package by
```typ
#import "src/export.typ": *
```
Then, setting your own styles, for example,
```typ
#set page(paper: "presentation-16-9") // you can change to 4-3
#set text(size: 25pt)
// your presentation begins here!
```
== Creating slides
A slide can be created by using the `slide` function. For example,
```typ
#slide[
  Hello, this is presentate.
]
```
== Simple animation
In the slide function, you can use the animation functions to control the behavior of the content on the slide. The simplest animation is to show some content after another content, this can be done by `pause` function:

#source-example("img/hello-world.typ")
yields
#render-pdf("img/hello-world.pdf", pages: 2)
Each content wrapped by the `pause` function will be revealed one by one on each frame. This function can be used in `math.equation` as well:
#source-example("img/math-pause.typ")
#render-pdf("img/math-pause.pdf", pages: 3)

== Control the show and hide: index specification
If, for example, you want to emphasis a text on a slide, you can use the `alert` function. This function, by default, will _emphasize_ the content by wrapping it in the typst's `emph` function and  become _alerted_ on the specified subslide.
#source-example("img/alert-index.typ")
#render-pdf("img/alert-index.pdf", pages: 3)
In the example, `alert` function accepted an integer and it made the text red only when the subslide number is the same as the specified number. This is called *index specification* where the index (pl. indices) is the subslide number or _frame_ number. Indices can be specified in many ways:
- It can be an integer, to alert the content only at that subslide.
- It can be `from: int`, to start alerting since the `int`#super[th] subslide.
- It can be multiple integers like `alert(1, 4, 5, body)` to only alert on subslide 1, 4, and 5.
- It can be _both_ integers and `from: int`, to show the modified content on the specified subslide and after the `int` subslide specified by the `from` argument.

Apart from `alert`, if you have ever used `beamer` in LaTeX before, you probably know the `uncover` and `only` functions. The `uncover` only _uncover_ the content on the spcified subslides, and hide the content otherwise, with _space preserved_, while `only` function also works with the same logic, but its hiding method is to completely remove the content out, so no space is preserved.

#source-example("img/simple-only-uncover.typ")
#render-pdf("img/simple-only-uncover.pdf", pages: 4)

== Time traveling with relative indices
Most of the time when creating presentation, the step of revealing the content is either
- showing at the same subslide as previous animation, or
- showing at the next subslide of the recent animation.
Presentate have a special type of index called *relative indices*, which are indices relative to the current number of pauses appear on the slide. There are 3 forms of relative indices:
+ `none` means the animation will happen at the same subslide as the current pause.
+ `auto` means the animation will happen at the _next_ subslide after the current pause.
3. `(rel: int)` means the animation will happen at the `int` subslide away from the current pause.
For example,
#source-example("img/relative-indices.typ")
#render-pdf("img/relative-indices.pdf", pages: 4)
As you can see, the last text that was shown on subslide 4 was a little bit inconvenient to write `(rel: 2)` to make it shown when every animation was finished. It would be nice if we can use `pause` at the end and make it 'see' the previous `uncover`s. You can make the next pause reveal a content after (almost) any animation functions by specifying `update-pause: true` into its argument.
#source-example("img/update-pause.typ")
// #render-pdf("img/update-pause.pdf", pages: 4)
With this interaction between the current number of pauses and the `update-pause` argument, you can set the pauses to _any_ number to modify the animation. For example, making the content shown in sync side by side:
#source-example("img/in-sync.typ")
#render-pdf("img/in-sync.pdf", pages: 3)

== Specific functions for `list` and `enum`
In the last example, you can see that the number in `enum` did not hide properly. Since Typst treats the marker of `list` and number label of `enum` in different context from its body, Presentate implements some (hacky) way to properly hide them without wiggling. To show the list/enum item by item, Presentate provides a function called `step-item`:
#source-example("img/step-item.typ")
#render-pdf("img/step-item.pdf", pages: 6)
Each of the item's body and its marker are wrapped in `pause` function, and synchronize the animation by using the `update-pause` hack. Therefore, you can nested them indefinitely, but it always update the pauses.

If you want to reveal the items chunk by chunk, Presentate also have the `reveal-item` function. This function can show item in group by group without breaking them. However, since the implementation of `reveal-item` requires additional Typst's state, it can decrease the speed of Typst compilation. So use this function sparingly.

#source-example("img/reveal-item.typ")
#render-pdf("img/reveal-item.pdf", pages: 3)

= Advanced Usage
== Groupping pauses: the `fragments` function
This function works like a shorthand for multiple pause/uncover calls. Moreover, you can choose whether to make it update the current pause by `update-pause` argument.
#source-example("img/fragments.typ")
#render-pdf("img/fragments.pdf", pages: 5)

== Change the hiding method: the `hider` argument
Every animation function in Presentation has a named argument `hider`, which is a function that used internally to _hide_ the content. For example,
- `only` uses `it => none` as hider, which make the content disappear when it hides,
- `uncover`, `pause`, `step-item`, `fragments` uses native Typst's `hide` function, which preserves space.
If you want to change the hiding method of the text from completely hiding it to making it gray, you can use `text.with(fill: gray.transparentize(50%))` as the hider, like the following example,
#source-example("img/gray-hider.typ")
#render-pdf("img/gray-hider.pdf", pages: 4)

== Change the appearance of the content: the `transform` function
`transform` requires a content as a base, it will be hidden by the `hider` until the specified index is reached (default is `auto`). Then, on each consecutive subslide, the content will transform by each function one by one. The following example shows how to emphasize content in a list by using `transform`.

#source-example("img/transform.typ")
#render-pdf("img/transform.pdf", pages: 5)
`start` argument tells when to start the animaton. Note that in this example, the grayed text was from `no` function, not the hider. The hider was still `hide` function, as you can see in the subslide 1.

== Precise control of the animation: `motion` and `tag` function

`motion` function provides a _workspace_ for rendering content groups that are named by the `tag` function. The anatomy of this function is
```typ
#motion(s => [
  // some content and `tag(s, name, body)`
], controls: (
  // rules to show the `tag`
))
```
Motion function accepts only one positional argument which is a *function* that receives the presentate's state `s` and return a content block.
`motion` function have a `controls` argument to specify which content group should be shown or hide precisely subslide by subslide. The motion reads the `controls` rules, process them and send the showing information through the state `s`.  This state `s` is read by the `tag` function to show or hide the content accordingly.

#source-example("img/motion-tags-simple.typ")
#render-pdf("img/motion-tags-simple.pdf", pages: 5)
This framework allows user to control the animation step without worrying about the location of each elements in the source code.
For the specification of *controls* argument, here is the syntax:
- The `controls` only accept *an array of rules* that will be applied on each subslides, similar to `transform` and the functions.
- Each rule can be a single command or an array of commands that will be use at the same subslide.
For each command,
- You can provide a name of the tag to show the content *once*,
- or provide with a suffix `.start` to start showing the content from the current step,
- or with a suffix `.stop` to stop showing the content.
The following example is more complex and use all of the control rule specification.
#source-example("img/motion-tags.typ")
#render-pdf("img/motion-tags.pdf", pages: 6)
This was created with integration of #footlink("https://typst.app/universe/package/cetz", [CeTZ]) package, showing the capability to integrate with other packages. This integration works because of the `hider` argument in the motion function is the CeTZ's hide function, which is compatible for its own elements. Note that for more complex illustrations, you can provide custom `hider` to the `tag` function to use a specific hider for that group.

== Advanced `motion`'s control command specification
For the version after 0.2.5, you can use a special syntax that let you modify the content in the tag group by applying some functions to it. The syntax of the command is
```typc
("{name}", {func}) // for apply the function once,
("{name}.start", {func}) // for starting showing the content and apply the function,
("{name}.apply", {func}) // for applying the function if it is showing,
"{name}.revert" // to revert back to original (identity) function
```
Here is an example of using this functionality: to annotate a mathematical expression:
#source-example("img/motion-func.typ")
#render-pdf("img/motion-func.pdf", pages: 3)

= Package Intregration Framework
Since each package has their own element and data types, to interact with them, Presentate must provide some functions that leave no trace to ensure there will be no conflict between packages. This functionality has been proposed in some ways before in the recent examples: changing the `hider` method of each animation functions.  The later functions that will be shown use a similar logic; you have to specify how to _hide_ the content from each packages _manually_. Moreover, since the functions leave no trace, Presentate cannot know what animation you have used, so you have to update each animation to Presentate _manually_.
== The `render` workspace
`render` is a function that accepts another function that returns *an array of length two, containing the content and a state*. The syntax is as follows:
```typ
#render(s => ([
  #import animation: *
  // your content
], s))
```
where `s` is the *Presentate's state*, which is an array containing
- a dictionary of current presentation infomation, it is the first member of this array,
  - you can access the current subslide number by `s.at(0).subslide`,
  - the curent number of pauses by `s.at(0).pauses`, for example.
- the indices of the animation from each Presentate's animation functions.
The content inside `render` can be anything, but it needs to be a `content` data type. The state `s` here will be used by the functions in `animation` module, as will be presented in the next section.

== `animation` module
To fully use the animation in `render` with other packages, you can import the `animation` module inside the render call as shown in the last code listing.  This module provides a similar set of functions like `pause`, `uncover`, `only`, and others, but all of them will be called a little bit different from the normal usage, as you have to put the state `s` *as the first positional argument* in the function _every time_, like
```typ
#render(s => ({
  import animation: *
  pause(s, { /* your content */  })
}, s))
```
Moreover, to make Presentate aware of the animation, you have to update the state `s` manually. Since `s` is an array, you can update by using `s.push(idx)` call, where `idx` is the indices that are required for the last animation to perform. For example, the `pause` function needs an additional new subslide, so we update `s` by `s.push(auto)` like in the following example.
#source-example("img/animation-pause.typ")
#render-pdf("img/animation-pause.pdf", pages: 4)
You can see that the diagram is jiggling, because by default, all functions in the `animation` module uses `it => none` as hider function. You can change it to suit the package's hide function, for example,
#source-example("img/cetz-animation.typ")
#render-pdf("img/cetz-animation.pdf", pages: 3)
Not only you can specify `auto` as update indices, in fact, you can put
- an integer like `s.push(1)`, `s.push(2)` to *set* the current pause to that subslide number,
- relative indices like normal, but each index will *always* update the pause number,
- an _array_ of any type of indices to prevent the pause update.
The specified indices are only for the current animation. For total number of frames needed to render all animation, Presentate will calculate it _automatically_.

== Animate the inanimate: a custom way to hide
Some packages do not provide their `hide` function to hide their elements. Presentate also has a function for handle that case, which is the `animate` function in the `animation` module. This `animate` create another function that _react_ with the current state `s`, so that the element will be shown one by one based on the current number of pauses, just like what normal pause do. To demonstrate this functionality, we will use an example to draw a chemical structure from #footlink("https://typst.app/universe/package/alchemist/")[Alchemist] package:
#source-example("img/alchemist.typ")
#render-pdf("img/alchemist.pdf", pages: 5)
The animate function have a `modifier` argument that receives a function that will be called when the element is hidden. In this example, the single bond is hidden by setting its stroke to `none` and the atoms are hidden by setting their text color to white.  The animate can process multiple functions at the same time if those functions require the same modifier to be hidden, so `animate` will returns *an array* of _modified_ functions in the same order as specified, as shown when processing `alc.single` and `alc.double` with the same modifier.

= Configuration Options
You can set the following options to Presentate:
- `handout: false` to create a handout version. This option will disable all of the animation and exposed all of the hidden content.
- `drafted: false` to show the current subslide number.
- `freeze-states: true` to freeze the states and counters. Note that this functionality was inherited from Touying package, and it will freeze only the specified states and counters, which can be set in `frozen-states-and-counters` option.
- `frozen-states-and-counters` to indicate which states and counters do Presentate need to freeze. The default is
  ```typc
  (
    counter(figure.where(kind: image)),
    counter(figure.where(kind: table)),
    counter(footnote),
    counter(heading),
    counter(math.equation),
  )
  ```
All of these options can be set by
```typ
#set-options(..options)
```
where `options` are the options in the form `key: value`.
= Exposed Utilities


== Internal states
Internally, Presentate store all of the slides information in a state in the `store` module. You can access this state by
```typc
context store.states.get()
```
The state's information will be an array of indices with the global info in the first member of this array. It is the same `s` as you can access from `render` or `motion` function.

= Themes
There are 2 types of themes that Presentate provides:
+ *normal type*, which is just a decoration of the slide,
  - *default* theme, just a normal, plain presentation,
  - *simple* theme, a decorative theme with auto heading continuation,
  - *classic* theme, a plain theme that slides can inherit the same title from the current level 2 heading and auto fit-to-height image insertion.
+ *structured themes*, which contains a functionality from #footlink("https://typst.app/universe/package/navigator")[Navigator] package. These amazing themes are created by #link("https://github.com/eusebe")[David Hajage], which has a complete guide of how to use the themes in  #link("https://github.com/pacaunt/typst-presentate/blob/main/assets/manual/themes-guide.pdf")[theme guide].
#let render-pdf = render-pdf.with(numbered: false)

=== Default Theme
#render-pdf("../examples/example-default-theme.pdf", pages: 3)
#source-example("../examples/example-default-theme.typ")

=== Simple Theme 
#render-pdf("../examples/example-simple-theme.pdf", pages: 6)
#source-example("../examples/example-simple-theme.typ")

=== Classic Theme 
#render-pdf("../examples/example-classic-theme.pdf", pages: 3)
#source-example("../examples/example-classic-theme.typ")

=== Structured Themes 
#let home = "https://github.com/pacaunt/typst-presentate/blob/main/assets/"
You can visit the examples of the structured themes here: 
  - #link(home + "examples/example-minimal.pdf")[minimal] 
  - #link(home + "examples/example-progressive-outline.pdf")[progressive-outline] 
  - #link(home + "examples/example-sidebar.pdf")[sidebar]
  - #link(home + "examples/example-split.pdf")[split] 
  - #link(home + "examples/example-miniframes.pdf")[miniframes]
