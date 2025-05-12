SELECT roster_people_details.roster_people_details_merged_id AS id,
       roster_people_details.first_name,
       roster_people_details.last_name,
       roster_people_details.birth_month,
       roster_people_details.birth_year
FROM roster_people_details
GROUP BY roster_people_details.roster_people_details_merged_id, roster_people_details.first_name, roster_people_details.last_name, roster_people_details.birth_month, roster_people_details.birth_year;