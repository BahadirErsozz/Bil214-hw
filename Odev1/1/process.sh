#! /usr/bin/bash


################### 
#README:
# Ödev metninde her şey açık olmadığı için yaptıklarımı özetlemek istiyorum
# Optionları alıyorum eğer optionlarda eksiklik varsa hata verip çıkıyor programdan
# Dosyalardaki verileri okuyup sort ediyorum sonra out dosyasına yazdırıyorum
#
###################


while getopts ":s:i:o:" options; do        
                                        
                                          
  case "${options}" in                     
    s)       
      SORTBY=${OPTARG}
      ;;                    
    i)
      INPFILES=${OPTARG}
      ;;
    o)
      OUTFILE=${OPTARG}
      ;;  
  esac
done
if [ -z "$SORTBY" ] || [ -z "$INPFILES" ] || [ -z "$OUTFILE" ]; then
	echo "Missing arguments"
	exit
fi
i=0
fileCounter=0
data=()
for f in $INPFILES; do
	
	
	while IFS="," read -r Cite asd
	do

		Cites[$fileCounter]=$Cite
		IFS=',' read -r -a asd <<< "$asd"
		
		adding=1
		
		while [ $adding != "0" ] 
		do	
			if [ i = 0 ]; then
				Author="${asd[i]}"
				echo "mal"
			fi 
			if [ i != 0 ]; then 
			Author="$Author ${asd[i]}"
			fi
		
				
			
			
			pat=".[\"]"
			if [[ "${asd[i]}" =~ .[\"] ]]; then
				adding="0"
			fi
			i=`expr $i + 1`
		done
	
	Authors[$fileCounter]=$Author
	Author=""
	Titles[$fileCounter]=${asd[i]}
	
	Years[$fileCounter]=${asd[i+1]}
	Dates[$fileCounter]="${Years[$fileCounter]}0101"
	
	Sources[$fileCounter]=${asd[i+2]}
	Publishers[$fileCounter]=${asd[i+3]}
	ArticleURLs[$fileCounter]=${asd[i+4]}
	CitesURLs[$fileCounter]=${asd[i+5]}
	GSRanks[$fileCounter]=${asd[i+6]}
	
	QueryDates[$fileCounter]=${asd[i+7]}
	IFS=" " read -r -a abq <<< ${asd[i+7]}
	temp="${abq[0]%\"}"
	abq[0]="${temp#\"}"
	IFS="-" read -r -a abq <<< ${abq[0]}
	QueryDatesChanged[$fileCounter]="${abq[0]}${abq[1]}${abq[2]}"
	
	Types[$fileCounter]=${asd[i+8]}
	DOIs[$fileCounter]=${asd[i+9]}
	ISSNs[$fileCounter]=${asd[i+10]}
	CitationURLs[$fileCounter]=${asd[i+11]}
	Volumes[$fileCounter]=${asd[i+12]}
	Issues[$fileCounter]=${asd[i+13]}
	StartPages[$fileCounter]=${asd[i+14]}
	EndPages[$fileCounter]=${asd[i+15]}
	
	ECCs[$fileCounter]=${Cites[$fileCounter]}
	
	let DIFF=(`date +%s -d "${QueryDatesChanged[$fileCounter]}"`-`date +%s -d "${Dates[$fileCounter]}"`)/86400
	Ages[$fileCounter]=$DIFF
	
	AuthorCounts[$fileCounter]=$i
	CitesPerYears[$fileCounter]=$(bc <<< "scale=2;${Cites[$fileCounter]}/${Ages[$fileCounter]}")
	CitesPerAuthors[$fileCounter]=$(bc <<< "scale=2;${Cites[$fileCounter]}/$i")
	
	Abstracts[$fileCounter]=${asd[i+21]}
	FullTextURLs[$fileCounter]=${asd[i+22]}
	RelatedURLs[$fileCounter]=${asd[i+23]}
		
	
	i=0	
 	fileCounter=`expr $fileCounter + 1`
	done < <(tail -n +2 $f)
done

sorted=0
asd="0"
sortList=()
equals=()
for s in $SORTBY; do
	if [ $s == "ECC" ] || [ $s == "CitesPerYear" ] || [ $s == "CitesPerAuthor" ] || [ $s == "AuthorCount" ] || [ $s == "Age" ]; then
		echo "Wrong sort arguments"
		exit
	fi
	
	if [ $sorted == 0 ]; then
		if [ $s == "Year" ]; then
		
		
			YearsSorted=( $( printf "%s\n" "${Years[@]}" | sort -n ) )
			if [ $YearsSorted != $Years ] && [ $asd = "0" ]; then
				sorted=1
				asd="1"
			
				for k in "${!YearsSorted[@]}"; do
					for j in "${!Years[@]}"; do 
					
 				  	if [[ "${YearsSorted[$k]}" = "${Years[$j]}" ]]; then
 				  	
 				  		if [[ " ${sortList[@]} " =~ " ${j} " ]]; then
 				  		sorted=0
 						if [[ ! " ${equals[@]} " =~ " ${k} " ]]; then
 						equals+=($k)
 						fi
 						
 				  		else
 				      		sortList[$k]=$j
 				      		
 				   
 				      		YearsSorted[$k]=999999999999
 				      		
 				      		fi
 				  	fi
 				  	
 				  	done
 				  	
				done
				
			else
			for a in "${equals[@]}"; do
			
				
				b=${sortList[$a]}
				
				if [[ ${Years[$b]} < ${Years[$b-1]} ]] ; then
					temp=${sortList[$a]}
					sortList[$a]=${sortList[a-1]}
					sortList[$a-1]=$temp 
				fi
				
				
			done
			fi
		fi
		if [ $s == "Cites" ]; then
			
			CitesSorted=( $( printf "%s\n" "${Cites[@]}" | sort -n ) )
			if [ $CitesSorted != $Cites ] && [ $asd = "0" ]; then
				sorted=1
				asd="1"
				for k in "${!CitesSorted[@]}"; do
					for j in "${!Cites[@]}"; do 
 				  	if [[ "${CitesSorted[$k]}" = "${Cites[$j]}" ]]; then
 				  		if [[ " ${sortList[@]} " =~ " ${j} " ]]; then						
 				  		
 				  		sorted=0
 				  		if [[ ! " ${equals[@]} " =~ " ${j} " ]]; then
 						equals+=($k)
 					
 						fi
 				  		else
 				  		
 				  		
 				      		sortList[$k]=$j
 				     
 				      
 				  		CitesSorted[$k]=9999999999
 				  		fi
 				  	fi
 				  done
				done
				
			else
			for a in "${equals[@]}"; do
			
				
				
				b=${sortList[$a]}
				
				if [[ ${Cites[$b]} < ${Cites[$b-1]} ]]; then
					temp=${sortList[$a]}
					sortList[$a]=${sortList[a-1]}
					sortList[$a-1]=$temp 
				fi
				
				
			done
			fi
		fi
		
		
		
		
		if [ $s == "Title" ]; then
		
			IFS=$'\n' TitlesSorted=($(sort <<<"${Titles[*]}"))
	
			
			if [ $TitlesSorted != $Titles ] && [ $asd = "0" ]; then
				sorted=1
				asd="1"
			
				for k in "${!TitlesSorted[@]}"; do
					for j in "${!Titles[@]}"; do 
					
 				  	if [[ "${TitlesSorted[$k]}" = "${Titles[$j]}" ]]; then
 				  		if [[ " ${sortList[@]} " =~ " ${j} " ]]; then						
 				  		
 				  		sorted=0
 				  		if [[ ! " ${equals[@]} " =~ " ${j} " ]]; then
 						equals+=($k)
 					
 						fi
 				  		else
 				  		
 				  		
 				      		sortList[$k]=$j
 				     
 				     
 				  		TitlesSorted[$k]=9999999999
 				  		fi
 				  	fi
 				  	done
 				  	
				done
			else
			for a in "${equals[@]}"; do
		
				
				
				b=${sortList[$a]}
				
				if [[ ${Titles[$b]} < ${Titles[$b-1]} ]]; then
					temp=${sortList[$a]}
					sortList[$a]=${sortList[a-1]}
					sortList[$a-1]=$temp 
				fi
				
				
			done		
			fi
			
		fi
		
		
		
		if [ $s == "Authors" ]; then
	
			IFS=$'\n' AuthorsSorted=($(sort <<<"${Authors[*]}"))
	
			
			if [ $AuthorsSorted != $Authors ] && [ $asd = "0" ]; then
				sorted=1
				asd="1"
				
				for k in "${!AuthorsSorted[@]}"; do
					for j in "${!Authors[@]}"; do 
					
 				  	if [[ "${AuthorsSorted[$k]}" = "${Authors[$j]}" ]]; then
 				  		if [[ " ${sortList[@]} " =~ " ${j} " ]]; then						
 				  		
 				  		sorted=0
 				  		if [[ ! " ${equals[@]} " =~ " ${j} " ]]; then
 						equals+=($k)
 					
 						fi
 				  		else
 				  		
 				  		
 				      		sortList[$k]=$j
 				     
 				      	
 				  		AuthorsSorted[$k]=9999999999
 				  		fi
 				  	fi
 				  	done
 				  	
				done
			else
			for a in "${equals[@]}"; do
			
				
				
				b=${sortList[$a]}
				
				if [[ ${Authors[$b]} < ${Authors[$b-1]} ]]; then
					temp=${sortList[$a]}
					sortList[$a]=${sortList[a-1]}
					sortList[$a-1]=$temp 
				fi
				
				
			done		
			fi
			
		fi
		
		
		
		if [ $s == "Source" ]; then
			
			IFS=$'\n' SourcesSorted=($(sort <<<"${Sources[*]}"))
			
			
			if [ $SourcesSorted != $Sources ] && [ $asd = "0" ]; then
				sorted=1
				asd="1"
		
				for k in "${!SourcesSorted[@]}"; do
					for j in "${!Sources[@]}"; do 
					
 				  	if [[ "${SourcesSorted[$k]}" = "${Sources[$j]}" ]]; then
 				  		if [[ " ${sortList[@]} " =~ " ${j} " ]]; then						
 				  		
 				  		sorted=0
 				  		if [[ ! " ${equals[@]} " =~ " ${j} " ]]; then
 						equals+=($k)
 					
 						fi
 				  		else
 				  		
 				  		
 				      		sortList[$k]=$j
 				     
 				      	
 				  		SourcesSorted[$k]=9999999999
 				  		fi
 				  	fi
 				  	done
 				  	
				done
			else
			for a in "${equals[@]}"; do
			
				
				b=${sortList[$a]}
				
				if [[ ${Sources[$b]} < ${Sources[$b-1]} ]]; then
					temp=${sortList[$a]}
					sortList[$a]=${sortList[a-1]}
					sortList[$a-1]=$temp 
				fi
				
				
			done		
			fi
			
		fi
		
		
		
		if [ $s == "Publisher" ]; then
			
			IFS=$'\n' PublishersSorted=($(sort <<<"${Publishers[*]}"))
	
			
			if [ $PublishersSorted != $Publishers ] && [ $asd = "0" ]; then
				sorted=1
				asd="1"
			
				for k in "${!PublishersSorted[@]}"; do
					for j in "${!Publishers[@]}"; do 
					
 				  	if [[ "${PublishersSorted[$k]}" = "${Publishers[$j]}" ]]; then
 				  		if [[ " ${sortList[@]} " =~ " ${j} " ]]; then						
 				  		
 				  		sorted=0
 				  		if [[ ! " ${equals[@]} " =~ " ${j} " ]]; then
 						equals+=($k)
 					
 						fi
 				  		else
 				  		
 				  		
 				      		sortList[$k]=$j
 				     
 				      	
 				  		PublishersSorted[$k]=9999999999
 				  		fi
 				  	fi
 				  	done
 				  	
				done
			else
			for a in "${equals[@]}"; do
			
				
				
				b=${sortList[$a]}
				
				if [[ ${Publishers[$b]} < ${Publishers[$b-1]} ]]; then
					temp=${sortList[$a]}
					sortList[$a]=${sortList[a-1]}
					sortList[$a-1]=$temp 
				fi
				
				
			done		
			fi
			
		fi
		
		
		
		if [ $s == "ArticleURL" ]; then
		
			IFS=$'\n' ArticleURLsSorted=($(sort <<<"${ArticleURLs[*]}"))
	
			
			if [ $ArticleURLsSorted != $ArticleURLs ] && [ $asd = "0" ]; then
				sorted=1
				asd="1"
				
				for k in "${!ArticleURLsSorted[@]}"; do
					for j in "${!ArticleURLs[@]}"; do 
					
 				  	if [[ "${ArticleURLsSorted[$k]}" = "${ArticleURLs[$j]}" ]]; then
 				  		if [[ " ${sortList[@]} " =~ " ${j} " ]]; then						
 				  		
 				  		sorted=0
 				  		if [[ ! " ${equals[@]} " =~ " ${j} " ]]; then
 						equals+=($k)
 					
 						fi
 				  		else
 				  		
 				  		
 				      		sortList[$k]=$j
 				     
 				      	
 				  		ArticleURLsSorted[$k]=9999999999
 				  		fi
 				  	fi
 				  	done
 				  	
				done
			else
			for a in "${equals[@]}"; do
			
				
				
				b=${sortList[$a]}
				
				if [[ ${ArticleURLs[$b]} < ${ArticleURLs[$b-1]} ]]; then
					temp=${sortList[$a]}
					sortList[$a]=${sortList[a-1]}
					sortList[$a-1]=$temp 
				fi
				
				
			done		
			fi
			
		fi
		
		
		
		if [ $s == "CitesURL" ]; then
		
			IFS=$'\n' CitesURLsSorted=($(sort <<<"${CitesURLs[*]}"))
		
			
			if [ $CitesURLsSorted != $CitesURLs ] && [ $asd = "0" ]; then
				sorted=1
				asd="1"
			
				for k in "${!CitesURLsSorted[@]}"; do
					for j in "${!CitesURLs[@]}"; do 
					
 				  	if [[ "${CitesURLsSorted[$k]}" = "${CitesURLs[$j]}" ]]; then
 				  		if [[ " ${sortList[@]} " =~ " ${j} " ]]; then						
 				  		
 				  		sorted=0
 				  		if [[ ! " ${equals[@]} " =~ " ${j} " ]]; then
 						equals+=($k)
 						
 						fi
 				  		else
 				  		
 				  		
 				      		sortList[$k]=$j
 				     
 				      	
 				  		CitesURLsSorted[$k]=9999999999
 				  		fi
 				  	fi
 				  	done
 				  	
				done
			else
			for a in "${equals[@]}"; do
			
				
				
				b=${sortList[$a]}
				
				if [[ ${CitesURLs[$b]} < ${CitesURLs[$b-1]} ]]; then
					temp=${sortList[$a]}
					sortList[$a]=${sortList[a-1]}
					sortList[$a-1]=$temp 
				fi
				
				
			done		
			fi
			
		fi
		
		
		
		if [ $s == "GSRank" ]; then
			
			GSRanksSorted=( $( printf "%s\n" "${GSRanks[@]}" | sort -n ) )
			if [ $GSRanksSorted != $GSRanks ] && [ $asd = "0" ]; then
				sorted=1
				asd="1"
				for k in "${!GSRanksSorted[@]}"; do
					for j in "${!GSRanks[@]}"; do 
 				  	if [[ "${GSRanksSorted[$k]}" = "${GSRanks[$j]}" ]]; then
 				  		if [[ " ${sortList[@]} " =~ " ${j} " ]]; then						
 				  		
 				  		sorted=0
 				  		if [[ ! " ${equals[@]} " =~ " ${j} " ]]; then
 						equals+=($k)
 					
 						fi
 				  		else
 				  		
 				  		
 				      		sortList[$k]=$j
 				     
 				    
 				  		GSRanksSorted[$k]=9999999999
 				  		fi
 				  	fi
 				  done
				done
				
			else
			for a in "${equals[@]}"; do
			
				
				
				b=${sortList[$a]}
				
				if [[ ${GSRanks[$b]} < ${GSRanks[$b-1]} ]]; then
					temp=${sortList[$a]}
					sortList[$a]=${sortList[a-1]}
					sortList[$a-1]=$temp 
				fi
				
				
			done
			fi
		fi
		
		
		
		
		if [ $s == "Type" ]; then
		
			IFS=$'\n' TypesSorted=($(sort <<<"${Types[*]}"))
			
			
			if [ $TypesSorted != $Types ] && [ $asd = "0" ]; then
				sorted=1
				asd="1"
			
				for k in "${!TypesSorted[@]}"; do
					for j in "${!Types[@]}"; do 
					
 				  	if [[ "${TypesSorted[$k]}" = "${Types[$j]}" ]]; then
 				  		if [[ " ${sortList[@]} " =~ " ${j} " ]]; then						
 				  		
 				  		sorted=0
 				  		if [[ ! " ${equals[@]} " =~ " ${j} " ]]; then
 						equals+=($k)
 					
 						fi
 				  		else
 				  		
 				  		
 				      		sortList[$k]=$j
 				     
 				      	
 				  		TypesSorted[$k]=9999999999
 				  		fi
 				  	fi
 				  	done
 				  	
				done
			else
			for a in "${equals[@]}"; do
		
				
				
				b=${sortList[$a]}
				
				if [[ ${Types[$b]} < ${Types[$b-1]} ]]; then
					temp=${sortList[$a]}
					sortList[$a]=${sortList[a-1]}
					sortList[$a-1]=$temp 
				fi
				
				
			done		
			fi
			
		fi
		
		
		
		
		if [ $s == "DOI" ]; then
	
			IFS=$'\n' DOIsSorted=($(sort <<<"${DOIs[*]}"))
		
			
			if [ $DOIsSorted != $DOIs ] && [ $asd = "0" ]; then
				sorted=1
				asd="1"
			
				for k in "${!DOIsSorted[@]}"; do
					for j in "${!DOIs[@]}"; do 
					
 				  	if [[ "${DOIsSorted[$k]}" = "${DOIs[$j]}" ]]; then
 				  		if [[ " ${sortList[@]} " =~ " ${j} " ]]; then						
 				  		
 				  		sorted=0
 				  		if [[ ! " ${equals[@]} " =~ " ${j} " ]]; then
 						equals+=($k)
 					
 						fi
 				  		else
 				  		
 				  		
 				      		sortList[$k]=$j
 				     
 				      	
 				  		DOIsSorted[$k]=9999999999
 				  		fi
 				  	fi
 				  	done
 				  	
				done
			else
			for a in "${equals[@]}"; do
			
				
				
				b=${sortList[$a]}
				
				if [[ ${DOIs[$b]} < ${DOIs[$b-1]} ]]; then
					temp=${sortList[$a]}
					sortList[$a]=${sortList[a-1]}
					sortList[$a-1]=$temp 
				fi
				
				
			done		
			fi
			
		fi
		
		
		
		
		if [ $s == "ISSN" ]; then
		
			IFS=$'\n' ISSNsSorted=($(sort <<<"${ISSNs[*]}"))
		
			
			if [ $ISSNsSorted != $ISSNs ] && [ $asd = "0" ]; then
				sorted=1
				asd="1"
				
				for k in "${!ISSNsSorted[@]}"; do
					for j in "${!ISSNs[@]}"; do 
					
 				  	if [[ "${ISSNsSorted[$k]}" = "${ISSNs[$j]}" ]]; then
 				  		if [[ " ${sortList[@]} " =~ " ${j} " ]]; then						
 				  		
 				  		sorted=0
 				  		if [[ ! " ${equals[@]} " =~ " ${j} " ]]; then
 						equals+=($k)
 					
 						fi
 				  		else
 				  		
 				  		
 				      		sortList[$k]=$j
 				     
 				      
 				  		ISSNsSorted[$k]=9999999999
 				  		fi
 				  	fi
 				  	done
 				  	
				done
			else
			for a in "${equals[@]}"; do
		
				
				
				b=${sortList[$a]}
				
				if [[ ${ISSNs[$b]} < ${ISSNs[$b-1]} ]]; then
					temp=${sortList[$a]}
					sortList[$a]=${sortList[a-1]}
					sortList[$a-1]=$temp 
				fi
				
				
			done		
			fi
			
		fi
		
		
		
		if [ $s == "CitationURL" ]; then
		
			IFS=$'\n' CitationURLsSorted=($(sort <<<"${CitationURLs[*]}"))
	
			
			if [ $CitationURLsSorted != $CitationURLs ] && [ $asd = "0" ]; then
				sorted=1
				asd="1"
			
				for k in "${!CitationURLsSorted[@]}"; do
					for j in "${!CitationURLs[@]}"; do 
					
 				  	if [[ "${CitationURLsSorted[$k]}" = "${CitationURLs[$j]}" ]]; then
 				  		if [[ " ${sortList[@]} " =~ " ${j} " ]]; then						
 				  		
 				  		sorted=0
 				  		if [[ ! " ${equals[@]} " =~ " ${j} " ]]; then
 						equals+=($k)
 					
 						fi
 				  		else
 				  		
 				  		
 				      		sortList[$k]=$j
 				     
 				      		
 				  		CitationURLsSorted[$k]=9999999999
 				  		fi
 				  	fi
 				  	done
 				  	
				done
			else
			for a in "${equals[@]}"; do
			
				
				
				b=${sortList[$a]}
				
				if [[ ${CitationURLs[$b]} < ${CitationURLs[$b-1]} ]]; then
					temp=${sortList[$a]}
					sortList[$a]=${sortList[a-1]}
					sortList[$a-1]=$temp 
				fi
				
				
			done		
			fi
			
		fi
		
		
		
		if [ $s == "Volume" ]; then
			
			VolumesSorted=( $( printf "%s\n" "${Volumes[@]}" | sort -n ) )
			if [ $VolumesSorted != $Volumes ] && [ $asd = "0" ]; then
				sorted=1
				asd="1"
				for k in "${!VolumesSorted[@]}"; do
					for j in "${!Volumes[@]}"; do 
 				  	if [[ "${VolumesSorted[$k]}" = "${Volumes[$j]}" ]]; then
 				  		if [[ " ${sortList[@]} " =~ " ${j} " ]]; then						
 				  		
 				  		sorted=0
 				  		if [[ ! " ${equals[@]} " =~ " ${j} " ]]; then
 						equals+=($k)
 					
 						fi
 				  		else
 				  		
 				  		
 				      		sortList[$k]=$j
 				     
 				     
 				  		VolumesSorted[$k]=9999999999
 				  		fi
 				  	fi
 				  done
				done
				
			else
			for a in "${equals[@]}"; do
			
				
				
				b=${sortList[$a]}
				
				if [[ ${Volumes[$b]} < ${Volumes[$b-1]} ]]; then
					temp=${sortList[$a]}
					sortList[$a]=${sortList[a-1]}
					sortList[$a-1]=$temp 
				fi
				
				
			done
			fi
			
		fi
		
		
		
		if [ $s == "Issue" ]; then
			
			IssuesSorted=( $( printf "%s\n" "${Issues[@]}" | sort -n ) )
			if [ $IssuesSorted != $Issues ] && [ $asd = "0" ]; then
				sorted=1
				asd="1"
				for k in "${!IssuesSorted[@]}"; do
					for j in "${!Issues[@]}"; do 
 				  	if [[ "${IssuesSorted[$k]}" = "${Issues[$j]}" ]]; then
 				  		if [[ " ${sortList[@]} " =~ " ${j} " ]]; then						
 				  		
 				  		sorted=0
 				  		if [[ ! " ${equals[@]} " =~ " ${j} " ]]; then
 						equals+=($k)
 					
 						fi
 				  		else
 				  		
 				  		
 				      		sortList[$k]=$j
 				     
 				      	
 				  		IssuesSorted[$k]=9999999999
 				  		fi
 				  	fi
 				  done
				done
				
			else
			for a in "${equals[@]}"; do
			
				
				
				b=${sortList[$a]}
				
				if [[ ${Issues[$b]} < ${Issues[$b-1]} ]]; then
					temp=${sortList[$a]}
					sortList[$a]=${sortList[a-1]}
					sortList[$a-1]=$temp 
				fi
				
				
			done
			fi
			
		fi
		
		
		
		if [ $s == "StartPage" ]; then
			
			StartPagesSorted=( $( printf "%s\n" "${StartPages[@]}" | sort -n ) )
			if [ $StartPagesSorted != $StartPages ] && [ $asd = "0" ]; then
				sorted=1
				asd="1"
				for k in "${!StartPagesSorted[@]}"; do
					for j in "${!StartPages[@]}"; do 
 				  	if [[ "${StartPagesSorted[$k]}" = "${StartPages[$j]}" ]]; then
 				  		if [[ " ${sortList[@]} " =~ " ${j} " ]]; then						
 				  		
 				  		sorted=0
 				  		if [[ ! " ${equals[@]} " =~ " ${j} " ]]; then
 						equals+=($k)
 					
 						fi
 				  		else
 				  		
 				  		
 				      		sortList[$k]=$j
 				     
 				      	
 				  		StartPagesSorted[$k]=9999999999
 				  		fi
 				  	fi
 				  done
				done
				
			else
			for a in "${equals[@]}"; do
			
				
				
				b=${sortList[$a]}
				
				if [[ ${StartPages[$b]} < ${StartPages[$b-1]} ]]; then
					temp=${sortList[$a]}
					sortList[$a]=${sortList[a-1]}
					sortList[$a-1]=$temp 
				fi
				
				
			done
			fi
			
		fi
		
		
		
		if [ $s == "EndPage" ]; then
			
			EndPagesSorted=( $( printf "%s\n" "${EndPages[@]}" | sort -n ) )
			if [ $EndPagesSorted != $EndPages ] && [ $asd = "0" ]; then
				sorted=1
				asd="1"
				for k in "${!EndPagesSorted[@]}"; do
					for j in "${!EndPages[@]}"; do 
 				  	if [[ "${EndPagesSorted[$k]}" = "${EndPages[$j]}" ]]; then
 				  		if [[ " ${sortList[@]} " =~ " ${j} " ]]; then						
 				  		
 				  		sorted=0
 				  		if [[ ! " ${equals[@]} " =~ " ${j} " ]]; then
 						equals+=($k)
 						
 						fi
 				  		else
 				  		
 				  		
 				      		sortList[$k]=$j
 				     
 				      	
 				  		EndPagesSorted[$k]=9999999999
 				  		fi
 				  	fi
 				  done
				done
				
			else
			for a in "${equals[@]}"; do
			
				
				
				b=${sortList[$a]}
				
				if [[ ${EndPages[$b]} < ${EndPages[$b-1]} ]]; then
					temp=${sortList[$a]}
					sortList[$a]=${sortList[a-1]}
					sortList[$a-1]=$temp 
				fi
				
				
			done
			fi
		fi
		
		
		
		if [ $s == "Abstract" ]; then
			
			IFS=$'\n' AbstractsSorted=($(sort <<<"${Abstracts[*]}"))
			
			
			if [ $AbstractsSorted != $Abstracts ] && [ $asd = "0" ]; then
				sorted=1
				asd="1"
				
				for k in "${!AbstractsSorted[@]}"; do
					for j in "${!Abstracts[@]}"; do 
					
 				  	if [[ "${AbstractsSorted[$k]}" = "${Abstracts[$j]}" ]]; then
 				  		if [[ " ${sortList[@]} " =~ " ${j} " ]]; then						
 				  		
 				  		sorted=0
 				  		if [[ ! " ${equals[@]} " =~ " ${j} " ]]; then
 						equals+=($k)
 					
 						fi
 				  		else
 				  		
 				  		
 				      		sortList[$k]=$j
 				     
 				      		
 				  		AbstractsSorted[$k]=9999999999
 				  		fi
 				  	fi
 				  	done
 				  	
				done
			else
			for a in "${equals[@]}"; do
			
				
				
				b=${sortList[$a]}
				
				if [[ ${Abstracts[$b]} < ${Abstracts[$b-1]} ]]; then
					temp=${sortList[$a]}
					sortList[$a]=${sortList[a-1]}
					sortList[$a-1]=$temp 
				fi
				
				
			done		
			fi
			
		fi
		
		
		
		if [ $s == "FullTextURL" ]; then
		
			IFS=$'\n' FullTextURLsSorted=($(sort <<<"${FullTextURLs[*]}"))
			
			
			if [ $FullTextURLsSorted != $FullTextURLs ] && [ $asd = "0" ]; then
				sorted=1
				asd="1"
			
				for k in "${!FullTextURLsSorted[@]}"; do
					for j in "${!FullTextURLs[@]}"; do 
					
 				  	if [[ "${FullTextURLsSorted[$k]}" = "${FullTextURLs[$j]}" ]]; then
 				  		if [[ " ${sortList[@]} " =~ " ${j} " ]]; then						
 				  		
 				  		sorted=0
 				  		if [[ ! " ${equals[@]} " =~ " ${j} " ]]; then
 						equals+=($k)
 						
 						fi
 				  		else
 				  		
 				  		
 				      		sortList[$k]=$j
 				     

 				  		FullTextURLsSorted[$k]=9999999999
 				  		fi
 				  	fi
 				  	done
 				  	
				done
			else
			for a in "${equals[@]}"; do
				
				
				
				b=${sortList[$a]}
				
				if [[ ${FullTextURLs[$b]} < ${FullTextURLs[$b-1]} ]]; then
					temp=${sortList[$a]}
					sortList[$a]=${sortList[a-1]}
					sortList[$a-1]=$temp 
				fi
				
				
			done		
			fi
			
		fi
		
		
		
		if [ $s == "RelatedURL" ]; then
			
			IFS=$'\n' RelatedURLsSorted=($(sort <<<"${RelatedURLs[*]}"))
			
			
			if [ $RelatedURLsSorted != $RelatedURLs ] && [ $asd = "0" ]; then
				sorted=1
				asd="1"
				
				for k in "${!RelatedURLsSorted[@]}"; do
					for j in "${!RelatedURLs[@]}"; do 
					
 				  	if [[ "${RelatedURLsSorted[$k]}" = "${RelatedURLs[$j]}" ]]; then
 				  		if [[ " ${sortList[@]} " =~ " ${j} " ]]; then						
 				  		
 				  		sorted=0
 				  		if [[ ! " ${equals[@]} " =~ " ${j} " ]]; then
 						equals+=($k)
 					
 						fi
 				  		else
 				  		
 				  		
 				      		sortList[$k]=$j
 				     
 				      		
 				  		RelatedURLsSorted[$k]=9999999999
 				  		fi
 				  	fi
 				  	done
 				  	
				done
			else
			for a in "${equals[@]}"; do
				
				
				b=${sortList[$a]}
				
				if [[ ${RelatedURLs[$b]} < ${RelatedURLs[$b-1]} ]]; then
					temp=${sortList[$a]}
					sortList[$a]=${sortList[a-1]}
					sortList[$a-1]=$temp 
				fi
				
				
			done		
			fi
			
		fi
		
		
		
		
	fi 
done
if [ "${sortList[0]}" = "" ]; then
	sortList=(1 2 3)
fi
arrIndex=0 
outArr=()
for index in ${sortList[@]}; do

	outArr[arrIndex]=${Cites[index]},${Authors[index]}
	outArr[arrIndex]=${outArr[arrIndex]},${Titles[index]}
	outArr[arrIndex]=${outArr[arrIndex]},${Years[index]}
	outArr[arrIndex]=${outArr[arrIndex]},${Sources[index]}
	outArr[arrIndex]=${outArr[arrIndex]},${Publishers[index]}
	outArr[arrIndex]=${outArr[arrIndex]},${ArticleURLs[index]}
	outArr[arrIndex]=${outArr[arrIndex]},${CitesURLs[index]}
	outArr[arrIndex]=${outArr[arrIndex]},${GSRanks[index]}
	outArr[arrIndex]=${outArr[arrIndex]},${QueryDates[index]}
	outArr[arrIndex]=${outArr[arrIndex]},${Types[index]}
	outArr[arrIndex]=${outArr[arrIndex]},${DOIs[index]}
	outArr[arrIndex]=${outArr[arrIndex]},${ISSNs[index]}
	outArr[arrIndex]=${outArr[arrIndex]},${CitationURLs[index]}
	outArr[arrIndex]=${outArr[arrIndex]},${Volumes[index]}
	outArr[arrIndex]=${outArr[arrIndex]},${Issues[index]}
	outArr[arrIndex]=${outArr[arrIndex]},${StartPages[index]}
	outArr[arrIndex]=${outArr[arrIndex]},${EndPages[index]}
	outArr[arrIndex]=${outArr[arrIndex]},${ECCs[index]}
	outArr[arrIndex]=${outArr[arrIndex]},${CitesPerYears[index]}
	outArr[arrIndex]=${outArr[arrIndex]},${CitesPerAuthors[index]}
	outArr[arrIndex]=${outArr[arrIndex]},${AuthorCounts[index]}
	outArr[arrIndex]=${outArr[arrIndex]},${Ages[index]}
	outArr[arrIndex]=${outArr[arrIndex]},${Abstracts[index]}
	outArr[arrIndex]=${outArr[arrIndex]},${FullTextURLs[index]}
	outArr[arrIndex]=${outArr[arrIndex]},${RelatedURLs[index]}
	outArr[arrIndex]=${outArr[arrIndex]},`expr ${EndPages[index]} - ${StartPages[index]} + 1`
	
	arrIndex=`expr $arrIndex + 1`
done
out=""
j=0
for i in "${outArr[@]}";
do
	
	if [ $j = 0 ]; then
	out=$i
	fi
	if [ $j != 0 ]; then
	out=$out$'\n'$i
	fi
	j=1
done

echo "Cites,Authors,Title,Year,Source,Publisher,ArticleURL,CitesURL,GSRank,QueryDate,Type,DOI,ISSN,CitationURL,Volume,Issue,StartPage,EndPage,ECC,CitesPerYear,CitesPerAuthor,AuthorCount,Age,Abstract,FullTextURL,RelatedURL,TotalPages
""$out" > $OUTFILE

