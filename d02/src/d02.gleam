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

fn can_make_safe(report: List(Int)) -> Bool {
  todo
}

pub fn p2(input: String) -> Int {
  parse_input(input)
  |> list.map(can_make_safe)
  |> list.count(fn(s) { s == True })
}
