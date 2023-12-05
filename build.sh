#! /bin/bash

PROFILE=$1

# check input
if [ ! -d $PROFILE ] || [ "$PROFILE" == "" ]; then
    echo "profile \"$PROFILE\" is not a directory"
    echo "usage: build.sh PROFILE"
    exit 1;
fi

# clear target
rm -rf target
mkdir target

# merge
echo "merge profile...";
./merge-yaml-tree base/v5 $PROFILE/profile target spec.yaml

# create
echo "create json...";
cd target
npx @redocly/openapi-cli bundle --ext=json spec.yaml > ../$PROFILE/$PROFILE.json
cd ..

echo "validate...\n";
./eduhub-validator -r $PROFILE/rules.edn -u https://demo04.test.surfeduhub.nl -o observations.edn -p report.html