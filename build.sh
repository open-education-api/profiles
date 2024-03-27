#! /bin/bash

PROFILE=$1

# check input
if [ ! -d $PROFILE ] || [ "$PROFILE" == "" ]; then
    echo "profile \"$PROFILE\" is not a directory"
    echo "usage: build.sh PROFILE"
    exit 1;
fi

# clear target
rm -rf $PROFILE/target
mkdir $PROFILE/target

# merge
echo "merge profile...";
./merge-yaml-tree base/v5 $PROFILE/profile $PROFILE/target spec.yaml

# create
echo "create json...";
cd $PROFILE/target
npx @redocly/openapi-cli bundle --ext=json spec.yaml > ../$PROFILE.json
cd ../..

echo "validate...\n";
rm observations.edn
rm report.html
./eduhub-validator -r $PROFILE/rules.edn -u https://demo04.test.surfeduhub.nl -o observations.edn -p report.html