(* Generic id type, for global and local addressing. In the current
   implementation, ids must be posivitet integer as they are used as
   array indices. *)
open Core

module type ID = sig

  type t = int

  val dummy : t

  val to_string : t -> string
  
end

module Id = struct
  open Core

  type t = int

  let dummy = -1

  let to_string t = 
    if t = dummy then
      "*"
    else
      Int.to_string t

end