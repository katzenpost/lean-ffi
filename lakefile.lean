import Lake
open Lake DSL

package ffi_example where
  srcDir := "Lean"

@[default_target]
lean_lib FFIExample where
  precompileModules := true

@[test_driver]
lean_exe tests {
  root := `Tests.Main
}

extern_lib ffi_example_for_lean pkg := do
  proc { cmd := "cargo", args := #["rustc", "--release", "--", "-C", "relocation-model=pic"], cwd := pkg.dir / "Rust" }
  let name := nameToStaticLib "ffi_example_for_lean"
  let srcPath := pkg.dir / "Rust" / "target" / "release" / name
  IO.FS.createDirAll pkg.nativeLibDir
  let tgtPath := pkg.nativeLibDir / name
  IO.FS.writeBinFile tgtPath (← IO.FS.readBinFile srcPath)
  return pure tgtPath
