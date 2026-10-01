# Pre-embedding frame gate on EK100 (ported into TeSTra)

This branch (`feat/frame-gate`) ports the pre-embedding frame gate from the LSTR
fork into TeSTra, so the gate can be evaluated on a second dataset (EK100), which
the original fork does not support.

## What was added

- `config/defaults.py`: new `MODEL.LSTR.FRAME_GATE` block
  (`ENABLED`, `TOP_K`, `SCORE` in {`norm`,`uniform`,`learned`}, `SPARSITY_WEIGHT`).
- `models/lstr.py`: `_apply_frame_gate()` and a hook in `LSTR.forward()`. It scores
  the raw long-memory frames, keeps the top-k, and runs the feature head +
  positional encoding on only those k frames (3-stream aware, respects
  `LONG_MEMORY_USE_PE`). The learned gate adds a `Linear(d_in -> 1)` scorer and a
  soft sigmoid gate on the kept embeddings.
- `engines/base_trainers/perframe_det_trainer.py`: adds the learned-gate L1
  sparsity penalty to the loss (no-op for `norm`/`uniform`).

Only the batch `forward` path is gated (training + batch inference). The streaming
`stream_inference` path is unchanged; use `INFERENCE_MODE: 'batch'` (the default).

## EK100 facts

- Long memory is only `N = 64` frames (fps 4, 64 s, sample rate 4), so budgets are a
  fraction of 64 (keep 32 = 50 %, keep 16 = 25 %), not the ~6 % used on THUMOS.
- Metric is action mAP (`AP`); the model also has verb/noun heads (`V_N_CLASSIFIER`).

## Prerequisites (must be present on the cluster before running)

1. EK100 pre-extracted features and targets under `data/EK100/`:
   - `rgb_kinetics_bninception/`, `flow_kinetics_bninception/`
   - `target_perframe/`, `verb_perframe/`, `noun_perframe/`
   (EK100 features are publicly downloadable, unlike TVSeries.)
2. RULSTM data under `external/rulstm/RULSTM/data/ek100/`:
   - `training.csv`, `validation.csv`, and the verb/noun/action mapping files.
   - Clone RULSTM into `external/rulstm/` (TeSTra expects it there).
3. Verb/noun per-frame targets: generate with
   `tools/generate_targets_epic_kitchen.py` if not already provided.

## Run

```bash
cd ~/TeSTra && git checkout feat/frame-gate
cd ~/hpc_run/run_job   # or wherever you submit from
qsub ~/TeSTra/jobs/run_ek100_framegate.pbs
```

The job trains one baseline, then evaluates the same checkpoint with the gate off
(baseline), `norm`, and `uniform` at `TOP_K` 32 and 16.

## Learned gate (optional, needs training)

`norm`/`uniform` run on a trained baseline with no retraining. The `learned` gate
has trainable weights, so it must be trained:

```bash
python tools/train_net.py --config_file <EK100 config> --gpu 0 \
    MODEL.LSTR.FRAME_GATE.ENABLED True \
    MODEL.LSTR.FRAME_GATE.SCORE learned \
    MODEL.LSTR.FRAME_GATE.TOP_K 32 \
    MODEL.LSTR.FRAME_GATE.SPARSITY_WEIGHT 0.01
```

## Status / caveats

- This port has NOT been run end-to-end here; it needs the EK100 + RULSTM data and a
  GPU to validate. The model code passes `python -m py_compile`.
- The FLOP/latency tools from the fork are not ported; on EK100 (N=64) the headline
  question is whether the gate preserves mAP while dropping frames, which the eval
  comparison answers directly.
