(* Global event.

 Managed by the scheduler. Delivered at time t.delivery_time *)

type t =
  { src : Global_id.t;
    dst : Global_id.t; 
    levent : Levent.t;
    delivery_time : float;
  }

  (* events are typically displayed twices in execution traces, 
     when they are sent, and when they are received with a slighly
     different format *)
  val to_string : t -> [`Send | `Receive] -> string

  (* events are ordered by their delivery time *)
  val cmp : t -> t -> int