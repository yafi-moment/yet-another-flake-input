{
  fetchurl,
  runCommand,
  _url ? "https://github.com/Revolution641/rom-archive/raw/3ed88d7be055672f4a67179b23c51c7d0ac799de/Super%20Mario%2064%20(USA).z64",
  _hash ? "sha256-F84Hc0PGEz+Mny1tbZpKtiyM0qpXxArqH0kLTIuyHZE=",
  region ? "us",
}: let
  file = fetchurl {
    url = _url;
    hash = _hash;
  };
  filename = "baserom.${region}.z64";
  result = runCommand "baserom-${region}-safety-dir" {} ''
    mkdir $out
    cp ${file} $out/${filename}
  '';
in
  result
  // {
    romPath = "${result.outPath}/${filename}";
  }
