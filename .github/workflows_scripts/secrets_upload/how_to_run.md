# Upload new secrects 

- Place generated from Google Cloud Console credentials.json file in ../gdrive_upload/
- Run ../gdrive_upload/gdrive_update.py to login and generate *.pickle token
- Generate PAT at https://github.com/settings/tokens and set GITHUB_TOKEN as an environment variable `export GITHUB_TOKEN=""`
- Run: python upload_secrets.py

```sh
python3 -m venv .venv
source .venv/bin/activate
pip install requests pynacl
python3 github_upload_credentials.py
```