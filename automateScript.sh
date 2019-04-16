#!/bin/bash

function main(){
	echo "Running on `date`";

	userFile=AWC19perUser.json;
	entriesFile=AWC19perEntries.json;

	mkdir diff_material 2> /dev/null || echo 'Folder already existed';


	# Backupping to check evolution
	cp "${userFile}" "diff_material/${userFile}";
	cp "${entriesFile}" "diff_material/${entriesFile}";

	echo "$(node retrieveAWC19Data.js "${userFile}" "${entriesFile}")"



	hasGrown "${userFile}"
	if [ 0 -eq $? ]; then 
		needUpdate=0;
		 echo "Adding ${userFile}"
		git add "${userFile}"
	fi

	hasGrown "${entriesFile}"
	if [ 0 -eq $? ]; then 
		needUpdate=0;
		 echo "Adding ${entriesFile}"
		git add "${entriesFile}"
	fi

	if [ 0 -eq $needUpdate ]; then 
		 echo "Commiting changes"
		git commit -m "Automated update `date`";
		git push;
	else
		 echo "No update needed"
	fi

}

function hasGrown(){
	oldSize=`wc -c "diff_material/${1}" | cut -d' ' -f1`;
	newSize=`wc -c "${1}" | cut -d' ' -f1`;
	[ $oldSize -lt $newSize ] && return 0 || return 1;
}


needUpdate=1;

main >> scrap.log;

if [ 0 -eq $needUpdate ]; then 
	git add scrap.log
	git commit -m "Updated logs"
	git push
fi

