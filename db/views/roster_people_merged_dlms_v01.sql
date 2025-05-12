SELECT roster_people_merged.ids AS roster_people_merged_id,
       unnest(roster_people_merged.dlms) AS dlm
FROM roster_people_merged;