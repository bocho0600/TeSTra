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

# RULSTM python module needed by the EK100 EVALUATION (verb/noun marginalization):
#   perframe_det_batch_inference.py does
#   `from external.rulstm.RULSTM.utils import (get_marginal_indexes, marginalize, ...)`
RULSTM_DIR=$HOME/TeSTra/external/rulstm/RULSTM
mkdir -p "$RULSTM_DIR"
echo "fetching utils.py"
curl -fsSL "https://raw.githubusercontent.com/fpv-iplab/rulstm/master/RULSTM/utils.py" -o "$RULSTM_DIR/utils.py"

echo
echo "Done."
echo "CSVs  -> $DEST"; ls "$DEST" | head
echo "utils -> $RULSTM_DIR/utils.py"; ls -l "$RULSTM_DIR/utils.py"
