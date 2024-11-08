
import FFIExample
import Lean

instance : BEq ByteArray where
  beq a b := a.data = b.data


def testX25519 : IO Unit := do
  let alicePrivateKey : ByteArray ← generatePrivateKey
  let alicePublicKey := toPublic alicePrivateKey

  let bobPrivateKey : ByteArray ← generatePrivateKey
  let bobPublicKey := toPublic bobPrivateKey

  let bobSharedSecret := dh bobPrivateKey alicePublicKey
  let aliceSharedSecret := dh alicePrivateKey bobPublicKey

  if bobSharedSecret == aliceSharedSecret then
    IO.println "X25519 shared secrets match!"
  else
    panic! "testX25519 failed!"


def main : IO Unit := do
  testX25519

  let _ ← hello
  let result := addFromRust1 1 2
  if result == 3 then
    IO.println "Test passed"
  else
    IO.println s!"Test failed: expected 3, got {result}"

  let a := (10 : Nat)
  let b := (20 : Nat)
  let pair := createNatPair a b
  let (xa, xb) := pair
  IO.println s!"Created pair: {pair} has {xa} and {xb}"
