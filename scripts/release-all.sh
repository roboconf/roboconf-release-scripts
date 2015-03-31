#!/bin/bash

echo "Tagging the web administration..."
. ./web-administration.sh

echo "Releasing the platform..."
. ./platform.sh

echo "Releasing the Eclipse plug-ins..."
. ./eclipse.sh

echo "Updating the web site..."
. ./website.sh

echo "Tagging the examples..."
. ./examples.sh
