import gleam/int
import gleam/list
import gleam/result
import gleam/string

fn parse_input(input: String) -> List(#(Int, List(Int))) {
  input
  |> string.split("\n")
  |> list.map(fn(line) {
    case line |> string.split_once(":") {
      Ok(#(left, right)) -> {
        let assert Ok(test_value) = left |> int.parse
        let assert Ok(numbers) =
          right
          |> string.trim_start
          |> string.split(" ")
          |> list.try_map(int.parse)
        #(test_value, numbers)
      }
      Error(_) -> panic as "Couldn't split on ':' for line"
    }
  })
}

/// Given a list of `numbers`, find a combination of operations (*, +) which evaluate to `value`
/// Returns True if a valid combination is found
/// Returns False if no such combination exists
fn find_valid_ops(numbers: List(Int), value: Int) -> Bool {
  case numbers {
    [last] -> value == last
    [left, right, ..rest] -> {
      find_valid_ops([left * right, ..rest], value)
      || find_valid_ops([left + right, ..rest], value)
    }
    _ -> False
  }
}

fn concat_digits(a: Int, b: Int) -> Int {
  string.concat([int.to_string(a), int.to_string(b)])
  |> int.parse
  |> result.unwrap(0)
}

/// Much like the above, but with an added concatenation operator
/// Returns True if a valid combination is found
/// Returns False if no such combination exists
fn find_valid_ops_p2(numbers: List(Int), value: Int) -> Bool {
  p2_helper(0, numbers, value)
}

fn p2_helper(acc: Int, numbers: List(Int), value: Int) -> Bool {
  case numbers {
    [] -> acc == value
    [last] ->
      acc + last == value
      || acc * last == value
      || concat_digits(acc, last) == value
    [left, right, ..rest] -> {
      p2_helper(acc + left * right, rest, value)
      || p2_helper(acc + left + right, rest, value)
      || p2_helper(acc + concat_digits(left, right), rest, value)
    }
  }
}

pub fn p1(input: String) -> Int {
  parse_input(input)
  |> list.map(fn(equation) {
    let #(value, nums) = equation
    case find_valid_ops(nums, value) {
      True -> value
      False -> 0
    }
  })
  |> int.sum
}

pub fn p2(input: String) -> Int {
  parse_input(input)
  |> list.map(fn(equation) {
    let #(value, nums) = equation
    case find_valid_ops_p2(nums, value) {
      True -> value
      False -> 0
    }
  })
  |> int.sum
}
