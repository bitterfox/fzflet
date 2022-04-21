#!/bin/bash

cache_dir=$(clipctl cache-dir)
cache_file=$cache_dir/line_cache

LC_ALL=C sort -rnk 1 < "$cache_file" | cut -d' ' -f2- | awk '!seen[$0]++'
