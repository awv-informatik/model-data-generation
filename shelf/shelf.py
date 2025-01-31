import csv
import os
import pathlib
import shutil

import requests

api = "http://127.0.0.1:9094/api"
dir = os.path.dirname(__file__)
csvpath = dir + "/shelf.csv"
outDir = os.path.abspath(dir + "/../.out/shelf")
if os.path.exists(outDir) and os.path.isdir(outDir):
    shutil.rmtree(outDir)
pathlib.Path.mkdir(outDir, parents=True, exist_ok=True)
session = requests.Session()

with open(csvpath, newline="") as csvfile:
    reader = csv.DictReader(csvfile, delimiter=",")
    for row in reader:
        if len(row) > 1:
            name = row["length"] + "-" + row["depth"]

            # Run ccscript
            file = dir + "/shelf.ccscript"
            url = f"{api}/v1/script/run?file={file}&length={row["length"]}&depth={row["depth"]}&ft={row["ft"]}"
            try:
                req = session.post(url)
            except:
                print("An exception has occurred!")
                continue

            # Save ofb
            file = f"{outDir}/{name}.ofb"
            url = f"{api}/v1/basemodeler/save?file={file}&format=ofb"
            try:
                req = session.post(url)
            except:
                print("An exception has occurred!")
                continue

            # Save iwp
            file = f"{outDir}/{name}.iwp"
            iwp = '{"binary": 1 }'
            url = f"{api}/v1/basemodeler/save?file={file}&format=iwp&iwp={iwp}"
            try:
                req = session.post(url)
            except:
                print("An exception has occurred!")
                continue
