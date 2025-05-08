SELECT parties.id AS party_id,
       parties.full_name AS party_name,
       ((parties.birth_year || '-'::text) || parties.birth_month) AS party_dob_part,
       max((pd_bookings.jailnet_inmate_id)::text) AS jailnet_inmate_id,
       array_agg(DISTINCT pd_bookings.inmate_name) AS pd_inmate_names,
       array_agg(DISTINCT pd_bookings.birth_date) AS pd_dobs,
       max(doc_profiles.doc_number) AS doc_number,
       array_agg(DISTINCT (((doc_profiles.first_name)::text || ' '::text) || (doc_profiles.last_name)::text)) AS doc_names,
       array_agg(DISTINCT doc_profiles.birth_date) AS doc_dobs,
       max((tulsa_blotter_arrests.dlm)::text) AS tulsa_blotter_dlm,
       array_agg(DISTINCT (((tulsa_blotter_arrests.first)::text || ' '::text) || (tulsa_blotter_arrests.last)::text)) AS tulsa_name
FROM ((((((roster_cases_materialized roster_cases
    JOIN court_case_party_counts ON ((court_case_party_counts.court_case_id = roster_cases.court_case_id)))
    JOIN case_parties ON ((case_parties.court_case_id = roster_cases.court_case_id)))
    JOIN parties ON (((case_parties.party_id = parties.id) AND (parties.last_name IS NOT NULL))))
    LEFT JOIN doc_profiles ON (((roster_cases.doc_profile_id = doc_profiles.id) AND ((court_case_party_counts.count = 1) OR (((parties.last_name)::text ~~* (doc_profiles.last_name)::text) AND ((parties.first_name)::text ~~* (doc_profiles.first_name)::text) AND ((parties.birth_year)::double precision = date_part('year'::text, doc_profiles.birth_date)) AND ((parties.birth_month)::double precision = date_part('month'::text, doc_profiles.birth_date)))))))
    LEFT JOIN pd_bookings ON (((roster_cases.pd_booking_id = pd_bookings.id) AND ((parties.birth_year)::double precision = date_part('year'::text, pd_bookings.birth_date)) AND ((parties.birth_month)::double precision = date_part('month'::text, pd_bookings.birth_date)) AND ((court_case_party_counts.count = 1) OR ((pd_bookings.inmate_name)::text ~~* ((((parties.last_name)::text || ', '::text) || (parties.first_name)::text) || ' %'::text))))))
    LEFT JOIN tulsa_blotter_arrests ON (((roster_cases.tulsa_blotter_arrest_id = tulsa_blotter_arrests.id) AND (((court_case_party_counts.count = 1) AND (((parties.last_name)::text ~~* (tulsa_blotter_arrests.last)::text) OR ((parties.first_name)::text ~~* (tulsa_blotter_arrests.first)::text))) OR (((parties.last_name)::text ~~* (tulsa_blotter_arrests.last)::text) AND ((parties.first_name)::text ~~* (tulsa_blotter_arrests.first)::text))))))
GROUP BY parties.id;