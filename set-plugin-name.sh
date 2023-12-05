#!/bin/bash

for file in $(find . -name '*template_python*'); do
    git mv "$file" "${file/template_python/$1}"
done

for name in template_python Template; do
    for file in $(grep -rl $name *); do
        sed -i "s/$name/$1/g" $file
    done
done

hyphenated_name=$(echo $1 | sed s/_/-/g)

for file in $(grep -rl template-python *); do
    sed -i "s/template-python/$hyphenated_name/g" $file
done

echo "Template renaming complete. Please commit your changes."