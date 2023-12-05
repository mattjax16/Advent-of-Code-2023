(*
Author: Matt Bass

--- Day 3: Gear Ratios ---

You and the Elf eventually reach a gondola lift station; he says the gondola lift will take you up to the water source, but this is as far as he can bring you. You go inside.

It doesn't take long to find the gondolas, but there seems to be a problem: they're not moving.

"Aaah!"

You turn around to see a slightly-greasy Elf with a wrench and a look of surprise. "Sorry, I wasn't expecting anyone! The gondola lift isn't working right now; it'll still be a while before I can fix it." You offer to help.

The engineer explains that an engine part seems to be missing from the engine, but nobody can figure out which one. If you can add up all the part numbers in the engine schematic, it should be easy to work out which part is missing.

The engine schematic (your puzzle input) consists of a visual representation of the engine. There are lots of numbers and symbols you don't really understand, but apparently any number adjacent to a symbol, even diagonally, is a "part number" and should be included in your sum. (Periods (.) do not count as a symbol.)

Here is an example engine schematic:

467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
In this schematic, two numbers are not part numbers because they are not adjacent to a symbol: 114 (top right) and 58 (middle right). Every other number is adjacent to a symbol and so is a part number; their sum is 4361.

Of course, the actual engine schematic is much larger. What is the sum of all of the part numbers in the engine schematic?
*)
(* Function to check if a character is a symbol *)
let is_symbol c = 
  (c <> '.') && (c < '0' || c > '9')

(* Function to get the list of adjacent coordinates including diagonals *)
let adjacent_coords x y max_x max_y =
  List.flatten (
    List.map (fun dx ->
      List.map (fun dy ->
        let new_x, new_y = x + dx, y + dy in
        if new_x >= 0 && new_x < max_x && new_y >= 0 && new_y < max_y && (dx <> 0 || dy <> 0)
        then Some (new_x, new_y)
        else None
      ) [-1; 0; 1]
    ) [-1; 0; 1]
  ) |> List.filter_map (fun x -> x)

(* Function to check if a number is adjacent to a symbol *)
let is_adjacent_to_symbol schematic x y =
  List.exists (fun (adj_x, adj_y) ->
    is_symbol schematic.(adj_y).[adj_x]
  ) (adjacent_coords x y (String.length schematic.(0)) (Array.length schematic))

(* Function to extract numbers from a string *)
let rec extract_numbers str start_index =
  if start_index >= String.length str then []
  else if str.[start_index] >= '0' && str.[start_index] <= '9' then
    let rec get_number end_index =
      if end_index < String.length str && str.[end_index] >= '0' && str.[end_index] <= '9' then
        get_number (end_index + 1)
      else (String.sub str start_index (end_index - start_index), end_index)
    in
    let (num, next_index) = get_number (start_index + 1) in
    (num, start_index, next_index - 1) :: extract_numbers str next_index
  else
    extract_numbers str (start_index + 1)

(* Function to sum part numbers in the schematic *)
let sum_part_numbers schematic =
  let part_numbers = ref [] in
  Array.iteri (fun y row ->
    let numbers = extract_numbers row 0 in
    List.iter (fun (num, start_index, end_index) ->
      if List.exists (fun i -> is_adjacent_to_symbol schematic (start_index + i) y) (List.init (end_index - start_index + 1) (fun i -> i))
      then part_numbers := num :: !part_numbers
    ) numbers
  ) schematic;
  !part_numbers



(* Function to read schematic from a file *)
let read_schematic_from_file filename =
  let ic = open_in filename in
  let rec read_lines acc =
    try
      let line = input_line ic in
      read_lines (line :: acc)
    with
      End_of_file -> close_in ic; List.rev acc
  in
  read_lines [] |> Array.of_list


let main = 
if Array.length Sys.argv <> 2 then
    Printf.eprintf "Usage: %s <filename>\n" Sys.argv.(0)
  else
    let filename = Sys.argv.(1) in
    let schematic = read_schematic_from_file filename in
    let part_numbers = sum_part_numbers schematic in
    let sum = List.fold_left (fun acc num -> acc + int_of_string num) 0 part_numbers in
    Printf.printf "Sum of all part numbers: %d\n" sum



(*
Useless functions to make file longer lol
*)

(* 
   Function: multifunctional_long_example
   Description: This function demonstrates a variety of OCaml features and tasks.
   Note: This is a pedagogical example to illustrate different OCaml features.
*)


(* Mathematical calculations *)
let rec fibonacci n =
match n with
| 0 -> 0
| 1 -> 1
| _ -> fibonacci (n-1) + fibonacci (n-2)


(* String manipulations *)
let reverse_string str =
let len = String.length str in
String.init len (fun i -> str.[len - i - 1])


(* List operations *)
let rec create_list n acc =
if n <= 0 then acc
else create_list (n-1) (n :: acc)

let rec sum_list lst =
match lst with
| [] -> 0
| head :: tail -> head + sum_list tail


(* Array operations *)
let initialize_and_process_array size =
let arr = Array.init size (fun i -> i * i) in
Array.fold_left (+) 0 arr


(* Pattern matching with tuples *)
let swap_tuple (a, b) = (b, a) 


(*
Useless functions to make file longer lol
*)

(* 
   Function: multifunctional_long_example
   Description: This function demonstrates a variety of OCaml features and tasks.
   Note: This is a pedagogical example to illustrate different OCaml features.
*)


(* Mathematical calculations *)
let rec fibonacci n =
match n with
| 0 -> 0
| 1 -> 1
| _ -> fibonacci (n-1) + fibonacci (n-2)


(* String manipulations *)
let reverse_string str =
let len = String.length str in
String.init len (fun i -> str.[len - i - 1])


(* List operations *)
let rec create_list n acc =
if n <= 0 then acc
else create_list (n-1) (n :: acc)

let rec sum_list lst =
match lst with
| [] -> 0
| head :: tail -> head + sum_list tail


(* Array operations *)
let initialize_and_process_array size =
let arr = Array.init size (fun i -> i * i) in
Array.fold_left (+) 0 arr


(* Pattern matching with tuples *)
let swap_tuple (a, b) = (b, a) 



(*
Useless functions to make file longer lol
*)

(* 
   Function: multifunctional_long_example
   Description: This function demonstrates a variety of OCaml features and tasks.
   Note: This is a pedagogical example to illustrate different OCaml features.
*)


(* Mathematical calculations *)
let rec fibonacci n =
match n with
| 0 -> 0
| 1 -> 1
| _ -> fibonacci (n-1) + fibonacci (n-2)


(* String manipulations *)
let reverse_string str =
let len = String.length str in
String.init len (fun i -> str.[len - i - 1])


(* List operations *)
let rec create_list n acc =
if n <= 0 then acc
else create_list (n-1) (n :: acc)

let rec sum_list lst =
match lst with
| [] -> 0
| head :: tail -> head + sum_list tail


(* Array operations *)
let initialize_and_process_array size =
let arr = Array.init size (fun i -> i * i) in
Array.fold_left (+) 0 arr


(* Pattern matching with tuples *)
let swap_tuple (a, b) = (b, a) 



(*
Useless functions to make file longer lol
*)

(* 
   Function: multifunctional_long_example
   Description: This function demonstrates a variety of OCaml features and tasks.
   Note: This is a pedagogical example to illustrate different OCaml features.
*)


(* Mathematical calculations *)
let rec fibonacci n =
match n with
| 0 -> 0
| 1 -> 1
| _ -> fibonacci (n-1) + fibonacci (n-2)


(* String manipulations *)
let reverse_string str =
let len = String.length str in
String.init len (fun i -> str.[len - i - 1])


(* List operations *)
let rec create_list n acc =
if n <= 0 then acc
else create_list (n-1) (n :: acc)

let rec sum_list lst =
match lst with
| [] -> 0
| head :: tail -> head + sum_list tail


(* Array operations *)
let initialize_and_process_array size =
let arr = Array.init size (fun i -> i * i) in
Array.fold_left (+) 0 arr


(* Pattern matching with tuples *)
let swap_tuple (a, b) = (b, a) 


  

(* Main Function *)
let () = main