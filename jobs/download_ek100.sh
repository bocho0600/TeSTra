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
mkdir -p "$HOME/TeSTra/external"
cd "$HOME/TeSTra/external"
if [ ! -d rulstm ]; then
    git clone https://github.com/fpv-iplab/rulstm.git
fi
echo "RULSTM cloned to ~/TeSTra/external/rulstm"
echo "The EK100 CSVs must end up at: external/rulstm/RULSTM/data/ek100/"
echo "  (training.csv, validation.csv, and the verb/noun/action mapping CSVs)"
echo "Follow the RULSTM README to fetch its EK100 annotation data if those"
echo "CSVs are not already present under RULSTM/data/ek100/."

echo
echo "==> Verify:"
echo "  ls $REPO_DATA         # should list rgb_/flow_/target_/verb_/noun_ dirs"
echo "  ls $HOME/TeSTra/external/rulstm/RULSTM/data/ek100/   # should list CSVs"
