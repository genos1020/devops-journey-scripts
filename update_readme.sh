#!/bin/bash
set -e

README="README.md"
YAML="scripts-description.yml"

# 先生成新內容
NEW_CONTENT=$(while IFS= read -r file; do
  desc=$(yq -r ".scripts[] | select(.file==\"$file\") | .desc" "$YAML")
  desc_md=$(echo "$desc" | sed 's/^/  /')
  echo "- [$file](./$file)"
  echo "$desc_md"
done < <(yq -r ".scripts[].file" "$YAML"))

# 用 awk 取代標記之間的內容
awk -v new="$NEW_CONTENT" '
  /<!-- SCRIPTS-LIST:START -->/ {print; print new; skip=1; next}
  /<!-- SCRIPTS-LIST:END -->/ {print; skip=0; next}
  skip!=1 {print}
' "$README" > "$README.tmp" && mv "$README.tmp" "$README"

echo "✅ README.md 已更新"
