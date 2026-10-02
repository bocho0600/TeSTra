#!/bin/bash -l
# Download EK100 pre-extracted features + targets for the frame-gate experiments.
#
# RUN THIS ON THE LOGIN NODE (compute nodes have no internet), e.g.:
#   bash ~/TeSTra/jobs/download_ek100.sh                 # -> ~/TeSTra/data/EK100
#   bash ~/TeSTra/jobs/download_ek100.sh /path/on/scratch/EK100   # big disk + symlink
#
# Features are several GB; put them on scratch if your home quota is tight.
set -e

TARGET_DIR=${1:-$HOME/TeSTra/data/EK100}
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

# gdown is the Google Drive downloader used by TeSTra's DATASET.md
pip install -q gdown || true

echo "==> Downloading EK100 features/targets into $TARGET_DIR"
gdown "https://drive.google.com/uc?id=1yHm_kOk5gTnYesl_hTld2uT_awmRJt4O"   # rgb_kinetics_bninception.zip
gdown "https://drive.google.com/uc?id=1Kf-3CwSqpQeKRz8sBQr7QDZTHUhL71nZ"   # flow_kinetics_bninception.zip
gdown "https://drive.google.com/uc?id=1BGv9gW8gIbYhD3yLx5YB7X7GaLjrhKbi"   # target_perframe.zip
gdown "https://drive.google.com/uc?id=10CGWNLscdq1YdAKOAlx8Y-LfdMrB1zHj"   # verb_perframe.zip
gdown "https://drive.google.com/uc?id=1j8HOCpmVpoFcXXCWBa-H-0gd5K4oOOYM"   # noun_perframe.zip

echo "==> Extracting"
for name in rgb_kinetics_bninception flow_kinetics_bninception \
            target_perframe verb_perframe noun_perframe; do
    if [ -f "$name.zip" ]; then
        unzip -q -o "$name.zip" -d "$name/" && rm -f "$name.zip"
    else
        echo "WARNING: $name.zip not found (check the gdown output above)"
    fi
done

# Symlink into the repo if the data lives elsewhere (e.g. scratch).
REPO_DATA="$HOME/TeSTra/data/EK100"
if [ "$TARGET_DIR" != "$REPO_DATA" ]; then
    mkdir -p "$HOME/TeSTra/data"
    ln -sfn "$TARGET_DIR" "$REPO_DATA"
    echo "Symlinked $REPO_DATA -> $TARGET_DIR"
fi

echo
echo "==> RULSTM annotation CSVs (needed by the EK100 data layer + EQL loss)"
# Fetch the CSVs directly into the path the config expects (robust; a plain
# RULSTM clone can miss the data dir on some setups).
RULSTM_DEST="$HOME/TeSTra/external/rulstm/RULSTM/data/ek100"
RULSTM_BASE="https://raw.githubusercontent.com/fpv-iplab/rulstm/master/RULSTM/data/ek100"
mkdir -p "$RULSTM_DEST"
for f in actions.csv training.csv validation.csv \
         training_videos.csv validation_videos.csv test_timestamps.csv \
         validation_tail_actions_ids.csv validation_tail_nouns_ids.csv \
         validation_tail_verbs_ids.csv validation_unseen_participants_ids.csv; do
    echo "fetching $f"
    curl -fsSL "$RULSTM_BASE/$f" -o "$RULSTM_DEST/$f"
done
echo "RULSTM EK100 CSVs -> $RULSTM_DEST"

echo
echo "==> Verify:"
echo "  ls $REPO_DATA         # should list rgb_/flow_/target_/verb_/noun_ dirs"
echo "  ls $HOME/TeSTra/external/rulstm/RULSTM/data/ek100/   # should list CSVs"
