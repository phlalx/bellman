open Core

type t = {
  nodes : Node.t Array.t;
  adjacency : Global_id.t Array.t Array.t;
  outgoing_events : Gevent.t Heap.t;
  (* time of last delivered message, we use a ref instead of "mutable"
     because it'll be slightly more convenient in [send_aux]. See below. *)
  time : float ref 
}

let print_graph adjacency =
  Printf.printf "Topology:\n";
  let f i x = 
    let s = String.concat_array ~sep:", " (Array.mapi adjacency.(i) 
        ~f:(Printf.sprintf !"%{Local_id}-%{Global_id}")) in
    Printf.printf !"%{Global_id} -> %s\n" i s 
  in
  Array.iteri adjacency ~f;
  Printf.printf "---\n"


(* This is the [send] function we'll give to the nodes so they can communicate 
   with their neighbors. It encapsulates the state we need for performing 
   sending (topology, globlal event queue), but hides it from the node. *)
let send_aux time adjacency outgoing_events src (msg, lid) = 
  let dst = adjacency.(src).(lid) in 
  (* lid_dest is the local id of the sender in the local address space of the 
     receiver of the message. This could be done more efficiently if needed *)
  let lid_dest, _ = Array.findi_exn adjacency.(dst) ~f:(fun _ x -> x = src) in
  let levent = Levent.Protocol (msg, lid_dest) in  
  let delivery_time = !time +. (Random.float 1.0) in
  let global_event = Gevent.{ src; dst; levent; delivery_time } in
  Gevent.to_string global_event `Send |> print_string;
  Heap.add outgoing_events global_event

let create ~adjacency =
  let num_nodes = Array.length adjacency in
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

(* generate a meta event 'start' for all nodes *)
let start_all_nodes t =
  let n = Array.length t.nodes in
  for i = 0 to n - 1 do
    Heap.add t.outgoing_events 
    Gevent.{ src = Global_id.dummy; dst = i; levent = Levent.Meta Mevent.Start;
             delivery_time = 0. }
  done