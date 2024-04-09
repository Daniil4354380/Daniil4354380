#!/usr/bin/env bash

print_date() {
	date '+%H %M'
}

read -r -a current_date <<< "$(print_date)"

residuary_time() {
	if [[ $2 -ge "${current_date[1]}" ]]; then
		if [[ $(($1-current_date[0])) -eq 0 ]]; then
			echo "$(($2-current_date[1]))м"
		else
			echo "$(($1-current_date[0]))ч $(($2-current_date[1]))м"
		fi
	else
		if [[ $(($1-1-current_date[0])) -eq 0 ]]; then
			echo "$(($2+60-current_date[1]))м"
		else
			echo "$(($1-1-current_date[0]))ч $(($2+60-current_date[1]))м"
		fi
	fi
}

if [[ "${current_date[0]}" -lt 9 ]]; then
	echo "󰼾 пары не начались, $(residuary_time 9 00) до начала"
elif [[ "${current_date[0]}" -eq 9 || "${current_date[0]}" -eq 10 &&
	"${current_date[1]}" -lt 30 ]]; then
	echo "первая пара, $(residuary_time 10 30) до конца"
elif [[ "${current_date[0]}" -eq 10 && "${current_date[1]}" -ge 30 &&
	"${current_date[1]}" -lt 45 ]]; then
	echo "перерыв, $(residuary_time 10 45) до второй пары"
elif [[ "${current_date[0]}" -eq 10 && "${current_date[1]}" -ge 45 ||
	"${current_date[0]}" -eq 11 || "${current_date[0]}" -eq 12 &&
	"${current_date[1]}" -lt 15 ]]; then
	echo "вторая пара, $(residuary_time 12 15) до конца"
elif [[ "${current_date[0]}" -eq 12 && "${current_date[1]}" -ge 15 ]]; then
	echo "перерыв, $(residuary_time 13 00) до третьей пары"
elif [[ "${current_date[0]}" -eq 13 || "${current_date[0]}" -eq 14 &&
	"${current_date[1]}" -lt 30 ]]; then
	echo "третья пара, $(residuary_time 14 30) до конца"
elif [[ "${current_date[0]}" -eq 14 && "${current_date[1]}" -ge 30 &&
	"${current_date[1]}" -lt 45 ]]; then
	echo "перерыв, $(residuary_time 14 45) до четвёртой пары"
elif [[ "${current_date[0]}" -eq 14 && "${current_date[1]}" -ge 45 ||
	"${current_date[0]}" -eq 15 || "${current_date[0]}" -eq 16 &&
	"${current_date[1]}" -lt 15 ]]; then
	echo "четвёртая пара, $(residuary_time 16 15) до конца"
elif [[ "${current_date[0]}" -eq 16 && "${current_date[1]}" -ge 15 &&
	"${current_date[1]}" -lt 30 ]]; then
	echo "перерыв, $(residuary_time 16 30) до пятой пары"
elif [[ "${current_date[0]}" -eq 16 && "${current_date[1]}" -ge 30 ||
	"${current_date[0]}" -eq 17 ]]; then
	echo "пятая пара, $(residuary_time 18 00) до конца"
elif [[ "${current_date[0]}" -ge 18 ]]; then
	echo "пары закончились"
fi
