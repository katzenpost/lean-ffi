/-
SPDX-FileCopyrightText: © 2024 David Stainton
SPDX-License-Identifier: AGPL-3.0-only

Inspired by the Haskell FFI X25519:
https://github.com/haskell-crypto/cryptonite/blob/master/Crypto/PubKey/Curve25519.hs
-/

def keySize : Nat := 32

@[extern "curve25519"]
opaque curve25519 : ByteArray → ByteArray → ByteArray

def dh (privateKey : ByteArray) (publicKey : ByteArray) : ByteArray :=
  if privateKey.size ≠ keySize then
    panic! "Private key must be 32 bytes long."
  else if publicKey.size ≠ keySize then
    panic! "Public key must be 32 bytes long."
  else
    curve25519 privateKey publicKey

def toPublic (privateKey : ByteArray) : ByteArray :=
  dh privateKey basepoint
  where
  basepoint : ByteArray := ByteArray.mk #[0x09, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                                       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                                       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                                       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
def generatePrivateKey : IO ByteArray := do
  let mut arr := ByteArray.mkEmpty 32
  for _ in [0:32] do
    let randomByte ← IO.rand 0 255
    arr := arr.push (UInt8.ofNat randomByte)
  return arr
