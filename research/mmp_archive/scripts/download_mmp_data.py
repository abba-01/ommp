
#!/usr/bin/env python3
"""
download_mmp_data.py

Downloads the public‑domain ODNI 2021 UAP report PDF and a cleaned NUFORC sightings CSV,
then packages them (plus SHA‑256 checksums) into mmp_data_bundle.zip.

Dependencies: requests (pip install requests)

Usage:
    python download_mmp_data.py
"""
import requests, hashlib, shutil, zipfile, pathlib, tempfile, os, sys, textwrap

FILES = {
    "ODNI_UAP_2021.pdf":
        "https://www.dni.gov/files/ODNI/documents/assessments/Prelimary-Assessment-UAP-20210625.pdf",
    "NUFORC_latest.csv":
        "https://raw.githubusercontent.com/timothyrenner/nuforc_sightings_data/master/NUFORC_latest.csv"
}

def sha256(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            h.update(chunk)
    return h.hexdigest()

def download(url, dest):
    print(f"Downloading {url} ...")
    r = requests.get(url, stream=True, timeout=60)
    r.raise_for_status()
    with open(dest, "wb") as out:
        for chunk in r.iter_content(chunk_size=8192):
            if chunk:
                out.write(chunk)

def main():
    work = pathlib.Path(tempfile.mkdtemp(prefix="mmp_dl_"))
    print("Working directory:", work)
    checksums = {}
    for fname, url in FILES.items():
        path = work / fname
        download(url, path)
        checksums[fname] = sha256(path)
        print(f"Saved {fname}  ({checksums[fname][:12]}...)")
    # write checksum file
    cfile = work / "CHECKSUMS.sha256"
    with open(cfile, "w") as f:
        for k, v in checksums.items():
            f.write(f"{v}  {k}\n")
    # zip
    zip_path = pathlib.Path.cwd() / "mmp_data_bundle.zip"
    with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED) as z:
        for item in list(FILES.keys()) + ["CHECKSUMS.sha256"]:
            z.write(work / item, arcname=item)
    print("Created archive:", zip_path)
    shutil.rmtree(work)

if __name__ == "__main__":
    main()
