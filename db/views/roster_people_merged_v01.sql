WITH RECURSIVE al(tail, head) AS (
    SELECT f.id,
           g.id
    FROM (roster_people_with_id f
        JOIN roster_people_with_id g ON (((f.party_id = g.party_id) OR (f.dlm = g.dlm) OR (f.doc_number = g.doc_number))))
), tc(tail, head) AS (
    SELECT al.tail,
           al.head
    FROM al
    UNION
    SELECT f.tail,
           g.head
    FROM (al f
        JOIN tc g ON ((f.head = g.tail)))
), cc(head, ids) AS (
    SELECT tc.head,
           array_agg(DISTINCT tc.tail ORDER BY tc.tail) AS ids
    FROM tc
    GROUP BY tc.head
)
SELECT cc.ids,
       array_remove(array_agg(DISTINCT roster_people_with_id.party_id ORDER BY roster_people_with_id.party_id), NULL::bigint) AS party_ids,
       array_remove(array_agg(DISTINCT roster_people_with_id.dlm ORDER BY roster_people_with_id.dlm), NULL::text) AS dlms,
       array_remove(array_agg(DISTINCT roster_people_with_id.doc_number ORDER BY roster_people_with_id.doc_number), NULL::integer) AS doc_numbers
FROM (cc
    JOIN roster_people_with_id ON ((cc.head = roster_people_with_id.id)))
GROUP BY cc.ids;