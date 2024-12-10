import gleam/dict
import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import gleam/yielder

type Rule =
  #(Int, Int)

type RuleSet =
  dict.Dict(Int, List(Int))

fn parse_input(input: String) -> #(List(Rule), List(List(Int))) {
  let assert Ok(#(rule_str, updates_str)) = input |> string.split_once("\n\n")
  let rules =
    rule_str
    |> string.split("\n")
    |> list.map(fn(line) {
      let assert Ok(#(a_str, b_str)) = line |> string.split_once("|")
      let assert #(Ok(a), Ok(b)) = #(int.parse(a_str), int.parse(b_str))
      #(a, b)
    })
  let updates =
    updates_str
    |> string.split("\n")
    |> list.map(fn(line) {
      line
      |> string.split(",")
      |> list.map(fn(num_str) { num_str |> int.parse |> result.unwrap(0) })
    })

  #(rules, updates)
}

pub fn make_ruleset(rules: List(Rule)) -> RuleSet {
  list.fold(rules, dict.new(), fn(after_set, rule) {
    let #(a, b) = rule
    case dict.get(after_set, a) {
      Ok(pages) -> dict.insert(after_set, a, [b, ..pages])
      Error(_) -> dict.insert(after_set, a, [b])
    }
  })
}

fn valid_update(update: List(Int), rule_set: RuleSet) -> Bool {
  update
  |> list.fold(#(True, []), fn(acc, page) {
    let #(result, visited) = acc
    case result, dict.get(rule_set, page) {
      False, _ -> acc
      True, Ok(after_sub) -> {
        let valid =
          after_sub |> list.all(fn(rule) { !list.contains(visited, rule) })
        #(valid, [page, ..visited])
      }
      True, Error(_) -> #(True, [page, ..visited])
    }
  })
  |> pair.first
}

pub fn p1(input: String) -> Int {
  let #(rules, updates) = parse_input(input)
  let rule_set = make_ruleset(rules)

  updates
  |> list.fold([], fn(valid_updates, update) {
    case valid_update(update, rule_set) {
      True -> [update, ..valid_updates]
      False -> valid_updates
    }
  })
  |> list.fold(0, fn(sum, update) {
    let assert Ok(middle) = update |> list.length |> int.divide(2)
    sum
    + { update |> yielder.from_list |> yielder.at(middle) |> result.unwrap(0) }
  })
}

pub fn p2(input: String) -> Int {
  todo
}
