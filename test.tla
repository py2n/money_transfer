-------------------------------- MODULE test --------------------------------
EXTENDS Naturals,TLC

             
(**********
--algorithm test{  
  
variables A_account = 10 , B_account = 10 , total = A_account + B_account;

process (E \in 1..3) variables money \in 1..30;{
            D: if (A_account > money) {
                A: A_account := A_account - money;
                B_account := B_account + money;
            };
    
    C: assert A_account > 0;
    }
    }
}
**********)

\* BEGIN TRANSLATION (chksum(pcal) = "5563f46e" /\ chksum(tla) = "daf81864")
VARIABLES A_account, B_account, total, pc, money

vars == << A_account, B_account, total, pc, money >>

ProcSet == (1..3)

Init == (* Global variables *)
        /\ A_account = 10
        /\ B_account = 10
        /\ total = A_account + B_account
        (* Process E *)
        /\ money \in [1..3 -> 1..30]
        /\ pc = [self \in ProcSet |-> "D"]

D(self) == /\ pc[self] = "D"
           /\ IF A_account > money[self]
                 THEN /\ pc' = [pc EXCEPT ![self] = "A"]
                 ELSE /\ pc' = [pc EXCEPT ![self] = "C"]
           /\ UNCHANGED << A_account, B_account, total, money >>

A(self) == /\ pc[self] = "A"
           /\ A_account' = A_account - money[self]
           /\ B_account' = B_account + money[self]
           /\ pc' = [pc EXCEPT ![self] = "C"]
           /\ UNCHANGED << total, money >>

C(self) == /\ pc[self] = "C"
           /\ Assert(A_account > 0, 
                     "Failure of assertion at line 16, column 8.")
           /\ pc' = [pc EXCEPT ![self] = "Done"]
           /\ UNCHANGED << A_account, B_account, total, money >>

E(self) == D(self) \/ A(self) \/ C(self)

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == (\E self \in 1..3: E(self))
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 
negative_money == money >=0
equal == (A_account+B_account = 20)
===============
