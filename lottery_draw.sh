#!/bin/bash
#PS4=':$LINENO+'; set -x

size=49
lottery_size=7
steps=0
typeset data

for ((i=0; i<lottery_size; i++)); do
    Rnum=$((RANDOM % size+1))
    Length=${#data1[@]}
    if [ $Length -eq 0 ];then
        data1[$i]=$Rnum
    else
        for ((j=0; j<$Length; j++)); do
            if [ $Rnum != ${data1[$j]} ];then
	        continue
            else
                 Rnum=$((RANDOM % size+1))
                 j=-1
            fi
        done
        data1[$i]=$Rnum
    fi
done
echo -n "======================== Lottery Draw ========================"
printf '\n'
echo -n "Choose 6 winning numbers and a special code from 1~49 numbers"
printf '\n'

partition() {
    local pivot left right dest temp
    pivot=${data[$1]}
    left=$(($1 + 1))
    right=$2
    dest=$3

    while true; do
        while (( left <= right )) && (( ${data[$left]} <= pivot )); do
            left=$(( left + 1 ))
            steps=$(( steps + 1 ))
        done

        while (( right >= left )) && (( ${data[$right]} >= pivot )); do
            right=$(( right - 1 ))
            steps=$(( steps + 1 ))
        done

        (( left > right )) && break

        temp=${data[$left]}
        data[$left]=${data[$right]}
        data[$right]=$temp
    done

    : '$1='"$1" right="$right" 'data[$1]='"${data[$1]}" 'data[$right]='"${data[$right]}"
    temp=${data[$1]}
    data[$1]=${data[$right]}
    data[$right]=$temp

    printf -v "$dest" %s "$right"
}

quickSort() {
    local partitionPoint
    if (( $1 < $2 )); then
        partition "$1" "$2" partitionPoint
        quickSort "$1" "$(( partitionPoint - 1 ))"
        quickSort "$((partitionPoint + 1))" "$2"
    fi
}
# involve the algorithm
for ((i=0; i<6; i++)); do
    tmp=${data1[$i]}
    data[$i]=$tmp
done
for ((i=0; i<6; i++)); do
    tmp=${data1[$i]}
    data2[$i]=$tmp
done
quickSort 0 "$(( 6 - 1 ))"

echo -n "Before Lotto winning numbers sorting: "
printf '%s ' "${data2[@]}"
printf "\n"
echo -n "Sorted Lotto winning numbers: "
printf '%s ' "${data[@]}"
printf "\n"
echo -n "Lotto special code: "
printf '%s ' "${data1[6]}"
printf "\n"
