import gleam/list
import gleam/string
import gleam/yielder.{at, from_list}

type Position =
  #(Int, Int)

type Direction =
  #(Int, Int)

fn parse(input: String) -> List(List(String)) {
  input
  |> string.split("\n")
  |> list.map(string.to_graphemes)
}

fn find_word_in_grid(grid: List(List(String)), word: String) -> List(Position) {
  let rows = list.length(grid)
  let cols = case list.first(grid) {
    Ok(row) -> list.length(row)
    Error(_) -> 0
  }

  let directions = [
    #(0, 1),
    #(1, 0),
    #(0, -1),
    #(-1, 0),
    #(1, 1),
    #(1, -1),
    #(-1, 1),
    #(-1, -1),
  ]

  list.range(0, rows - 1)
  |> list.flat_map(fn(i) {
    list.range(0, cols - 1)
    |> list.flat_map(fn(j) {
      directions
      |> list.flat_map(fn(dir) {
        case
          search_word(grid, string.to_graphemes(word), #(i, j), dir, rows, cols)
        {
          True -> [#(i, j)]
          False -> []
        }
      })
    })
  })
}

fn search_word(
  grid: List(List(String)),
  chars: List(String),
  pos: Position,
  dir: Direction,
  rows: Int,
  cols: Int,
) -> Bool {
  case chars {
    [] -> True
    [current, ..rest] -> {
      let #(row, col) = pos
      let #(dx, dy) = dir

      case is_valid_position(row, col, rows, cols) {
        False -> False
        True -> {
          let current_char = get_char_at(grid, row, col)
          case current_char {
            Ok(grid_char) -> {
              case grid_char == current {
                True -> {
                  search_word(
                    grid,
                    rest,
                    #(row + dx, col + dy),
                    dir,
                    rows,
                    cols,
                  )
                }
                False -> False
              }
            }
            Error(_) -> False
          }
        }
      }
    }
  }
}

fn is_valid_position(row: Int, col: Int, rows: Int, cols: Int) -> Bool {
  row >= 0 && row < rows && col >= 0 && col < cols
}

fn get_char_at(
  grid: List(List(String)),
  row: Int,
  col: Int,
) -> Result(String, Nil) {
  case from_list(grid) |> at(row) {
    Ok(grid_row) -> from_list(grid_row) |> at(col)
    Error(_) -> Error(Nil)
  }
}

pub fn p1(input: String) -> Int {
  parse(input)
  |> find_word_in_grid("XMAS")
  |> list.length
}

pub fn p2(input: String) -> Int {
  todo
}
