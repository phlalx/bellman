open Core

type t = {
  nodes : Node.t Array.t;
  adjacency : Global_id.t Array.t Array.t;
  outgoing_events : Gevent.t Heap.t;
  time : float ref  (* time of last delivered message *)
}

let start_all_nodes t =
  let n = Array.length t.nodes in
  for i = 0 to n - 1 do
    Heap.add t.outgoing_events 
    Gevent.{ src = Global_id.dummy; dst = i; levent = Levent.Meta Mevent.Start;
             delivery_time = 0. }
  done

let local_message_to_global_event time adjacency src (msg, lid) = 
  let dst = adjacency.(src).(lid) in
  let lid_dest, _ = Array.findi_exn adjacency.(dst) ~f:(fun _ x -> x = src) in (* TODO *)
  let levent = Levent.Protocol (msg, lid_dest) in  
  let delivery_time = !time +. (Random.float 1.0) in
  Gevent.{ src; dst; levent; delivery_time } 

let send_aux time adjacency outgoing_events src lmsg = 
  let global_event = local_message_to_global_event time adjacency src lmsg in
  Gevent.to_string global_event `Send |> print_string;
  Heap.add outgoing_events global_event

let edges_to_adjacency num_nodes edges =
  let neighbors i = 
    let f (x, y) = if x = i then Some y else if y = i then Some x else None in
    let l_neighbors = List.filter_map edges ~f in
    Array.of_list l_neighbors
  in
  Array.init num_nodes ~f:neighbors

let print_graph adjacency =
  Printf.printf "Topology:\n";
  let f i x = 
    let s = String.concat_array ~sep:", " (Array.mapi adjacency.(i) 
        ~f:(Printf.sprintf !"%{Local_id}-%{Global_id}")) in
    Printf.printf !"%{Global_id} -> %s\n" i s 
  in
  Array.iteri adjacency ~f;
  Printf.printf "---\n"

let create ~num_nodes ~edges =
  let adjacency = edges_to_adjacency num_nodes edges in
  print_graph adjacency;
  let outgoing_events = Heap.create ~cmp:Gevent.cmp () in
  let time = ref 0. in
  let create_node i = 
    let num_neighbors = Array.length adjacency.(i) in 
    Node.create ~num_nodes i ~num_neighbors 
                ~send:(send_aux time adjacency outgoing_events i)
  in
  let nodes = Array.init num_nodes ~f:create_node in
  { nodes; adjacency; outgoing_events; time }

let schedule t = 
  match Heap.pop t.outgoing_events with
  | None -> false
  | Some gevent ->
     Gevent.to_string gevent `Receive |> print_string;
     let node_dst = t.nodes.(gevent.Gevent.dst) in
     t.time := gevent.Gevent.delivery_time;
     Node.execute node_dst gevent.Gevent.levent;
     true
