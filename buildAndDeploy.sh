#!/usr/bin/env bash

# Zipping up everything and deploying the same artifacts to all lambdas. Not the most efficient but fine for what is needed
zip -r artifact.zip node_modules *.js 
