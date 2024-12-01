import d01
import gleam/result
import gleeunit
import gleeunit/should
import simplifile

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn p1_example_test() {
  let input =
    "
3   4
4   3
2   5
1   3
3   9
3   3
"
  let answer = 11
  d01.p1(input)
  |> should.equal(answer)
}

pub fn p1_input_test() {
  let input =
    simplifile.read("input.txt")
    |> result.unwrap("")
  d01.p1(input)
  |> should.equal(1_722_302)
}

pub fn p2_example_test() {
  let input =
    "
3   4
4   3
2   5
1   3
3   9
3   3
"
  let answer = 31
  d01.p2(input)
  |> should.equal(answer)
}

pub fn p2_input_test() {
  let input =
    simplifile.read("input.txt")
    |> result.unwrap("")
  d01.p2(input)
  |> should.equal(20_373_490)
}
