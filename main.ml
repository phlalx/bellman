
let () =
  let edges = [ (0,1); (0,2); (1,2) ] in
  let sc = Scheduler.create ~num_nodes:3 ~edges in
  Scheduler.start_all_nodes sc;
  while Scheduler.schedule sc do () done

