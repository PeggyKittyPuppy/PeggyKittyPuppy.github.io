#!/bin/bash

#================================================================
# defind functions 
#================================================================
check_url() {
    local url="$1"
    status_code=$(curl -I -s -o /dev/null -w "%{http_code}" $url)
    if [[ $status_code -eq 200 || $status_code -eq 301 || $status_code -eq 302 || $status_code -eq 418 || $status_code -eq 403 ]]; then
        echo -e "$url \033[32m[✓]\033[0m"
    else
        echo -e "$url \033[31m[x]\033[0m"
    fi
}

check_local() {
    local link="$1"
    local file="$2"
    if [[ $link == /* ]]; then 
        link="./${link#/}" # if start with "/", replace with "./"
    else 
        link=$(dirname "$file")/$link # add path
    fi
    if [[ $link == */ ]]; then 
        link=$(ls $link | grep index.) # if folder, find index
    fi
    if [[ -e $link ]]; then
        echo -e "$link \033[32m[✓]\033[0m"
    else
        echo -e "$link \033[31m[x]\033[0m"
    fi
}

#================================================================
# checking 
#================================================================
tree -C -P '*.php|*.html'

files=$(find . -type f \( -name "*.html" -o -name "*.php" \))
echo "[✓] means 'exists', [x] means not exist"

for file in $files; do
    echo "Checking $file ..."
    urls1=$(grep -o '<a href="[^"]*">' $file | sed 's/<a href="//;s/">//') # e.g., <a href="https://xxx">xxx</a>
    urls2=$(grep -o 'https://[^[:space:]]*"' $file | sed 's/"$//') # e.g., https in script
    locals=$(grep -oE '<(link|img)[^>]*(href|src)="[^"]*"' $file | sed -E 's/<(link|img)[^>]*(href|src)="([^"]*)"/\3/') # extract local links and imgs, e.g., <link xxx href="xxx">; <img src="xxx">
    # merge
    merged_urls=$(echo "$urls1 $urls2 $locals" | tr ' ' '\n' | sort | uniq)
    for link in $merged_urls; do
        if [[ $link == "#"* ]]; then # skip toc
            continue
        fi
        if [[ $link == "mailto"* ]]; then # skip email
            continue
        fi
        if [[ $link == http* ]]; then
	    continue
            check_url $link
        else
            check_local $link $file
        fi
    done
    echo "done !"
done
