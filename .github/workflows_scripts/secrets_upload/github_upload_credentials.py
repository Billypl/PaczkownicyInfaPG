"""
upload_secrets.py

Required libraries:
    pip install requests pynacl

Usage:
- Run ../gdrive_upload/gdrive_update.py to login and generate .pickle token
- Set GITHUB_TOKEN as an environment variable (safer than hardcoding it)
  or insert it directly in the GITHUB_TOKEN variable below.
- Place credentials.json and token.json files in the same folder.
- Run: python upload_secrets.py
"""

import os
import base64
import requests
from nacl import public, encoding, exceptions

GITHUB_TOKEN = os.getenv("GITHUB_TOKEN", "YOUR_PERSONAL_ACCESS_TOKEN")
REPO_OWNER = "Billypl"
REPO_NAME = "PaczkownicyInfaPG"

# Mapping: SECRET_NAME on GitHub -> local file path
SECRETS = {
    "GDRIVE_CREDENTIALS_B64": "../gdrive_upload/credentials.json",
    "GDRIVE_TOKEN_B64": "../gdrive_upload/token_drive_v3.pickle"
}


def file_to_base64(path: str) -> str:
    """Encode a binary file to base64 and return UTF-8 string."""
    with open(path, "rb") as f:
        data = f.read()
    return base64.b64encode(data).decode("utf-8")


def get_public_key() -> dict:
    """
    Fetches the repository's public key (GitHub Actions public key).
    Returns JSON containing 'key' (base64) and 'key_id'.
    """
    url = f"https://api.github.com/repos/{REPO_OWNER}/{REPO_NAME}/actions/secrets/public-key"
    headers = {"Authorization": f"token {GITHUB_TOKEN}", "Accept": "application/vnd.github+json"}
    r = requests.get(url, headers=headers)
    r.raise_for_status()
    return r.json()


def encrypt_secret(public_key_b64: str, secret_value: str) -> str:
    """
    Encrypts the secret using GitHub's public key (libsodium / NaCl SealedBox).
    Returns a base64 encoded encrypted value.
    """
    try:
        public_key_bytes = base64.b64decode(public_key_b64)
        pk = public.PublicKey(public_key_bytes)
        sealed_box = public.SealedBox(pk)
        encrypted = sealed_box.encrypt(secret_value.encode("utf-8"))
        return base64.b64encode(encrypted).decode("utf-8")
    except (TypeError, exceptions.CryptoError) as e:
        raise RuntimeError("Error encrypting secret") from e


def upload_secret(secret_name: str, encrypted_value: str, key_id: str):
    """
    Sends the encrypted secret to GitHub Actions (PUT request).
    """
    url = f"https://api.github.com/repos/{REPO_OWNER}/{REPO_NAME}/actions/secrets/{secret_name}"
    headers = {"Authorization": f"token {GITHUB_TOKEN}", "Accept": "application/vnd.github+json"}
    payload = {"encrypted_value": encrypted_value, "key_id": key_id}
    r = requests.put(url, headers=headers, json=payload)
    r.raise_for_status()
    print(f"✅ Secret '{secret_name}' updated.")


def main():
    if not GITHUB_TOKEN or GITHUB_TOKEN == "YOUR_PERSONAL_ACCESS_TOKEN":
        print("Warning: GITHUB_TOKEN not provided. Set the GITHUB_TOKEN environment variable or insert the token in the script.")
        return

    public_key_data = get_public_key()
    public_key = public_key_data["key"]
    key_id = public_key_data["key_id"]

    for secret_name, file_path in SECRETS.items():
        if not os.path.isfile(file_path):
            print(f"⚠️ File does not exist: {file_path} — skipping secret {secret_name}.")
            continue

        b64_content = file_to_base64(file_path)
        # encrypt (SealedBox)
        encrypted_value = encrypt_secret(public_key, b64_content)
        upload_secret(secret_name, encrypted_value, key_id)


if __name__ == "__main__":
    main()
