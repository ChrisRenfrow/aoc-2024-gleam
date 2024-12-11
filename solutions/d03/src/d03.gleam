import gleam/int
import gleam/list
import gleam/regexp

fn match_mul(input: String) -> List(String) {
  let assert Ok(re) =
    regexp.compile(
      "mul\\([0-9]{1,3},[0-9]{1,3}\\)",
      regexp.Options(case_insensitive: False, multi_line: True),
    )
  regexp.scan(re, input)
  |> list.map(fn(match) { match.content })
}

fn parse_mul(muls: List(String)) -> List(#(Int, Int)) {
  let assert Ok(re) = regexp.from_string("[0-9]{1,3}")
  muls
  |> list.map(fn(mul) {
    let assert [a_match, b_match] = regexp.scan(re, mul)
    let assert #(Ok(a), Ok(b)) = #(
      int.parse(a_match.content),
      int.parse(b_match.content),
    )
    #(a, b)
  })
}

pub fn p1(input: String) -> Int {
  match_mul(input)
  |> parse_mul
  |> list.fold(0, fn(acc, pair) {
    let #(a, b) = pair
    acc + a * b
  })
}

pub fn p2(input: String) -> Int {
  todo
}
