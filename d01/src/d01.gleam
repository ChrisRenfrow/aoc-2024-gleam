import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/string

fn parse_columns(input: String) -> #(List(Int), List(Int)) {
  input
  |> string.split("\n")
  |> list.map(string.split(_, "   "))
  |> list.map(fn(row) {
    #(
      row |> list.first |> result.unwrap("") |> int.parse |> result.unwrap(0),
      row |> list.last |> result.unwrap("") |> int.parse |> result.unwrap(0),
    )
  })
  |> list.unzip
}

// ======= Part 1 ========= //

pub fn p1(input: String) -> Int {
  let #(left, right) = parse_columns(input)

  list.zip(list.sort(left, int.compare), list.sort(right, int.compare))
  |> list.map(fn(pair) {
    let #(a, b) = pair
    int.absolute_value(a - b)
  })
  |> list.fold(0, int.add)
}

// ======= Part 2 ========= //

fn get_frequency_map(numbers: List(Int)) -> dict.Dict(Int, Int) {
  list.fold(numbers, dict.new(), fn(dict, num) {
    dict.upsert(dict, num, fn(maybe_count) { option.unwrap(maybe_count, 0) + 1 })
  })
}

pub fn p2(input: String) -> Int {
  let #(left, right) = parse_columns(input)
  let frequency_map = get_frequency_map(right)

  list.fold(left, 0, fn(total, num) {
    let count = dict.get(frequency_map, num) |> result.unwrap(0)
    total + num * count
  })
}
