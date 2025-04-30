SELECT court_cases.id AS court_case_id,
       count(case_parties.party_id) AS count
FROM ((court_cases
    JOIN case_parties ON ((court_cases.id = case_parties.court_case_id)))
    JOIN parties ON ((case_parties.party_id = parties.id)))
WHERE (parties.party_type_id = 7)
GROUP BY court_cases.id;