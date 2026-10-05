#import "freeze-counters.typ": freeze-states-mark, start-location
#import "utils.typ"
#import "indices.typ"
#import "animation.typ": pdfpc-slide-markers
#import "element.typ": make-tree, applier, updater, mode-wrapper, object, reconstruct
#import "store.typ"

#let subslide(s, i, tree, logical-slide: true) = {
  // set states to originals.
  s.at(0).subslide = i
  s.at(0).pause-state.hidden = false
  s.at(0).parsing-state.shown = false
  s = s.slice(0, 1)

  // Touying x Polylux's originals
  {
    let body
    set heading(outlined: i == 1, bookmarked: i == 1)
    (s, body) = reconstruct(tree, states: s)
    body
  }

  v(0pt)
  // freeze page number, tricks from minideck.
  if i > 1 or not logical-slide {
    counter(page).update(x => x - 1)
  }

  pdfpc-slide-markers(s, i)

  if s.at(0).drafted {
    place(
      center + horizon,
      text(size: 3in, str(i), fill: black.transparentize(90%)),
    )
  }

  pagebreak(weak: true)
}

/// Presentate slide function
/// -> content
#let slide(
  /// the content on the slide
  /// -> content
  body,
  /// Total number of subslides needed. `auto` means detecting automatically.
  /// -> auto | int
  steps: auto,
  /// function that wraps only the content.
  /// -> function
  body-fn: it => it,
  /// function that wraps the whole slide.
  /// -> function
  preamble: it => it,
  /// whether this should be counted as a logical slide. This effects page numbering as non-logical slide will have a skipped page number.
  /// -> bool
  logical-slide: true,
) = {
  // Save the location, idea from Touying.
  context start-location.update(here())
  // Resolve page index for pdfpc
  updater(s => {
    let (info, ..x) = s
    if not info.logical-slide {
      info.add-page-index += 1
    }
    info.logical-slide = logical-slide
    (info,)
  })

  let subslide = subslide.with(logical-slide: logical-slide)

  mode-wrapper("content", object("slide", caller: s => {
    // The main body's tree
    let (s, tree) = make-tree(applier(body, body-fn), states: s)
    let steps = steps
    let (info, ..x) = s
    let animation-info = indices.resolve(s)
    if steps == auto {
      (steps,) = animation-info
    }

    s.at(0).steps = steps 
    s.at(0).waypoints = animation-info.waypoints

    let result = context {
      if not info.handout {
        for i in range(1, steps + 1) {
          freeze-states-mark(s)
          subslide(s, i, tree)
        }
      } else {
        freeze-states-mark(s)
        subslide(s, steps, tree)
      }
    }
    // reset states
    s.at(0).pause-state.hidden = false
    s.at(0).waypoints = (:)

    return (s, result)
  }))
  // magic ???
  start-location.update(none)
}

#let init(body, ..options) = {
  let defaults = store.default-states.first()
  let states = (utils.merge-dicts(options.named(), base: defaults),)
  let (final, tree) = make-tree(body, states: states)
  return reconstruct(tree, states: states).last()
}