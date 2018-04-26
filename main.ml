
let () =
  let adjacency = [| [|1; 3|]; [|0; 2; 3|]; [|1|]; [|0; 1|] |] in
  let sc = Scheduler.create ~adjacency in
  Scheduler.start_all_nodes sc;
  while Scheduler.schedule sc do () done

