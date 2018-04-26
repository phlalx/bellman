
type t =
  { src : Global_id.t;
    dst : Global_id.t; 
    levent : Levent.t;
    delivery_time : float;
  }

  val to_string : t -> [`Send | `Receive] -> string

  val cmp : t -> t -> int