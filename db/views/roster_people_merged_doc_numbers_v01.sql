SELECT roster_people_merged.ids AS roster_people_merged_id,
       unnest(roster_people_merged.doc_numbers) AS doc_number
FROM roster_people_merged;