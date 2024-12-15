import d09
import gleam/result
import gleeunit
import gleeunit/should
import simplifile

pub fn main() {
  gleeunit.main()
}

pub fn p1_simple_example_test() {
  let input = "12345"
  // 0..111....22222
  // 02.111....2222.
  // 022111....222..
  // 0221112...22...
  // 02211122..2....
  // 022111222.....
  let output = 0
  d09.p1(input)
  |> should.equal(output)
}

pub fn p1_example_test() {
  let input = "2333133121414131402"
  let output = 1928
  d09.p1(input)
  |> should.equal(output)
}

pub fn p1_solution_test() {
  let input =
    simplifile.read("input.txt")
    |> result.unwrap("")
  d09.p1(input)
  |> should.equal(0)
}

pub fn p2_example_test() {
  let input = ""
  let output = 0
  d09.p2(input)
  |> should.equal(output)
}

pub fn p2_solution_test() {
  let input =
    simplifile.read("input.txt")
    |> result.unwrap("")
  d09.p2(input)
  |> should.equal(0)
}
