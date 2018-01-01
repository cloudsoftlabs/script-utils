#!/bin/bash

SourceFile=$1;
TargetFile=$2;
compareResult=compare.txt
#i='1';
echo -e "Interface Name\t|$SourceFile-Version\t|$TargetFile-Version">$compareResult
while read line ; do
	if [[ $(echo $line | grep -F "Active" ) ]]; then	
	#echo $line;
	sourceInterface=$(echo $line| cut -nd']' -f 6,7)
	#echo "line $i : $interface";
	#echo "Interface Details : $sourceInterface";
	sourceInterfaceName=$(echo $sourceInterface| cut -nd'(' -f 1);
    #echo "Interface Name : $sourceInterfaceName";
    sourceInterfaceVersion=$(echo $sourceInterface|awk -F '[()]' '{print $2}')
    #echo -e "Version : $sourceInterfaceVersion \n";
	    if [[ $(grep -F "$sourceInterfaceName" $TargetFile) ]]; then
	    	targetInterface=$(grep -F "$sourceInterfaceName" $TargetFile);
	    	targetInterfaceVersion=$(grep -F "$sourceInterfaceName" $TargetFile|cut -nd']' -f 6,7|awk -F '[()]' '{print $2}');
	    	#echo "####### Target Version : $targetInterfaceVersion #####";
	    	if [[ $targetInterfaceVersion != $sourceInterfaceVersion ]]; then  
	    		echo -e "$sourceInterfaceName\t|$sourceInterfaceVersion\t|$targetInterfaceVersion";
	        fi
	    else
	        targetInterfaceVersion=""; 
	    	echo -e "$sourceInterfaceName\t|$sourceInterfaceVersion\t|$targetInterfaceVersion";
	    fi
    fi
    #i=$(( $i + 1 ));
done<$SourceFile>>$compareResult;
column -t -s$'\t|' $compareResult;
awk -F "|" 'BEGIN{print "<table border="1">"} {print "<tr>";for(i=1;i<=NF;i++)print "<td>" $i"</td>";print "</tr>"} END{print "</table>"}' $compareResult >> email.html
