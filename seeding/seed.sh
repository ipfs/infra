#!/bin/sh
cat refs-to-seed | egrep '^[^#]+$' | xargs echo ipfs refs -r
cat refs-to-seed | egrep '^[^#]+$' | xargs -L1 ipfs refs -r
cat refs-to-seed | egrep '^[^#]+$' | xargs echo ipfs pin add -r
cat refs-to-seed | egrep '^[^#]+$' | xargs -L1 ipfs pin add -r
