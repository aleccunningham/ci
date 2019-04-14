#!/bin/bash

set +exuo pipefail

if [[ -r dbuild.json ]] ; then
    DBUILD=dbuild.json
fi

if ! ($DBUILD && $(cat $DBUILD | jq --raw-output '. | .dependencies.override//false'))  ; then
    # default language dependencies
    echo Exporting RAILS_ENV
    export RAILS_ENV=test
    echo Exporting RACK_ENV
    export RACK_ENV=test
    echo Exporting SECRET_KEY_BASE
    export SECRET_KEY_BASE=some-long-random-string-will-suffice-for-this
fi

if ! ($DBUILD && $(cat $DBUILD | jq --raw-output '. | .setup.override//false')); then
    # default language setup
    bundle install
    bundle exec rake db:create db:schema:load --trace
fi
if $DBUILD ; then
    source <(cat $DBUILD | jq --raw-output '. | .setup.custom[]?')
fi

echo "<h3>Test</h3>"
if ! ($DBUILD && $(cat $DBUILD | jq --raw-output '. | .test.override//false')); then
    # default language test
    bundle exec rake test
fi
if $DBUILD ; then
    source <(cat $DBUILD | jq --raw-output '. | .test.custom[]?')
fi

exec "$@"
