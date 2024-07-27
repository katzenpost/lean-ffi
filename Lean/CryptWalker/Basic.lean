
@[extern "add_one"]
opaque addOne : UInt32 → UInt32

def specialAddOne : (x : Nat) → Nat :=
  fun x => (addOne (UInt32.ofNat x)).toNat

axiom addOne_eq_add_one : ∀ x : Nat, x + 1 < UInt32.size -> specialAddOne x = x + 1

variable (a b c d e : Nat)
variable (h1 : a = b)
variable (h2 : b = specialAddOne c)
variable (h3 : c = d)
variable (h4 : e = 1 + d)
variable (h5 : c + 1 < UInt32.size)

theorem T : a = e :=
  calc
    a = b := h1
    b = specialAddOne c := h2
    specialAddOne c = c + 1 := addOne_eq_add_one c h5
    c + 1 = d + 1 := congrArg Nat.succ h3
    d + 1 = 1 + d := Nat.add_comm d 1
    1 + d = e := Eq.symm h4

@[extern "create_tuple"]
opaque create_nat_tuple_impl : Nat → Nat → Nat × Nat

def createNatPair (a b : Nat) : Nat × Nat :=
  create_nat_tuple_impl a b

