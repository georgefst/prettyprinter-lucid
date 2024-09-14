#!/usr/bin/env bash

set -eux -o pipefail
cd $(dirname "${BASH_SOURCE[0]}")

# create Haskell file
# TODO we really need to be able to specify that the local package should be used
# but unfortunately this isn't possible: https://github.com/haskell/cabal/issues/8024#issuecomment-1805454403
cat ../README.md | sed -n '/^```hs$/,/^```$/p' | tail -n +2 | head -n -1 > example.hs

# create HTML file
cabal run example.hs
prettier -w example.html

# create PNG file
TMP_HTML=$(mktemp).html
echo '<html><body style="margin:0; font-size:xxx-large"><div style="background-color:#1f1f1f; padding-left:10px">' > $TMP_HTML
cat example.html >> $TMP_HTML
echo '</div></body></html>' >> $TMP_HTML
firefox -P screenshots --window-size=380,210 --screenshot $(pwd)/example.png file://$TMP_HTML # see https://bugzilla.mozilla.org/show_bug.cgi?id=1762823#c8
