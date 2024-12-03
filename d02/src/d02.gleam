import gleam/int
import gleam/list
import gleam/result
import gleam/string

fn parse_row(row: String) -> List(Int) {
  row
  |> string.split(" ")
  |> list.map(fn(n) { n |> int.parse |> result.unwrap(0) })
}

fn parse_input(input: String) -> List(List(Int)) {
  input
  |> string.split("\n")
  |> list.map(parse_row)
}

// ======= Part 1 ======== //

fn is_safe(report: List(Int)) -> Bool {
  let differences =
    list.window_by_2(report)
    |> list.map(fn(pair) { pair.1 - pair.0 })

  list.all(differences, fn(diff) { diff <= -1 && diff >= -3 })
  || list.all(differences, fn(diff) { diff >= 1 && diff <= 3 })
}

pub fn p1(input: String) -> Int {
  parse_input(input)
  |> list.map(is_safe)
  |> list.count(fn(s) { s == True })
}

// ======= Part 2 ======== //

// Notes:
// We can only ignore one level per report, so we're looking for reports with one out-of-place level
// The moment we hit an impossible condition (more than one out-of-place level) we can safely bail-out
//
// Plan of action: We iterate through all of the elements, identifying if this is an incrementing or decrementing set of levels (achieved by comparing the first and last elements), so long the following elements are decrementing or incrementing by the accepted amounts, keep traversing. Once we find a pair of elements that do not match, check the following element, if it is within the tolerable limits, continue as before, recording that we have "used-up" our dampener. If we encounter another bad set of levels, bail out, otherwise continue to the end of the report and return true
fn safe_pair(a: Int, b: Int, asc: Bool) -> Bool {
  let diff = a - b
  case asc {
    True -> diff <= -1 && diff >= -3
    False -> diff <= 1 && diff >= 3
  }
}

fn can_make_safe(report: List(Int)) -> Bool {
  todo
}

pub fn p2(input: String) -> Int {
  parse_input(input)
  |> list.map(fn(report) {
    case is_safe(report) {
      False -> can_make_safe(report)
      _ -> True
    }
  })
  |> list.count(fn(s) { s == True })
}
