open Core

type t =
  { src : Global_id.t;
    dst : Global_id.t; 
    levent : Levent.t;
    delivery_time : float;
  }

let to_string t d = 
     let src, dst, arrow =
      match d with
     | `Send -> (t.src, t.dst, "->")
     | `Receive -> (t.dst, t.src, "<-")
     in
     Printf.sprintf !"%{Global_id} %s %{Global_id}: %{Levent}\n" src arrow dst 
                    t.levent

let cmp t1 t2 = compare t1.delivery_time t2.delivery_time

  