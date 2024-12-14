/// Merges two dictionaries recursively.
///
/// - dictA: The dictionary to merge into the base dictionary.
/// - base: The base dictionary to merge into (default: empty dictionary).
///
/// Returns: A new dictionary containing the merged key-value pairs from both input dictionaries.
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
/// - init: The initial state (default: empty dictionary).
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

/// Creates a new function that wraps the given function with additional context-aware behavior.
///
/// - func: The function to wrap.
/// - modified-args: A function that takes 'self' and returns additional arguments (default: returns none).
/// - preamble: A function that processes 'self' and the result of the wrapped function (default: identity function).
///
/// Returns: A new function that incorporates the context-aware behavior.
#let aware(func, modified-args: self => none, preamble: (self, it) => it) = {
  (self, ..args) => preamble(self, func(..args, ..modified-args(self)))
}

/// Subtracts corresponding elements of two arrays.
///
/// - arr1: The first array.
/// - arr2: The second array to subtract from the first.
///
/// Returns: A new array where each element is the difference between corresponding elements of arr1 and arr2.
#let subtract-array(arr1, arr2) = {
  let reps = calc.max(arr1.len(), arr2.len())
  let out = ()
  for i in range(reps) {
    out.push(arr1.at(i, default: 0) - arr2.at(i, default: 0))
  }
  out
}