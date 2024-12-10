import dDAY_NUMBER
import gleam/result
import gleeunit
import gleeunit/should
import simplifile

pub fn main() {
  gleeunit.main()
}

pub fn p1_example_test() {
  let input = ""
  let output = 0
  dDAY_NUMBER.p1(input)
  |> should.equal(output)
}

pub fn p1_solution_test() {
  let input =
    simplifile.read("input.txt")
    |> result.unwrap("")
  dDAY_NUMBER.p1(input)
  |> should.equal(0)
}

pub fn p2_example_test() {
  let input = ""
  let output = 0
  dDAY_NUMBER.p2(input)
  |> should.equal(output)
}

pub fn p2_solution_test() {
  let input =
    simplifile.read("input.txt")
    |> result.unwrap("")
  dDAY_NUMBER.p2(input)
  |> should.equal(0)
}
