#!/bin/sh

dir="/Library/Nessus/run/lib/nessus/plugins"
saved_dir="/nessus_diffs"

if [ ! -d $dir ]
    then echo "$dir does not exist. Find where your Nessus plugins are located and update this script"
    exit 
fi

if [ ! -d $saved_dir ]
    then echo "$saved_dir does not exist. create it"
    exit 
fi
    
cd $dir
for file in `find . -type f -print | grep .nasl`
    do old_file_path="${saved_dir}/${file}"
    if [ ! -f $old_file_path ]
        then echo "$file is a new plugin"
        cp $file $old_file_path
    else
        old_version=$(egrep "^[ ]*script_version[ ]*" $old_file_path | awk -F\" '{print $2}')
        new_version=$(egrep "^[ ]*script_version[ ]*" $file | awk -F\" '{print $2}')
        if [ "$old_version" != "$new_version" ]
            then diff=$(diff $old_file_path $file)
            echo "Warning!!! $file has changed"
            echo $diff
            echo
            echo
            rm $old_file_path
            cp $file $old_file_path
        fi
    fi
done
