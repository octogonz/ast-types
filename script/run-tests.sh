#!/usr/bin/env bash

set -ex

PROJECTDIR="`cd $(dirname $0)/..; pwd`"

cd $PROJECTDIR/src/test/data

BAB_TAG=v$(node -p 'require("@babel/parser/package.json").version')

if [ ! -d babel-parser ]
then
    git clone --branch "$BAB_TAG" --depth 1 \
        https://github.com/babel/babel.git
    mv babel/packages/babel-parser .
    rm -rf babel
fi

# Hard-code this for now.
TS_TAG=v$(node -p 'require("typescript/package.json").version')

if [ ! -d typescript-compiler ]
then
    git clone --branch "$TS_TAG" --depth 1 \
        https://github.com/Microsoft/TypeScript.git
    mv TypeScript/src/compiler typescript-compiler
    rm -rf TypeScript
fi

cd $PROJECTDIR/src/test

exec $PROJECTDIR/node_modules/.bin/mocha --require ts-node/register/transpile-only \
     --reporter spec --full-trace $@ run.ts
