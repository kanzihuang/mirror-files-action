#!/bin/bash

set -euo pipefail

function download() {
  declare repo=$1
  declare version=$2
  declare filename=$3

  mkdir -p releases && cd releases
  curl -fsSLO "https://github.com/$repo/releases/download/v$version/$filename"
  chmod +x "$filename"
	cd ..
}

function generate-script() {
	declare filename=$1
	declare appname=$2
	declare script=install-$appname.sh

  cat > $script <<EOF
#!/bin/bash
sudo install \$(dirname \$0)/releases/$filename /usr/local/bin/$appname
EOF

  chmod 700 $script
}

function main() {
	declare repo=$1
	declare version=$2
	declare filename=$3
	declare appname=$4

	download $repo $version $filename
	generate-script $filename $appname
}

if [[ $# != 4 ]]; then
	echo "Usage: $(basename $0) <repo> <version> <filename> <appname>"
	exit 1
fi

main "${@}"
