Ltac foo :=
  let x := open_constr:(ltac:(exact 0)) in
  idtac x.

Print foo.
