// IDEA: There are two modes of parsing: array and content mode. Content mode
// assumes every parsable element is a content, so the parser terminates when
// the data is not a content. However, array mode assumes every element is an
// array with only one member, which must not be an array or parsable.
#import "utils.typ" as utils: strfmt
#import "indices.typ"

#let sequence = [].func()
#let styled = [#set text(fill: red)].func()
#let identity(it) = it

// Use .. to indicate the spread of positional arguments
#let content-positionals = (
  // models
  ([].func(), "children"),
  ([#set text(fill: red)].func(), "child", "styles"),
  (text, "text"),
  (enum.item, "number", "body"),
  (list.item, "body"),
  (terms.item, "term", "description"),
  (metadata, "value"),
  (footnote.entry, "note"),
  (link, "dest", "body"),
  (ref, "target"),
  (align, "alignment", "body"),
  (columns, "count", "body"),
  (place, "alignment", "body"),
  (rotate, "angle", "body"),
  (curve, "..components"),
  (polygon, "..vertices"),
  // Math functions
  (math.attach, "base"),
  ($a$.body.func(), "text"),
  (math.frac, "num", "denom"),
  (math.accent, "base", "accent"),
  (math.binom, "upper", "lower"),
  (math.class, "class", "body"),
  (math.mat, "..rows"),
  (math.primes, "count"),
  (math.root, "index", "radicand"),
  (math.sqrt, "radicand"),
  (math.underbrace, "body", "annotation"),
  (math.overbrace, "body", "annotation"),
  (math.underbracket, "body", "annotation"),
  (math.overbracket, "body", "annotation"),
  (math.underparen, "body", "annotation"),
  (math.overparen, "body", "annotation"),
  (math.undershell, "body", "annotation"),
  (math.overshell, "body", "annotation"),
)

#let content-functions = content-positionals.map(info => info.first())

#let content-no-parse = (
  [#state("_").update(none)].func(),
  (context {}).func(),
  $a$.body.func(),
  layout,
  image,
  bibliography,
  outline,
  cite,
  text,
  heading,
  h,
  v,
)

#let empty-content = ([], [ ], parbreak(), linebreak(), pagebreak(), colbreak())

#let object(type, ..properties) = (
  __presentate-object-type__: type,
  ..properties.named(),
)

#let is-object(obj) = type(obj) == dictionary and "__presentate-object-type__" in obj.keys()

#let type-of(obj) = if is-object(obj) { obj.__presentate-object-type__ } else { type(obj) }

#let peek(i, arr: ()) = arr.at(i, default: none)

#let empty-object = object("empty")

#let mode-wrapper(mode, info) = {
  if mode == "array" { return (info,) }
  if mode == "content" { return [#metadata(info)<__presentate-mark__>] }
  panic(strfmt("Unknown mode `{}`, expected: \"array\" or \"content\".", mode))
}
/// Presentate's element constructor
#let element(
  func,
  fields: (:),
  positionals: (),
  ..others,
) = object(
  "element",
  func: func,
  positionals: positionals,
  fields: fields,
  ..others,
)

#let join(children, ..props) = element(
  array.sum,
  fields: (children: children),
  positionals: ("children",),
  hidable: false,
  ..props,
)

#let generic(body, func, named: (:), ..props) = element(
  func,
  fields: (body: body) + named,
  positionals: ("body",),
  ..props,
)

#let collect(children, func, named: (:), ..props) = element(
  func,
  fields: (children: children) + named,
  positionals: ("..children",),
  ..props,
)

#let state-updater(func) = object("state-updater", func: func)

#let state-getter(func) = object("state-getter", func: func)

#let updater(mode: "content", func) = mode-wrapper(mode, state-updater(func))

#let getter(mode: "content", func) = mode-wrapper(mode, state-getter(func))

#let applier(mode: "content", template: generic, ..args) = mode-wrapper(mode, template(mode: mode, ..args))

#let interface(
  func,
  inner: "array",
  outer: "content",
  hider: hide,
) = (..args) => mode-wrapper(outer, collect(
  args.pos(),
  func,
  mode: inner,
  named: args.named(),
  inner-hider: hider,
))

#let custom(
  func,
  mode: "array",
  ..props,
) = (..args) => applier(
  args.pos(),
  func,
  mode: mode,
  named: args.named(),
  template: collect,
  ..props,
)

// Assume that every content can be deconstructed to a dictionary containing 1)
// its element function, 2) its reconstructed fields dictionary. The field
// dictionary as two sub-fields: named and positional fields, which are
// important for reconstruct such element.
#let reconstruct-one(elem, states: ()) = {
  if type-of(elem) != "element" { return elem }

  let (positionals, fields, func) = elem
  let pos = (empty-object,) * positionals.len()
  let pos-names = positionals.map(name => name.trim(".."))
  let named = (:)
  let label

  // Arrange the positional arguments
  for (k, v) in fields.pairs() {
    if k in pos-names {
      pos.at(pos-names.position(name => name == k)) = v
    } else if k == "label" {
      label = v
    } else {
      named.insert(k, v)
    }
  }
  pos = pos.filter(it => not type-of(it) == "empty")

  // Spread the ..children positional args
  let restored-pos = ()
  for (name, val) in positionals.zip(pos) {
    if name.starts-with("..") {
      restored-pos += val
    } else {
      restored-pos.push(val)
    }
  }

  if elem.at("contextual", default: false) { func = func.with(states) }
  let restored = func(..restored-pos, ..named)

  if elem.at("mode", default: auto) != "content" { return restored }
  if label != none { return [#restored#label] }

  return restored
}

/// Main element reconstruction function.
#let reconstruct(
  tree,
  states: (),
  scope: (
    item-counter: 0,
    item-lead-parbreak: false,
    item-follow-parbreak: false,
    hider: auto,
  ),
) = {
  // initializing, reset the parameters
  states.at(0).parsing-state.shown = false
  let hider = if scope.hider == auto {
    states.at(0).pause-state.hider
  } else { scope.hider }

  let item-funcs = (enum.item, list.item)

  if type-of(tree) == array {
    let peek = peek.with(arr: tree)
    let item-object = object(
      "item",
      group: (),
      tight: true,
      lead-parbreak: false,
      follow-parbreak: false,
    )

    let allowed-empty-between-item(it) = (
      (it in ([], [ ], parbreak()))
        or {
          type-of(it) == "state-updater"
        }
    )
    let allowed-between-item(it) = (
      allowed-empty-between-item(it)
        or {
          type-of(it) == "element" and it.func in item-funcs
        }
    )

    let this-item = item-object
    let item-count = 0
    let inter-tree = ()
    // Get properties about items. This `inter-tree` parsing must not
    // remove/insert any elements. All elements can be categorized into 3
    // groups: 1) the allowed between items, but present before the items, 2)
    // the allowed between items, and 3) the not-allowed between items. This
    // loop will handle all of these cases.
    for (i, sub-tree) in tree.enumerate() {
      if type-of(sub-tree) == "element" {
        if sub-tree.func in item-funcs {
          item-count += 1
          if item-count == 1 {
            this-item.lead-parbreak = peek(i - 1) == parbreak()
          }
        }
      }
      // The allowed between items, after the first item.
      if item-count > 0 and allowed-between-item(sub-tree) {
        this-item.group.push(sub-tree)
        if sub-tree == parbreak() { this-item.tight = false }
      }
      // The not-allowed between items, after the first item. This will
      // terminates item groupping.
      if not allowed-between-item(sub-tree) and item-count > 0 {
        item-count = 0
        this-item.follow-parbreak = true
        inter-tree.push(this-item)
        this-item = item-object
      }
      // The other not-allowed between items
      if not allowed-between-item(sub-tree) {
        inter-tree.push(sub-tree)
      }
      // The allowed between items, but present before the items.
      if item-count == 0 and allowed-empty-between-item(sub-tree) {
        inter-tree.push(sub-tree)
      }
    }
    // Collect the leftover.
    if item-count > 0 { inter-tree.push(this-item) }
    // length of the array must be preserved to ensure no element is dropped.
    if inter-tree.map(it => if type-of(it) == "item" { it.group } else { (it,) }).sum(default: ()).len() != tree.len() {
      panic(strfmt("Intermediate parsing of items failed, inter-tree={}, tree={}", inter-tree.len(), tree.len()))
    }
    // main reconstruction loop.
    let new-tree = ()
    for sub-tree in inter-tree {
      // Force realization of tight or non-tight items, which will be important
      // for determining item spacing later.
      if type-of(sub-tree) == "item" {
        scope.item-counter = 0
        scope.item-lead-parbreak = sub-tree.lead-parbreak
        scope.item-follow-parbreak = sub-tree.follow-parbreak
        scope.item-tight = sub-tree.tight
        // The loop is important to see the states' updates sequentially.
        for item in sub-tree.group {
          if type-of(item) == "element" and item.func in item-funcs {
            scope.item-counter += 1
          }
          (states, item) = reconstruct(item, states: states, scope: scope)
          new-tree.push(item)
        }
        // reset item counter
        scope.item-counter = 0

        continue
      }
      // Elements-other-than-items' reconstruction.
      (states, sub-tree) = reconstruct(sub-tree, states: states, scope: scope)
      new-tree.push(sub-tree)
    }
    // If the visible state of any child in a children is changed, the parent
    // element will not be hidden -> parsing.state.shown = true
    if new-tree.any(it => type-of(it) == "state-updater") {
      states.at(0).parsing-state.shown = true
      // filtering out the updater
      new-tree = new-tree.filter(it => type-of(it) != "state-updater")
    }

    return (states, new-tree)
  }

  if type-of(tree) == "state-updater" {
    states = (tree.func)(states)
    return (states, tree)
  }

  if type-of(tree) == "state-getter" {
    return reconstruct((tree.func)(states), states: states)
  }

  if type-of(tree) != "element" {
    return (states, tree)
  }

   let wrapper(s, body) = {
    let hider = hider
    let normal = identity
    // Resolving spacing between items. This will break the items but force the
    // label to be hidden.
    if tree.func in item-funcs {
      if scope.item-counter == 1 and not scope.item-tight {
        normal = it => parbreak() + it
      }

      hider = it => hider(context {
        if not scope.item-tight { return block(it) }

        let style = (:)
        if scope.item-counter == 1 {
          if scope.item-lead-parbreak {
            style.above = par.spacing
          } else {
            style.above = par.leading
          }
        } else if scope.item-counter > 1 {
          if not scope.item-follow-parbreak {
            style.below = par.leading
          }
          style.above = par.leading
        }

        block(..style, it)
      })
    }
 
    // Only when the parent element does not contain any state update will the
    // element be hidden.
    if not s.at(0).parsing-state.shown {
      if states.at(0).pause-state.hidden { hider(body) } else { normal(body) }
    } else {
      normal(body)
    }
  }

  let states-prior = states
  // scoped hider for inner element if specified.
  if tree.at("inner-hider", default: auto) != auto {
    scope.hider = tree.inner-hider
  }

  for (k, v) in tree.fields.pairs() {
    (states, v) = reconstruct(v, states: states, scope: scope)
    tree.fields.at(k) = v
  }
  // context provided to the element must be prior to its children.
  let restored = reconstruct-one(tree, states: states-prior)
  // some intermediate elements are not hidable.
  if tree.at("hidable", default: true) { restored = wrapper(states, restored) }

  return (states, restored)
}

// Assume every element is a content, which can be destructed into its fields /
// and element function. The native 'parsed' element will be stored in
// `metadata` function.
#let make-tree(
  body,
  states: (),
  scope: (
    mode: "content",
    semantic-array: false,
  ),
) = {
  // if scope.mode == "array" { scope.semantic-array = true }
  let make-tree = make-tree.with(scope: scope)

  if type-of(body) == "state-updater" {
    states = (body.func)(states)
    return (states, body)
  }

  if type-of(body) == "state-getter" {
    (states, _) = make-tree((body.func)(states), states: states)
    return (states, body)
  }

  if type-of(body) == "element" {
    if body.at("mode", default: auto) != auto { scope.mode = body.mode }
    for (k, v) in body.fields.pairs() {
      let new-value
      // this array is NOT a semantic array, it is just a container.
      if { ".." + k } in body.positionals {
        new-value = ()
        for sub-tree in v {
          (states, sub-tree) = make-tree(sub-tree, states: states, scope: scope)
          new-value.push(sub-tree)
        }
      } else {
        (states, new-value) = make-tree(v, states: states, scope: scope)
      }
      // set the new, parsed value to the fields.
      body.fields.at(k) = new-value
    }
    return (states, body)
  }

  if type-of(body) == array {
    // Handling array joining elements, such as in CeTZ, by separating each
    // joined element into individuals, and suming them later. The normal
    // sequence will work as usual.
    let new-tree = ()
    for sub-tree in body {
      // unwrap double concealed element, such as (pause,)
      if type-of(sub-tree) == content and sub-tree.func() == metadata and is-object(sub-tree.value) {
        sub-tree = sub-tree.value
      }
      // protect the inner element
      if scope.mode == "array" and not is-object(sub-tree) {
        let make-array(it) = (it,)
        sub-tree = generic(sub-tree, make-array, mode: scope.mode)
      }
      // then generate tree
      (states, sub-tree) = make-tree(sub-tree, states: states)

      new-tree.push(sub-tree)
    }
    // This `join` will cancels the splitted sub-arrays of the assumed elements.
    if scope.mode == "array" { new-tree = join(new-tree, mode: scope.mode) }
    return (states, new-tree)
  }

  if type-of(body) != content {
    return (states, body)
  }

  if body.func() == metadata and is-object(body.value) {
    return make-tree(body.value, states: states, scope: scope)
  }

  if body in empty-content {
    return (states, body)
  }

  if body.func() in content-no-parse {
    let no-parse() = body
    return (states, element(no-parse))
  }

  let func = body.func()
  let positionals = ()

  if func not in content-functions {
    if body.has("body") {
      positionals.push("body")
    } else if body.has("child") {
      positionals.push("child")
    } else if body.has("children") {
      positionals.push("..children")
    } else if body.has("text") {
      positionals.push("text")
    }
  } else {
    (_, ..positionals) = content-positionals.find(f => f.first() == func)
  }

  return make-tree(
    element(func, fields: body.fields(), positionals: positionals),
    states: states,
  )
}
