#!/bin/bash
# Rename Audible books, 2025-03-29

find -type d -exec rename ': ' ' - ' '{}' \;
find -type d -exec rename ', ' ' - ' '{}' \;
find -type f -exec rename ': ' ' - ' '{}' \;
find -type f -exec rename ', ' ' - ' '{}' \;

