#!/bin/bash -l
# Fetch the EK100 annotation CSVs that the data layer, ek_utils, and the EQL loss
# read. Downloads them straight from the RULSTM repo into the exact path the
# config expects (EK_EXT_PATH), bypassing a full/partial RULSTM clone.
# Run on the LOGIN NODE (needs internet).
set -e

DEST=$HOME/TeSTra/external/rulstm/RULSTM/data/ek100
BASE=https://raw.githubusercontent.com/fpv-iplab/rulstm/master/RULSTM/data/ek100
mkdir -p "$DEST"

for f in actions.csv training.csv validation.csv \
         training_videos.csv validation_videos.csv test_timestamps.csv \
         validation_tail_actions_ids.csv validation_tail_nouns_ids.csv \
         validation_tail_verbs_ids.csv validation_unseen_participants_ids.csv; do
    echo "fetching $f"
    curl -fsSL "$BASE/$f" -o "$DEST/$f"
done

echo
echo "Done -> $DEST"
ls -la "$DEST"
