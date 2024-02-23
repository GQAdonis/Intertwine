#!/bin/bash

docker buildx build -t tribehealth/intertwine:v0.0.1 --push --platform=linux/amd64  .
