SELECT roster_parties_materialized.party_id,
       COALESCE(ltrim(roster_parties_materialized.jailnet_inmate_id, '0'::text),
                ltrim(roster_parties_materialized.tulsa_blotter_dlm, '0'::text),
                (tulsa_blotter_arrests.clean_dlm)::text, (pd_bookings.clean_dlm)::text) AS dlm,
       roster_parties_materialized.doc_number
FROM ((roster_parties_materialized
    FULL JOIN pd_bookings ON ((roster_parties_materialized.jailnet_inmate_id = (pd_bookings.jailnet_inmate_id)::text)))
    FULL JOIN tulsa_blotter_arrests
      ON ((roster_parties_materialized.tulsa_blotter_dlm = (tulsa_blotter_arrests.dlm)::text)))
GROUP BY roster_parties_materialized.party_id,
         COALESCE(ltrim(roster_parties_materialized.jailnet_inmate_id, '0'::text),
                  ltrim(roster_parties_materialized.tulsa_blotter_dlm, '0'::text),
                  (tulsa_blotter_arrests.clean_dlm)::text, (pd_bookings.clean_dlm)::text),
         roster_parties_materialized.doc_number;