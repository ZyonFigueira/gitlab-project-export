#!/bin/bash 
#There are some environment variables that should be set before running:
#gitlab_url:"gitlab.com"
#gitlab_token="your personal access token from gitlab"
#azure_storage_url="azure blob storage URL"
#azure_storage_token="azure blob storage token"
#backup_dir="a directory to store your project exports"
#You can also look README.md file for further information about variables and scripting explanation.

mkdir -p $backup_dir
for group in $(curl -s --header "PRIVATE-TOKEN: $gitlab_token" "https:///$gitlab_url/api/v4/groups/" | jq '.[] | .id'); do
  for project in $(curl -s --header "PRIVATE-TOKEN: $gitlab_token" https://$gitlab_url/api/v4/groups/"${group}"/?simple=true | jq '.projects[] | .id'); do
    response=$(curl --request POST --header "PRIVATE-TOKEN: $gitlab_token" "https://$gitlab_url/api/v4/projects/$project/export")
    
    if [ "${response}" == '{"message":"202 Accepted"}' ] ; then
      status=$(curl -s --header "PRIVATE-TOKEN: $gitlab_token" "https://$gitlab_url/api/v4/projects/$project/export" | jq .export_status)
      
      while [ "$status" != '"finished"' ] ; do
        sleep 30
        status=$(curl -s --header "PRIVATE-TOKEN: $gitlab_token" "https://$gitlab_url/api/v4/projects/$project/export" | jq .export_status)
      done

    curl -s --header "PRIVATE-TOKEN: $gitlab_token" --output $backup_dir/$(date "+%F")_$project.tar.gz --remote-name "https://$gitlab_url/api/v4/projects/$project/export/download"

  else
    exit 1
  fi
  done
done
tar -cvzf $backup_dir.tar.gz $backup_dir
azure_upload=$(curl -X PUT -T $backup_dir.tar.gz -H "x-ms-date: $(date -u)" -H "x-ms-blob-type: BlockBlob" -w '%{http_code}' "$azure_storage_url/$(date "+%F")_backup.tar.gz$azure_token")
[ "$azure_upload" == "201" ] || (echo "ERROR! HTTP CODE: $azure_response. EXITING SCRIPT && exit 1")
