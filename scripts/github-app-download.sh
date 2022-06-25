#!/bin/bash

set -euo pipefail

if [[ $# != 5 ]]; then
	echo "Usage: $(basename $0) <repo> <app> <version> <oses> <arches>"
	exit 1
fi

declare repo=$1
declare app=$2
declare version=$3
declare -a oses=($4)
declare -a arches=($5)

function download() {
  os=$1
  arch=$2
  version=$3
	dot_exe=""
	[[ $os == windows ]] && dot_exe=".exe"

  curl -fsSLO https://github.com/$repo/releases/download/v$version/$app-$os-$arch$dot_exe
	chmod +x $app-$os-$arch$dot_exe
}

function generate-script() {
	declare app=$0

	cat > install.sh <<EOF
#!/bin/bash
set -euo pipefail
if [[ \$# != 2 ]]; then
  echo "Usage: \$(basename \$0) <os> <arch>"
  exit 1
fi
if [[ \$os == windows ]]; then
	echo "Unsupported windows OS"
	exit 1
fi
path=\$(dirname \$0)
os=\$1
arch=\$2
sudo install \$path/releases/$app-\$os-\$arch /usr/local/bin/$app
EOF

	chmod 700 install.sh
}

function main() {
	mkdir -p releases && cd releases
	for os in ${oses[@]}; do
		for arch in ${arches[@]}; do
			download $os $arch $version
		done
	done
	cd ..

	generate-script $app
}

main
