#!/bin/bash

if [ $# -eq 0 ]; then
        echo "Usage: ./backup_script path/to/source path/to/backup"
fi

source_dir=$1
timestamp=$(date '+%Y-%m-%d-%H-%M-%S')
backup_dir=$2


function create_backup {
        zip -r "${backup_dir}/backup_${timestamp}.zip" "${source_dir}" > /dev/null

        if [ $? -eq 0 ]; then
                echo "Backup generated successfully as: backup_${timestamp}.zip"
        fi
}


function rotation {
        backups=($(ls -t "${backup_dir}/backup_"*.zip 2>/dev/null))
        echo "${backups[@]}"

        if [ "${#backups[@]}" -gt 5 ];  then
                echo "Rotating..."

                backups_to_remove=("${backups[@]:5}")

                for backup in "${backups_to_remove[@]}";
                do
                        rm -f ${backup}
                done
        fi
}

create_backup
rotation

ls -l ${backup_dir}
