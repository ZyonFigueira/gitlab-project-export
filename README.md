##### This script can either export your projects (all of them) and upload to an Azure Blob Storage. 

Simple to using, just by passing few variables and this script can download (export) each project of each group of all your Gitlab account.

### Variables
I recommend you using this variables as environment variables in linux.
- $gitlab_url = URL from Gitlab. (E.g. gitlab.com)
- $gitlab_token = Gitlab Personal Access Token (sure you are granted in projects you want to export)
- $azure_storage_url = URL from Azure Blob Storage
- $azure_storage_token = Token from Azure Blob Storage. See this link for further information [Delegate access with a shared access signature](https://docs.microsoft.com/en-us/rest/api/storageservices/delegate-access-with-shared-access-signature)
- $backup_dir = Directory to support your projects exported (E.g. /etc/backup/)

### How does it work?
This script works in a loop which can download all your projects in Gitlab, of all groups you have access to.
It was made in Shell Script so any Linux based operational system can be used.

### Uploading to bucket
This script was made to upload the Tarball projects in the Azure Blob Storage, but, feel free to change the last line (azure_upload) to upload to your particular bucket (E.g. Amazon S3).

### Contribute if you can
If you want to contribute with this code, i'll consider all pull request made by you :)

###### This script was done in pair with [joaolms](https://github.com/joaolms)

##### Regards, *ZyonFigueira*
