#!/bin/bash

README="README.md"
START_MARK="<!-- SCRIPTS-LIST:START -->"
END_MARK="<!-- SCRIPTS-LIST:END -->"

# 如果 README 沒有標記，先加
if ! grep -q "$START_MARK" "$README"; then
    echo -e "\n$START_MARK\n$END_MARK" >> "$README"
fi

# 讀舊的描述
declare -A desc_map
old_order=()
inside_block=false
while IFS= read -r line; do
    [[ "$line" == *"$START_MARK"* ]] && inside_block=true && continue
    [[ "$line" == *"$END_MARK"* ]] && inside_block=false && continue
    if $inside_block; then
        if [[ "$line" =~ \[([^]]+)\]\(.*\)\s*(.*) ]]; then
            file="${BASH_REMATCH[1]}"
            desc="${BASH_REMATCH[2]}"
            # 去掉多餘空格
            desc="$(echo "$desc" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
            desc_map["$file"]="$desc"
            old_order+=("$file")
        fi
    fi
done < "$README"

# 找出目前資料夾所有 .sh 檔
current_scripts=(*.sh)

# 建立新清單（舊檔在前，新檔在後），統一格式：檔名 + 一個空格 + 描述
new_list=()
for file in "${old_order[@]}"; do
    [[ -f "$file" ]] && new_list+=("- [$file](./$file) ${desc_map[$file]}")
done
for file in "${current_scripts[@]}"; do
    if [[ ! " ${old_order[*]} " =~ " $file " ]]; then
        new_list+=("- [$file](./$file) TODO: 在這裡補上這個腳本的簡短說明")
    fi
done

# 更新 README 標記區塊
awk -v start="$START_MARK" -v end="$END_MARK" -v list="$(printf "%s\n" "${new_list[@]}")" '
    $0 ~ start {print; printf "%s\n", list; skip=1; next}
    $0 ~ end {print; skip=0; next}
    skip != 1 {print}
' "$README" > "$README.tmp" && mv "$README.tmp" "$README"

echo "✅ README.md 已更新"
