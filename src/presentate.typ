#import "freeze-counters.typ": freeze-states-mark, start-location
#import "utils.typ"
#import "indices.typ"
#import "animation.typ": pdfpc-slide-markers
#import "element.typ": applier, make-tree, mode-wrapper, object, reconstruct, updater
#import "store.typ"

#let subslide(s, i, tree) = {
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
  if i > 1 or not s.at(0).logical-slide {
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
  show: preamble
  // Save the location, idea from Touying.
  context start-location.update(here())
  context {
    let states = store.states.get()
    // Resolve page index for pdfpc
    if not states.at(0).logical-slide {
      states.at(0).add-page-index += 1
    }
    states.at(0).logical-slide = logical-slide
    // The main body's tree
    let (states, tree) = make-tree(applier(body, body-fn), states: states)
    let animation-info = indices.resolve(states)
    let steps = steps
    if steps == auto {
      (steps,) = animation-info
    }

    states.at(0).steps = steps
    states.at(0).waypoints = animation-info.waypoints
    // main slide content

    if not states.at(0).handout {
      for i in range(1, steps + 1) {
        freeze-states-mark(states)
        subslide(states, i, tree)
      }
    } else {
      freeze-states-mark(states)
      subslide(states, steps, tree)
    }
  }
  // magic ???
  start-location.update(none)
}
