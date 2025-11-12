final: prev: {
  sm64baserom = final.callPackage ./pkgs/sm64baserom {};
  sm64ex-ap = final.callPackage ./pkgs/sm64ex-ap {sm64baserom = final.callPackage ./pkgs/sm64baserom {};};
}
