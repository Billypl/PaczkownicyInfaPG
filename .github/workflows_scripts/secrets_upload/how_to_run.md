# Upload new secrects 

- Generate credentials file at https://console.cloud.google.com/apis/credentials
- Rename generated file to credentials.json and place it in ../gdrive_upload/
- Run ../gdrive_upload/gdrive_update.py to login and generate *.pickle token
- Generate PAT at https://github.com/settings/tokens and set GITHUB_TOKEN as an environment variable `export GITHUB_TOKEN=""`
- Run: python upload_secrets.py

```sh
cd .github/workflows_scripts/secrets_upload/
export GITHUB_TOKEN="PASTE_IN_TOKEN"
python3 -m venv .venv
source .venv/bin/activate
pip install requests pynacl
python3 github_upload_credentials.py
```