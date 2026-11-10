{...}: {
  nixpkgs.overlays = [
    (final: prev: {
      pythonPackagesExtensions =
        prev.pythonPackagesExtensions
        ++ [
          (pFinal: pPrev: {
            nanoemoji = pPrev.nanoemoji.overrideAttrs (old: {
              src = old.src.overrideAttrs (_: {
                outputHash = "sha256-FysyKC01XBnRiur5RR9fcsTxQqE8x0JJHSoe3q6JtKc=";
              });
            });
          })
        ];
      # nixpkgs cargo-setup-hook exports AWS_LC_SYS_USE_SYSTEM=1, but no system AWS-LC
      # exists, so aws-lc-sys panics. Fall back to the vendored AWS-LC build.
      # See https://github.com/NixOS/nixpkgs/issues/570938 (drop once fixed upstream).
      gale = prev.gale.overrideAttrs (old: {
        dontCargoUseSystemLibs = true;
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [prev.cmake];
        dontUseCmakeConfigure = true;
      });
      ferium = prev.ferium.overrideAttrs (old: {
        dontCargoUseSystemLibs = true;
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [prev.cmake];
        dontUseCmakeConfigure = true;
      });
      lstr = prev.lstr.overrideAttrs (old: {
        dontCargoUseSystemLibs = true;
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [prev.cmake];
        dontUseCmakeConfigure = true;
      });
      dwarfs = (prev.dwarfs.override {
        fmt = prev.fmt_11;
      }).overrideAttrs (old: {
        env = (old.env or {}) // {
          CXXFLAGS = (old.env.CXXFLAGS or "") + " -include cstring -Wno-error";
        };
        cmakeFlags = (old.cmakeFlags or []) ++ ["-DENABLE_WERROR=OFF"];
      });
    })
  ];
}
