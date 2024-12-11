#!/usr/bin/env fish

set day $argv[1]

set day_padded (string pad -w 2 -c 0 $day)

set project_dir "solutions/d$day"
set template_dir "templates"

cp "$template_dir/src/day_template.gleam" "$project_dir/src/d$day_padded.gleam"
cp "$template_dir/test/day_template_test.gleam" "$project_dir/test/d$day_padded"_test.gleam

sed -i "s/DAY_NUMBER/$day_padded/g" "$project_dir/src/d$day_padded.gleam"
sed -i "s/DAY_NUMBER/$day_padded/g" "$project_dir/test/d$day_padded"_test.gleam

cd "$project_dir"
gleam add simplifile
# Remove the auto-generated README from `gleam new`
rm -f README.md
