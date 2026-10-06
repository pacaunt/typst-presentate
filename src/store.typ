#import "utils.typ"
#import "indices.typ"
#import "element.typ": updater

#let prefix = "_presentate"

#let default-states = (
  (
    /// number of subslides required
    steps: 1,
    /// current number of subslides
    subslide: 1,
    /// modes
    handout: false,
    drafted: false,
    /// frozen states and counters
    freeze-states: true,
    frozen-states-and-counters: (
      counter(figure.where(kind: image)),
      counter(figure.where(kind: table)),
      counter(footnote),
      counter(heading),
      counter(math.equation),
    ),
    add-page-index: 0, // for pdfpc and BeamerPresenter.
    logical-slide: true,
    default-hider: hide,
    waypoints: (:),
    pause-state: (
      hider: hide,
      default-hider: hide,
      hidden: false,
    ),
    parsing-state: (shown: false),
    saved: (conditions: (), storage: (:))
  ),
)

#let states = state(prefix + "_states", default-states)

#let set-options(..options) = element.updater(s => {
  s.at(0) = utils.merge-dicts(options.named, base: default-states.first())
  s
})

