import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/pair
import gleam/result
import gleam/string

type Block =
  Int

/// A representation of the dense format used to describe a set of blocks in a DiskMap
type BlockMap {
  BlockMap(id: Int, blocks: Int, space: Int)
}

/// A disk map is a list of number pairs which each represent the number of chunks occupied
/// and the amount of consecutive empty chunks following
type DiskMap =
  List(BlockMap)

fn build_disk_map(nums: List(Int)) {
  build_disk_map_helper(nums, 0)
}

fn build_disk_map_helper(nums: List(Int), curr_id: Int) -> DiskMap {
  case nums {
    [n_blocks, n_space, ..rest] -> [
      BlockMap(curr_id, n_blocks, n_space),
      ..build_disk_map_helper(rest, curr_id + 1)
    ]
    [n_blocks] -> [BlockMap(curr_id, n_blocks, 0)]
    [] -> []
  }
}

/// Returns a "decompressed" disk_map represented as a list of blocks of data (Some(block)) and empty space (None)
fn disk_map_to_blocks(disk_map: DiskMap) -> List(Option(Block)) {
  disk_map
  |> list.fold([], fn(blocks, block_map) {
    let local_blocks =
      list.range(1, block_map.blocks) |> list.map(fn(_) { Some(block_map.id) })
    let space = case block_map.space {
      n if n < 1 -> []
      n -> list.range(1, n) |> list.map(fn(_) { None })
    }
    list.flatten([blocks, local_blocks, space])
  })
}

fn parse_input(input: String) -> List(Option(Block)) {
  input
  |> string.to_graphemes
  |> list.map(int.parse)
  |> list.map(fn(op) {
    let assert Ok(block) = op
    block
  })
  |> build_disk_map
  |> disk_map_to_blocks
}

// TODO: Make this not broken :)
fn compress_disk(blocks: List(Option(Block))) -> List(Option(Block)) {
  let idx_blocks = list.range(0, list.length(blocks) - 1) |> list.zip(blocks)
  // Indexed and reverse-ordered "bank" of right-most non-empty blocks
  let idx_rev_blocks =
    idx_blocks
    |> list.filter(fn(pair) {
      let #(_, opt_block) = pair
      case opt_block {
        Some(_) -> True
        None -> False
      }
    })
    |> list.reverse
  let #(_, compressed, _) =
    idx_blocks
    |> list.fold(#([], [], idx_rev_blocks), fn(acc, block) {
      let #(shifted, compressed_disk, rev_blocks) = acc
      case block {
        #(i, None) -> {
          let assert Ok(#(#(j, next), rest)) =
            rev_blocks |> list.pop(fn(_) { True })
          case i < j {
            True -> #([next, ..shifted], [next, ..compressed_disk], rest)
            False -> #(
              shifted,
              [block |> pair.second, ..compressed_disk],
              rev_blocks,
            )
          }
        }
        #(_, Some(b)) ->
          case list.contains(shifted, Some(b)) {
            True -> #(shifted, [None, ..compressed_disk], rev_blocks)
            False -> #(shifted, [Some(b), ..compressed_disk], rev_blocks)
          }
      }
    })
  compressed |> list.reverse
}

pub fn p1(input: String) -> Int {
  let blocks = input |> parse_input
  let compressed = blocks |> compress_disk

  list.range(0, list.length(compressed))
  |> list.zip(compressed)
  |> list.fold(0, fn(acc, idx_block) {
    case idx_block {
      #(i, Some(file_id)) -> acc + i * file_id
      _ -> acc
    }
  })
}

pub fn p2(input: String) -> Int {
  todo
}
