import d10
import gleam/result
import gleeunit
import gleeunit/should
import simplifile

pub fn main() {
  gleeunit.main()
}

pub fn p1_one_trail_test() {
  // 0123
  // 1234
  // 8765
  // 9876
  let input =
    "0123
1234
8765
9876"
  let output = 1
  d10.p1(input)
  |> should.equal(output)
}

pub fn p1_two_trail_test() {
  let input =
    "...0...
...1...
...2...
6543456
7.....7
8.....8
9.....9"
  let output = 2
  d10.p1(input)
  |> should.equal(output)
}

pub fn p1_example_test() {
  let input =
    "89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732"
  let output = 36
  d10.p1(input)
  |> should.equal(output)
}

pub fn p1_solution_test() {
  let input =
    simplifile.read("input.txt")
    |> result.unwrap("")
  d10.p1(input)
  |> should.equal(587)
}

pub fn p2_example_test() {
  let input =
    "89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732"
  let output = 81
  d10.p2(input)
  |> should.equal(output)
}

pub fn p2_solution_test() {
  let input =
    simplifile.read("input.txt")
    |> result.unwrap("")
  d10.p2(input)
  |> should.equal(1340)
}
