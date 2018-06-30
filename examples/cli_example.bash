#!/bin/bash
set -euo pipefail

file=/tmp/file.csv
echo "id,username
1,buren
# comment line
2,jacob
" > $file

echo "=== EXAMPLE: Type map & skip comment lines ==="
echo
honey_format --skip-lines="#" \
						 --type-map=username=upcase \
					   $file
