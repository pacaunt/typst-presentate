#let merge-dicts(dictA, base: (:)) = {
  for (key, val) in dictA {
    if type(val) == dictionary and key in base.keys() {
      base.insert(key, merge-dicts(dictA.at(key), base: base.at(key)))
    } else {
      base.insert(key, val)
    }
  }
  return base
}

/// Composes a function from an array of functions.
///
/// - init: The initial state (default: states).
/// - funcs: An array of functions to compose.
///
/// Returns: The result of applying all functions in the array to the initial state.
#let compose_func_from_array(init: (:), funcs) = {
  let out = init
  for func in funcs {
    out = func(out)
  }
  return out
}