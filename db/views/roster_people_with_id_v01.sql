SELECT row_number() OVER () AS id,
       roster_people_materialized2.party_id,
       roster_people_materialized2.dlm,
       roster_people_materialized2.doc_number
FROM roster_people_materialized2;