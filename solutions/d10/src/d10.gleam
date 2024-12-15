import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/string

type Map =
  Dict(Int, Dict(Int, Int))

type Point {
  Point(x: Int, y: Int)
}

fn parse_input(input: String) -> #(Map, List(Point)) {
  input
  |> string.split("\n")
  |> list.index_fold(#(dict.new(), []), fn(acc, row, y) {
    let #(row_dict, trailheads) = acc
    let #(col_dict, new_trailheads) =
      row
      |> string.to_graphemes
      |> list.index_fold(#(dict.new(), []), fn(col_acc, col, x) {
        let #(col_dict, current_trailheads) = col_acc
        case col {
          "." -> #(col_dict |> dict.insert(x, -1), current_trailheads)
          _ ->
            case int.parse(col) {
              Ok(0) -> #(col_dict |> dict.insert(x, 0), [
                Point(x, y),
                ..current_trailheads
              ])
              Ok(n) -> #(col_dict |> dict.insert(x, n), current_trailheads)
              _ -> panic as "unreachable"
            }
        }
      })
    #(
      row_dict |> dict.insert(y, col_dict),
      list.append(trailheads, new_trailheads),
    )
  })
}

fn map_dimensions(map: Map) -> #(Int, Int) {
  let max_y = dict.size(map)
  let max_x = case dict.get(map, 0) {
    Ok(row) -> dict.size(row)
    _ -> 0
  }
  #(max_x, max_y)
}

fn map_to_str(map: Map) -> String {
  let #(max_x, max_y) = map_dimensions(map)
  list.range(0, max_y - 1)
  |> list.map(fn(y) {
    list.range(0, max_x - 1)
    |> list.map(fn(x) {
      case get_xy(map, x, y) {
        Ok(-1) -> "."
        Ok(n) -> int.to_string(n)
        Error(_) -> " "
      }
    })
    |> string.join("")
  })
  |> string.join("\n")
}

/// Returns the value at x/y coordinates given a Map. Will return Error(Nil) if not found.
pub fn get_xy(map: Map, x: Int, y: Int) -> Result(Int, Nil) {
  case dict.get(map, y) {
    Ok(row) -> dict.get(row, x)
    Error(Nil) -> Error(Nil)
  }
}

fn explore_paths(
  map: Map,
  curr_pt: Point,
  cell_val: Int,
  visited: List(Point),
) -> List(Point) {
  case cell_val == 9 {
    True -> [curr_pt]
    False -> {
      let possible_moves = [
        Point(x: curr_pt.x + 1, y: curr_pt.y),
        Point(x: curr_pt.x - 1, y: curr_pt.y),
        Point(x: curr_pt.x, y: curr_pt.y + 1),
        Point(x: curr_pt.x, y: curr_pt.y - 1),
      ]

      possible_moves
      |> list.filter(fn(next_point) {
        case get_xy(map, next_point.x, next_point.y) {
          Ok(next_val) -> {
            next_val == cell_val + 1 && !list.contains(visited, next_point)
          }
          Error(_) -> False
        }
      })
      |> list.flat_map(fn(next_point) {
        explore_paths(map, next_point, cell_val + 1, [curr_pt, ..visited])
      })
    }
  }
}

fn find_paths(map: Map, trailheads: List(Point)) -> List(Point) {
  trailheads
  |> list.flat_map(fn(start) { explore_paths(map, start, 0, []) |> list.unique })
}

fn find_paths_p2(map: Map, trailheads: List(Point)) -> List(Point) {
  trailheads
  |> list.flat_map(fn(start) { explore_paths(map, start, 0, []) })
}

pub fn p1(input: String) -> Int {
  let #(map, trailheads) = input |> parse_input

  find_paths(map, trailheads) |> list.length
}

pub fn p2(input: String) -> Int {
  let #(map, trailheads) = input |> parse_input

  find_paths_p2(map, trailheads) |> list.length
}
