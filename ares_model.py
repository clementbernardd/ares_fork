import shutil
from typing import Dict, Optional, Tuple
import os
import torch_geometric
import atom3d.datasets as da
import lib.ares.ares_release.ares.data as d
import lib.ares.ares_release.ares.model as m
import pytorch_lightning as pl
import logging
import warnings
logging.getLogger('torch').setLevel(logging.ERROR)
logging.getLogger("lightning").setLevel(logging.ERROR)
warnings.filterwarnings("ignore", category=UserWarning, module="pytorch_lightning.utilities.distributed")

class ARESModel:
    def __init__(self, ares_weights: Optional[str] = None):
        self.ares_weights = ares_weights if ares_weights is not None else \
            os.path.join("lib", "ares","ares_release", "data", "weights.ckpt")

    def compute(self, pred_path: str) -> Tuple[Dict, Dict]:
        """
        Compute the ARES score for a given structure.
        :param pred_path: the path to the .pdb file of a prediction.
        """
        return round(self.predict_model(pred_path), 3)

    def _compute(self, pred_path: str) -> Tuple[Dict, Dict]:
        """
        Compute the ARES score for a given structure.
        :param pred_path: the path to the .pdb file of a prediction.
        :return: dictionary with the ARES score for the given inputs
        """
        ares_score = self.compute(pred_path)
        return {"ARES": ares_score}  # type: ignore

    def predict_model(self, pred_path: str):
        """Load the ARES model and create the dataset, trainer."""
        tmp_dir = os.path.join("tmp", "ares")
        os.makedirs(tmp_dir, exist_ok=True)
        shutil.copy(pred_path, tmp_dir)
        transform = d.create_transform(False, None, "pdb")
        dataset = da.load_dataset(tmp_dir, "pdb", transform)
        dataloader = torch_geometric.data.DataLoader(dataset, batch_size=1, num_workers=1)
        tfnn = m.ARESModel.load_from_checkpoint(self.ares_weights)
        trainer = pl.Trainer(progress_bar_refresh_rate=0, logger=False)
        out = trainer.test(tfnn, dataloader, verbose=False)
        return out[0]["test_loss"]

if __name__ == "__main__":
    pred_path = "lib/ares/ares_release/data/sample/pdbs/S_000028_476.pdb"
    ares_model = ARESModel()
    ares_score = ares_model.compute(pred_path)
    print(f"ARES SCORE: {ares_score}")