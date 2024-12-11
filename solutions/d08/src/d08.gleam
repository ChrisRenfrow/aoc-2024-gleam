import gleam/dict
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/regexp
import gleam/result
import gleam/string

pub type Point {
  Point(x: Int, y: Int)
}

/// Returns the width and the height of the map as well as a list of each frequency
/// along with their respective antenna positions
fn parse_input(input: String) -> #(#(Int, Int), List(#(String, List(Point)))) {
  let assert Ok(antenna_regex) = regexp.from_string("[A-Za-z0-9]")

  let grid =
    input
    |> string.split("\n")
    |> list.map(fn(row) { row |> string.to_graphemes })

  let height = grid |> list.length
  let width = case list.first(grid) {
    Ok(first) -> list.length(first)
    Error(_) -> 0
  }

  let frequencies =
    grid
    |> list.index_map(fn(row, y) {
      row
      |> list.index_map(fn(col, x) {
        case antenna_regex |> regexp.check(col) {
          True -> #(col, Point(x, y))
          False -> #(".", Point(x, y))
        }
      })
    })
    |> list.flatten
    |> list.filter(fn(el) {
      let #(k, _) = el
      k != "."
    })
    |> list.fold(dict.new(), fn(d, frequency) {
      let #(label, position) = frequency
      dict.upsert(d, label, fn(positions) {
        case positions {
          Some(p) -> [position, ..p]
          None -> [position]
        }
      })
    })
    |> dict.to_list

  #(#(height, width), frequencies)
}

pub fn get_distance(p1: Point, p2: Point) -> Float {
  float.square_root(
    {
      int.power(p2.x - p1.x, 2.0)
      |> result.unwrap(0.0)
    }
    +. {
      int.power(p2.y - p1.y, 2.0)
      |> result.unwrap(0.0)
    },
  )
  |> result.unwrap(0.0)
}

pub fn find_antinodes(p1: Point, p2: Point) -> #(Point, Point) {
  let d = get_distance(p1, p2)
  let dx = int.to_float(p2.x - p1.x)
  let dy = int.to_float(p2.y - p1.y)
  let length = float.square_root(dx *. dx +. dy *. dy) |> result.unwrap(1.0)
  let unit_dx = dx /. length
  let unit_dy = dy /. length

  let antinode_a =
    Point(
      float.round(int.to_float(p1.x) -. unit_dx *. d),
      float.round(int.to_float(p1.y) -. unit_dy *. d),
    )
  let antinode_b =
    Point(
      float.round(int.to_float(p2.x) +. unit_dx *. d),
      float.round(int.to_float(p2.y) +. unit_dy *. d),
    )

  #(antinode_a, antinode_b)
}

/// Given a list of antenna of a particular frequency, calculate and
/// return a list of their antinodes
fn eval_antenna(antenna: List(Point)) -> List(Point) {
  case list.length(antenna) {
    1 -> []
    _ -> {
      list.combinations(antenna, 2)
      |> list.map(fn(pair) {
        let assert [a, b] = pair
        let #(n1, n2) = find_antinodes(a, b)
        [n1, n2]
      })
      |> list.flatten
    }
  }
}

fn print_map(
  width: Int,
  height: Int,
  antenna: List(#(String, List(Point))),
  maybe_antinodes: Option(List(Point)),
) {
  let grid =
    list.range(0, height - 1)
    |> list.map(fn(y) {
      list.range(0, width - 1)
      |> list.map(fn(x) {
        let current = Point(x, y)

        // Check if point is an antenna
        let antenna_label =
          list.find(antenna, fn(a) {
            let #(_, positions) = a
            list.contains(positions, current)
          })

        case antenna_label {
          Ok(#(label, _)) -> label
          Error(_) -> {
            // Check if point is an antinode
            let is_antinode = case maybe_antinodes {
              Some(antinodes) -> list.contains(antinodes, current)
              None -> False
            }
            case is_antinode {
              True -> "#"
              False -> "."
            }
          }
        }
      })
      |> string.join("")
    })
    |> string.join("\n")

  io.println(grid)
}

pub fn p1(input: String) -> Int {
  let #(#(width, height), frequencies) =
    input
    |> parse_input

  frequencies
  |> list.flat_map(fn(antenna) {
    let #(_, positions) = antenna
    eval_antenna(positions)
  })
  |> list.unique
  |> list.filter(fn(point) {
    point.x < width && point.y < height && point.x >= 0 && point.y >= 0
  })
  |> list.length
}

pub fn p2(input: String) -> Int {
  todo
}
