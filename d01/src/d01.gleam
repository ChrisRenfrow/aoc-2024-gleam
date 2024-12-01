import gleam/dict
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string

fn parse_p1(input: String) -> #(List(Int), List(Int)) {
  let parse_numbers = fn(numbers) {
    numbers
    |> list.map(result.unwrap(_, ""))
    |> list.map(int.parse)
    |> list.map(result.unwrap(_, 0))
  }

  let pairs =
    input
    |> string.split("\n")
    |> list.map(string.split(_, "   "))

  let left_col = pairs |> list.map(list.first(_)) |> parse_numbers
  let right_col = pairs |> list.map(list.last(_)) |> parse_numbers

  #(left_col, right_col)
}

pub fn p1(input: String) {
  let #(left, right) = parse_p1(input)

  let sorted_left = list.sort(left, int.compare)
  let sorted_right = list.sort(right, int.compare)

  list.map2(sorted_left, sorted_right, fn(a, b) { int.absolute_value(a - b) })
  |> list.fold(0, int.add)
}

pub fn p2(input: String) {
  let #(left, right) = parse_p1(input)

  let inc = fn(x) {
    case x {
      Some(i) -> i + 1
      None -> 0
    }
  }

  let rh_dict =
    list.fold(right, dict.new(), fn(d, k) {
      case dict.has_key(d, k) {
        True -> dict.upsert(d, k, inc)
        False -> dict.insert(d, k, 1)
      }
    })

  list.fold(left, 0, fn(acc, x) {
    case dict.get(rh_dict, x) {
      Ok(count) -> acc + x * count
      Error(_) -> acc
    }
  })
}
