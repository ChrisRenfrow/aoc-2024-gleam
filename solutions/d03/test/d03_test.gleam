import d03
import gleam/result
import gleeunit
import gleeunit/should
import simplifile

pub fn main() {
  gleeunit.main()
}

pub fn p1_example_test() {
  let input =
    "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
  let output = 161
  d03.p1(input)
  |> should.equal(output)
}

pub fn p1_solution_test() {
  let input =
    simplifile.read("input.txt")
    |> result.unwrap("")
  d03.p1(input)
  |> should.equal(0)
}

pub fn p2_example_test() {
  let input = ""
  let output = 0
  d03.p2(input)
  |> should.equal(output)
}

pub fn p2_solution_test() {
  let input =
    simplifile.read("input.txt")
    |> result.unwrap("")
  d03.p2(input)
  |> should.equal(0)
}
