#!/bin/sh

# script to create a new blog post
# usage: ./new_post.sh "Post Name"

# get post id from cmd line args
test=$1

# new blog yaml entry
id=$(($(cat src/blog.yaml\
	|grep destination:\
	|sort\
	|tail -n 1\
	|awk '{print $2;}') + 1))

# date formatted in ISO8601 format
date=$(date -Iseconds)

# write to blog index
echo "- template: ../posts/$id
  destination: $id
  title: $1
  date: $date" >>src/blog.yaml

# create pug file with default template
echo "extends blogpost

block post" >"src/posts/$id.pug"
