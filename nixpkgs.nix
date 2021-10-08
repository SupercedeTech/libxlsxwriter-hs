let
  rev = "07ca3a021f05d6ff46bbd03c418b418abb781279"; # first 21.05 release
  url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
  pkgs = import (builtins.fetchTarball url) {
    config = {
      packageOverrides = super: {
        libxlsxwriter = null;
        xlsxwriter = super.libxlsxwriter.overrideAttrs (oldAttrs: rec {
          # use newer version to get dtoa flag
          version = "1.1.3";
          src = pkgs.fetchFromGitHub {
            owner = "jmcnamara";
            repo = "libxlsxwriter";
            rev = "RELEASE_${version}";
            sha256 = "0b97wq0f9w30aamxi641b6srr59i45vkxyx8c1v1yxq59yb6kswg";
          };
          # use_dtoa_library: for 40-50% faster double-to-string conversion
          makeFlags = oldAttrs.makeFlags ++ ["USE_DTOA_LIBRARY=1"];
        });
      };
    };
  };
in pkgs
