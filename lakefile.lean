import Lake
open Lake DSL

set_option diagnostics true

require mathlib from git "https://github.com/leanprover-community/mathlib4"@"master"


package ffi_example where
  srcDir := "Lean"

@[default_target]
lean_lib FFIExample where
  precompileModules := true

@[test_driver]
lean_exe tests {
  root := `Tests.Main
}

target importTarget pkg : FilePath := do
  let oFile := pkg.buildDir / "c" / "curve25519-donna.o"
  let srcJob ← Lake.inputTextFile <| pkg.dir / "C" / "curve25519-donna.c"
  buildFileAfterDep oFile srcJob fun srcFile => do
    let flags := #["-I", toString (← getLeanIncludeDir), "-fPIC"]
    compileO oFile srcFile flags

extern_lib ffi pkg := do
  let job ← fetch <| pkg.target ``importTarget
  let libFile := pkg.nativeLibDir / nameToStaticLib "curve25519-donna"
  buildStaticLib libFile #[job]

extern_lib ffi_example_for_lean pkg := do
  proc { cmd := "cargo", args := #["rustc", "--release", "--", "-C", "relocation-model=pic"], cwd := pkg.dir / "Rust" }
  let name := nameToStaticLib "ffi_example_for_lean"
  let srcPath := pkg.dir / "Rust" / "target" / "release" / name
  IO.FS.createDirAll pkg.nativeLibDir
  let tgtPath := pkg.nativeLibDir / name
  IO.FS.writeBinFile tgtPath (← IO.FS.readBinFile srcPath)
  return pure tgtPath
