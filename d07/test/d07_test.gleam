import d07
import gleam/result
import gleeunit
import gleeunit/should
import simplifile

pub fn main() {
  gleeunit.main()
}

pub fn p1_example_test() {
  let input =
    "190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20"
  let output = 3749
  d07.p1(input)
  |> should.equal(output)
}

pub fn p1_solution_test() {
  let input =
    simplifile.read("input.txt")
    |> result.unwrap("")
  d07.p1(input)
  |> should.equal(1_298_103_531_759)
}

pub fn p2_example_test() {
  let input =
    "190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20"
  let output = 11_387
  d07.p2(input)
  |> should.equal(output)
}

pub fn p2_solution_test() {
  let input =
    simplifile.read("input.txt")
    |> result.unwrap("")
  d07.p2(input)
  |> should.equal(0)
}
