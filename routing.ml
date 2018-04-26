open Core

type elt = { mutable dist : int; mutable route : Local_id.t } 

type t = elt Array.t

let create ~num_nodes gid = 
  let f _ = { dist = Int.max_value; route = Local_id.dummy } in
  let res = Array.init num_nodes ~f in 
  res.(gid).dist <- 0;
  res

let update t lid t' = 
  let changed = ref false in
  for i = 0 to Array.length t - 1 do
    if t'.(i).dist < t.(i).dist - 1 then (
      t.(i).dist <- t'.(i).dist + 1;
      t.(i).route <- lid;
      changed := true
    );
  done;
  !changed

let elt_to_string i {dist; route} = 
  Printf.sprintf !"%{Global_id}: dist %d, route %{Local_id}" i dist route

let to_string t = 
  Array.mapi t ~f:elt_to_string |> String.concat_array ~sep:"; "  
  
