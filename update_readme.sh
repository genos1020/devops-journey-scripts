#!/bin/bash                     

set -e                          # 任何指令回傳非 0 就中止腳本（避免半寫入）

README="README.md"              # 目標 README 檔名
YAML="scripts-description.yml"  # 來源 YAML 檔名（存每個腳本的描述）

# 先生成新內容（會被塞到 README 的標記區塊中）
NEW_CONTENT=$(
  # 以 while 讀出 YAML 裡每個 .scripts[].file 的檔名
  while IFS= read -r file; do
    # 用 yq 取出該檔名對應的多行描述字串（保留換行）
    desc=$(yq -r ".scripts[] | select(.file==\"$file\") | .desc" "$YAML")

    # 每一行描述前面加兩個空白，讓 Markdown 變成清楚的次行（縮排）
    desc_md=$(echo "$desc" | sed 's/^/  /')

    # 輸出一個項目的兩部分：
    # 1) 清單的第一行：- [檔名](./檔名)
    echo "- [$file](./$file)"
    # 2) 描述本體（可能多行），已加縮排
    echo "$desc_md"

    # while 讀取的資料來自於下面的 process substitution
  done < <(yq -r ".scripts[].file" "$YAML")
)

# 用 awk 取代 README 中兩個標記之間的內容
awk -v new="$NEW_CONTENT" '                      \
  /<!-- SCRIPTS-LIST:START -->/ {                \
    print;          # 先把 START 標記那行原樣印出
    print new;      # 接著印出剛剛組好的 NEW_CONTENT（多行字串）
    skip=1;         # 之後遇到的行先「跳過不印」直到 END
    next;           \
  }                                               \
  /<!-- SCRIPTS-LIST:END -->/ {                  \
    print;          # 把 END 標記那行印出
    skip=0;         # 結束跳過狀態
    next;           \
  }                                               \
  skip!=1 { print }  # 非跳過狀態下，其他行照常輸出
' "$README" > "$README.tmp" && mv "$README.tmp" "$README"

echo "✅ README.md 已更新"  # 成功訊息
