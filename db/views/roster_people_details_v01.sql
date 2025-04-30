SELECT row_number() OVER () AS id,
       COALESCE(((((((main.last_name || '__'::text) || main.first_name) || '__'::text) || main.birth_year) || '__'::text) || main.birth_month), ((main.roster_people_merged_id)::character varying)::text) AS roster_people_details_merged_id,
       main.roster_people_merged_id,
       main.first_name,
       main.last_name,
       main.birth_year,
       main.birth_month
FROM ( SELECT roster_people_merged.ids AS roster_people_merged_id,
              COALESCE(max(upper((parties.first_name)::text)), max(upper((pd_bookings.first_name)::text)), max(upper((tulsa_blotter_arrests.first)::text)), max(upper((doc_profiles.first_name)::text))) AS first_name,
              COALESCE(max(upper((parties.last_name)::text)), max(upper((pd_bookings.last_name)::text)), max(upper((tulsa_blotter_arrests.last)::text)), max(upper((doc_profiles.last_name)::text))) AS last_name,
              COALESCE((max(parties.birth_year))::double precision, max(date_part('year'::text, pd_bookings.birth_date)), max(date_part('year'::text, doc_profiles.birth_date))) AS birth_year,
              COALESCE((max(parties.birth_month))::double precision, max(date_part('month'::text, pd_bookings.birth_date)), max(date_part('month'::text, doc_profiles.birth_date))) AS birth_month
       FROM (((((((roster_people_merged
           LEFT JOIN roster_people_merged_dlms ON ((roster_people_merged_dlms.roster_people_merged_id = roster_people_merged.ids)))
           LEFT JOIN pd_bookings ON (((pd_bookings.jailnet_inmate_id)::text = roster_people_merged_dlms.dlm)))
           LEFT JOIN tulsa_blotter_arrests ON (((tulsa_blotter_arrests.dlm)::text = roster_people_merged_dlms.dlm)))
           LEFT JOIN roster_people_merged_parties ON ((roster_people_merged_parties.roster_people_merged_id = roster_people_merged.ids)))
           LEFT JOIN parties ON ((parties.id = roster_people_merged_parties.party_id)))
           LEFT JOIN roster_people_merged_doc_numbers ON ((roster_people_merged_doc_numbers.roster_people_merged_id = roster_people_merged.ids)))
           LEFT JOIN doc_profiles ON ((doc_profiles.doc_number = roster_people_merged_doc_numbers.doc_number)))
       GROUP BY roster_people_merged.ids) main;