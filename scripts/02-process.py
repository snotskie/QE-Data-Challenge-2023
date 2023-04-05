#!/usr/bin/env python3

from pandas import read_csv, to_datetime
from warnings import filterwarnings
filterwarnings("ignore", 'This pattern is interpreted as a regular expression, and has match groups')

# Load
data = read_csv("data/raw/data.csv")

# Preprocess
data["All"] = "All"
data["DateInt"] = to_datetime(data["Date"]).astype(int) // 100000000000
data["DateFloat"] = (data["DateInt"] - min(data["DateInt"])) / (max(data["DateInt"]) - min(data["DateInt"]))
n_epochs = 10
data["EpochInt"] = ((data["DateFloat"] * n_epochs**2) // n_epochs).astype(int)

# Done!
data.to_csv("data/processed/data.csv", index=False)
print("Done!")