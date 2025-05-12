SELECT oscn_court_cases.clean_case_number,
       oscn_court_cases.id AS court_case_id,
       doc_sentences.id AS doc_sentence_id,
       doc_sentences.doc_profile_id,
       pd_offenses.id AS pd_offense_id,
       pd_offenses.booking_id AS pd_booking_id,
       tulsa_blotter_offenses.id AS tulsa_blotter_offense_id,
       tulsa_blotter_offenses.arrests_id AS tulsa_blotter_arrest_id
FROM ((((court_cases oscn_court_cases
    JOIN counties oscn_county ON ((oscn_court_cases.county_id = oscn_county.id)))
    LEFT JOIN doc_sentences ON ((((oscn_court_cases.clean_case_number)::text = (doc_sentences.clean_case_number)::text) AND ((doc_sentences.sentencing_county)::text ~~* ((oscn_county.name)::text || '%'::text)))))
    LEFT JOIN pd_offenses ON ((((oscn_court_cases.clean_case_number)::text = (pd_offenses.clean_case_number)::text) AND ((oscn_county.name)::text = 'Tulsa'::text))))
    LEFT JOIN tulsa_blotter_offenses ON ((((oscn_court_cases.clean_case_number)::text = (tulsa_blotter_offenses.clean_case_number)::text) AND ((oscn_county.name)::text = 'Tulsa'::text))));