#!/bin/sh
# script to create a new blog post

# get post id
id=$(($(cat src/blog.yaml\
	|grep destination:\
	|awk '{print $2;}'\
	|sort -n\
	|tail -n 1) + 1))


# get post id from stdin
echo -n "Enter post title (id=$id): "
read title

# date formatted in ISO8601 format
date=$(date -Iseconds)

# write to blog index
echo "Creating blog.yaml index entry..."
echo "
- template: ../posts/$id
  destination: $id
  title: $title
  date: $date" >>src/blog.yaml

# remove empty lines from file
# see: https://stackoverflow.com/a/29549497/2397327
echo "$(awk 'NF' src/blog.yaml)" >src/blog.yaml

# create pug file with default template
echo "Creating default pug template..."
echo "extends blogpost

block post
	p (Empty blog post)" >"src/posts/$id.pug"

echo "Done."
