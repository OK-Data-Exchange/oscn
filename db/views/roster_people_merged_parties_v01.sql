SELECT roster_people_merged.ids AS roster_people_merged_id,
       unnest(roster_people_merged.party_ids) AS party_id
FROM roster_people_merged;