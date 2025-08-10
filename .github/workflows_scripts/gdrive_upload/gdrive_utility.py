import os
import pathlib
import hashlib
from googleapiclient.errors import HttpError
from googleapiclient.http import MediaFileUpload


def file_md5(path):
    with open(path, "rb") as f:
        return hashlib.md5(f.read()).hexdigest()

def get_existing_files_recursive(folder_id, service):
    query = f"'{folder_id}' in parents and trashed=false"
    files = {}
    folders = {}

    def recurse(current_id, path_prefix):
        results = service.files().list(q=f"'{current_id}' in parents and trashed=false",
                                       fields="files(id, name, mimeType)").execute()
        for item in results['files']:
            full_path = os.path.join(path_prefix, item['name'])
            if item['mimeType'] == 'application/vnd.google-apps.folder':
                folders[full_path] = item['id']
                recurse(item['id'], full_path)
            else:
                files[full_path] = item['id']

    recurse(folder_id, "")
    return {"files": files, "folders": folders}

def ensure_folder(path, parent_id, drive_service, existing_items):
    folders = existing_items["folders"]
    if path in folders:
        return folders[path]

    folder_name = os.path.basename(path)
    parent_path = os.path.dirname(path)
    if parent_path != "":
        parent_folder_id = ensure_folder(parent_path, parent_id, drive_service, existing_items)
    else:
        parent_folder_id = parent_id

    file_metadata = {
        "name": folder_name,
        "mimeType": "application/vnd.google-apps.folder",
        "parents": [parent_folder_id]
    }
    folder = drive_service.files().create(body=file_metadata, fields="id").execute()
    folders[path] = folder["id"]
    print(f"✅ Added folder: {path}")
    return folder["id"] 

def upload_file_or_folder(local_base_path, parent_drive_folder_id, drive_service, existing_items):
    for local_path in pathlib.Path(local_base_path).rglob("*"):
        relative_path = str(local_path.relative_to(local_base_path))

        if local_path.is_dir():
            ensure_folder(relative_path, parent_drive_folder_id, drive_service, existing_items)

        elif local_path.is_file():
            
            parent_path = os.path.dirname(relative_path)
            if parent_path == "":
                parent_id = parent_drive_folder_id
            else:
                parent_id = ensure_folder(parent_path, parent_drive_folder_id, drive_service, existing_items)

            # check for updates
            file_id = existing_items["files"].get(relative_path)
            if file_id:
                drive_file = drive_service.files().get(fileId=file_id, fields="md5Checksum").execute()
                local_md5 = file_md5(local_path)
                if drive_file.get("md5Checksum") == local_md5:
                    continue
                else:
                    media = MediaFileUpload(str(local_path), resumable=True)
                    drive_service.files().update(fileId=file_id, media_body=media).execute()
                    print(f"🔁 Updated file: {relative_path}")
                    continue

            # upload new file
            file_metadata = {
                "name": os.path.basename(local_path),
                "parents": [parent_id]
            }
            media = MediaFileUpload(str(local_path))
            file = drive_service.files().create(
                body=file_metadata,
                media_body=media,
                fields="id"
            ).execute()
            existing_items["files"][relative_path] = file["id"]
            print(f"✅ Added file: {relative_path}")


def delete_items_not_in_local(local_base_path, parent_drive_folder_id, drive_service, existing_items):
    local_files = set()
    local_folders = set()

    for path in pathlib.Path(local_base_path).rglob("*"):
        rel = str(path.relative_to(local_base_path))
        if path.is_file():
            local_files.add(rel)
        elif path.is_dir():
            local_folders.add(rel)

    for remote_path, file_id in existing_items["files"].items():
        if remote_path not in local_files:
            try:
                drive_service.files().delete(fileId=file_id).execute()
                print(f"❌ Removed file: {remote_path}")
            except HttpError as e:
                print(f"Error when removing {remote_path}: {e}")

    # Usuń foldery od najgłębszego
    for remote_path in sorted(existing_items["folders"].keys(), key=lambda x: -x.count("/")):
        if remote_path not in local_folders:
            try:
                drive_service.files().delete(fileId=existing_items["folders"][remote_path]).execute()
                print(f"❌ Removed directory: {remote_path}")
            except HttpError as e:
                print(f"Error when removing directory {remote_path}: {e}")
