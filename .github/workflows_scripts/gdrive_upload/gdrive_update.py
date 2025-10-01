import os
import time
from gdrive_auth import Create_Service
from gdrive_utility import (
    get_existing_files_recursive,
    upload_file_or_folder,
    delete_items_not_in_local
)

OAUTH2_SECRET = 'credentials.json'
SCOPES = ['https://www.googleapis.com/auth/drive']
API_TYPE = 'drive'
API_VERSION = 'v3'

LOCAL_FOLDER = os.getenv("LOCAL_FOLDER", "../../../paczka")
GDRIVE_FOLDER_ID = '1AMJFl1pLO3EPuq6jlE4fCtxg1V4kvshv'

def main():
    if not os.path.isdir(LOCAL_FOLDER):
        print(f"Folder '{LOCAL_FOLDER}' not found.")
        return

    drive_service = Create_Service(OAUTH2_SECRET, API_TYPE, API_VERSION, SCOPES)

    # Fetch files from Google Drive
    print("📝 Fetching existing files from Google Drive...")
    start = time.perf_counter()
    existing_files = get_existing_files_recursive(GDRIVE_FOLDER_ID, drive_service)
    end = time.perf_counter()
    print(f"Finished fetching files: {end - start:.4f} seconds")

    # Upload or update local files to Google Drive
    print("⬆️ Uploading local files...")
    start = time.perf_counter()
    upload_file_or_folder(
        local_base_path=LOCAL_FOLDER,
        parent_drive_folder_id=GDRIVE_FOLDER_ID,
        drive_service=drive_service,
        existing_items=existing_files
    )
    end = time.perf_counter()
    print(f"Finished uploading files: {end - start:.4f} seconds")


    # Delete files/folders not present locally
    print("🧹 Deleting non-existent files/folders from Google Drive...")
    start = time.perf_counter()
    delete_items_not_in_local(
        local_base_path=LOCAL_FOLDER,
        parent_drive_folder_id=GDRIVE_FOLDER_ID,
        drive_service=drive_service,
        existing_items=existing_files
    )
    end = time.perf_counter()
    print(f"Finished deleting non-existent items: {end - start:.4f} seconds")

if __name__ == '__main__':
    main()
