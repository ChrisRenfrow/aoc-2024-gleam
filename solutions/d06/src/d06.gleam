import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string

type Position =
  #(Int, Int)

type Direction {
  North
  South
  East
  West
}

type Guard {
  Guard(position: Position, direction: Direction)
}

type Map =
  List(List(Bool))

/// Returns a Guard (position & direction) and a Map (2d list of Bool)
fn parse_input(input: String) -> #(Guard, Map) {
  let guard_symbol = "^"
  let obstacle_symbol = "#"
  let assert Some(guard) =
    input
    |> string.split("\n")
    |> list.index_fold(None, fn(maybe_guard: Option(Guard), line, y) {
      case maybe_guard {
        Some(guard) -> Some(guard)
        None ->
          case
            line
            |> string.to_graphemes
            |> list.index_fold(None, fn(maybe_idx, char, x) {
              case maybe_idx {
                Some(_) -> maybe_idx
                None ->
                  case char == guard_symbol {
                    True -> Some(x)
                    False -> None
                  }
              }
            })
          {
            Some(x) -> Some(Guard(#(x, y), North))
            None -> None
          }
      }
    })
  let map =
    input
    |> string.split("\n")
    |> list.map(fn(row) {
      row
      |> string.to_graphemes
      |> list.fold([], fn(acc, col) { [col == obstacle_symbol, ..acc] })
      |> list.reverse
    })

  #(guard, map)
}

fn print_map(map: Map, maybe_route: Option(List(Position))) {
  map
  |> list.index_map(fn(row, y) {
    io.println("")
    row
    |> list.index_map(fn(col, x) {
      case maybe_route {
        Some(route) -> {
          case list.contains(route, #(x, y)) {
            True -> io.print("X")
            False -> {
              case col {
                True -> io.print("#")
                False -> io.print(".")
              }
            }
          }
        }
        None -> {
          case col {
            True -> io.print("#")
            False -> io.print(".")
          }
        }
      }
      col
    })
  })
  io.println("")
}

/// Because list.at doesn't exist anymore?
fn element_at(list: List(a), index: Int) -> Option(a) {
  case list {
    [] -> None
    [head, ..] if index == 0 -> Some(head)
    [_, ..tail] -> element_at(tail, index - 1)
  }
}

/// Given a map and a position, will return Some(True) if obstacle, Some(False) if empty,
/// or None if off-map
fn get_cell(map: Map, pos: Position) -> Option(Bool) {
  let #(x, y) = pos
  case map |> element_at(y) {
    Some(row) -> row |> element_at(x)
    None -> None
  }
}

/// Returns a guard one cell in the requested direction
fn move_guard(guard: Guard, dir: Direction) -> Guard {
  let #(x, y) = guard.position
  case dir {
    North -> Guard(#(x, y - 1), dir)
    South -> Guard(#(x, y + 1), dir)
    East -> Guard(#(x + 1, y), dir)
    West -> Guard(#(x - 1, y), dir)
  }
}

fn simulate_patrol(guard: Guard, map: Map) -> List(Position) {
  simulation_loop([], guard, map)
  |> list.reverse
}

fn simulation_loop(
  route: List(Position),
  guard: Guard,
  map: Map,
) -> List(Position) {
  let #(x, y) = guard.position
  let next_cell = case guard.direction {
    North -> get_cell(map, #(x, y - 1))
    South -> get_cell(map, #(x, y + 1))
    East -> get_cell(map, #(x + 1, y))
    West -> get_cell(map, #(x - 1, y))
  }

  case guard.direction, next_cell {
    // Obstacle, turn 90°
    North, Some(True) ->
      simulation_loop(route, Guard(guard.position, East), map)
    East, Some(True) ->
      simulation_loop(route, Guard(guard.position, South), map)
    South, Some(True) ->
      simulation_loop(route, Guard(guard.position, West), map)
    West, Some(True) ->
      simulation_loop(route, Guard(guard.position, North), map)
    // No obstacle and not the end of the map, move guard in the current direction
    dir, Some(False) ->
      simulation_loop([guard.position, ..route], move_guard(guard, dir), map)
    // End of the map, return the route with the current cell visited
    _, _ -> [guard.position, ..route]
  }
}

pub fn p1(input: String) -> Int {
  let #(guard, map) = input |> parse_input
  // map |> print_map(None)
  // io.println("Guard info: " <> string.inspect(guard))
  let route = simulate_patrol(guard, map)
  // io.println("Simulated route: " <> string.inspect(route))
  map |> print_map(Some(route))
  route |> list.unique |> list.length
}

pub fn p2(input: String) -> Int {
  todo
}
