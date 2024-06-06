# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_05_19_192652) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "case_htmls", force: :cascade do |t|
    t.bigint "court_case_id", null: false
    t.datetime "scraped_at", precision: nil
    t.text "html"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["court_case_id"], name: "index_case_htmls_on_court_case_id"
  end

  create_table "case_not_founds", force: :cascade do |t|
    t.bigint "county_id", null: false
    t.string "case_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_case_not_founds_on_county_id"
  end

  create_table "case_parties", force: :cascade do |t|
    t.bigint "court_case_id", null: false
    t.bigint "party_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "roster_id"
    t.index ["court_case_id", "party_id"], name: "index_case_parties_on_court_case_id_and_party_id", unique: true
    t.index ["court_case_id"], name: "index_case_parties_on_court_case_id"
    t.index ["party_id", "court_case_id"], name: "index_case_parties_on_party_id_and_court_case_id", unique: true
    t.index ["party_id"], name: "index_case_parties_on_party_id"
    t.index ["roster_id"], name: "index_case_parties_on_roster_id"
  end

  create_table "case_types", force: :cascade do |t|
    t.integer "oscn_id", null: false
    t.string "name", null: false
    t.string "abbreviation", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "census_data", force: :cascade do |t|
    t.bigint "statistic_id", null: false
    t.string "amount"
    t.string "area_type", null: false
    t.bigint "area_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_type", "area_id"], name: "index_census_data_on_area"
    t.index ["statistic_id"], name: "index_census_data_on_statistic_id"
  end

  create_table "census_statistics", force: :cascade do |t|
    t.string "name", null: false
    t.string "label", null: false
    t.bigint "survey_id", null: false
    t.string "concept", null: false
    t.string "group", null: false
    t.string "predicate_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_census_statistics_on_survey_id"
  end

  create_table "census_surveys", force: :cascade do |t|
    t.string "name", null: false
    t.integer "year", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "community_crimes", force: :cascade do |t|
    t.string "address"
    t.string "agency"
    t.string "crime_class"
    t.string "crime"
    t.datetime "incident_at"
    t.string "incident_number"
    t.string "location_type"
    t.string "source_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agency", "incident_number", "incident_at"], name: "index_ln_crimes_on_agency_and_inc_number_and_inc_at", unique: true
  end

  create_table "counsel_parties", force: :cascade do |t|
    t.bigint "court_case_id", null: false
    t.bigint "party_id", null: false
    t.bigint "counsel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["counsel_id"], name: "index_counsel_parties_on_counsel_id"
    t.index ["court_case_id"], name: "index_counsel_parties_on_court_case_id"
    t.index ["party_id"], name: "index_counsel_parties_on_party_id"
  end

  create_table "counsels", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.integer "bar_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "city"
    t.string "state"
    t.string "member_type"
    t.string "member_status"
    t.date "admit_date"
    t.boolean "ok_bar", default: false, null: false
    t.index ["bar_number"], name: "index_counsels_on_bar_number", unique: true, where: "(bar_number IS NOT NULL)"
  end

  create_table "count_codes", force: :cascade do |t|
    t.string "code", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_count_codes_on_code", unique: true
  end

  create_table "counties", force: :cascade do |t|
    t.string "name", null: false
    t.string "fips_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "district_attorney_id"
    t.integer "ok_code"
    t.index ["district_attorney_id"], name: "index_counties_on_district_attorney_id"
  end

  create_table "counts", force: :cascade do |t|
    t.bigint "court_case_id", null: false
    t.bigint "party_id", null: false
    t.date "offense_on"
    t.string "as_filed"
    t.string "filed_statute_violation"
    t.string "disposition"
    t.date "disposition_on"
    t.string "disposed_statute_violation"
    t.bigint "plea_id"
    t.bigint "verdict_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "charge"
    t.bigint "filed_statute_code_id"
    t.bigint "disposed_statute_code_id"
    t.integer "number"
    t.index ["court_case_id"], name: "index_counts_on_court_case_id"
    t.index ["disposed_statute_code_id"], name: "index_counts_on_disposed_statute_code_id"
    t.index ["filed_statute_code_id"], name: "index_counts_on_filed_statute_code_id"
    t.index ["party_id"], name: "index_counts_on_party_id"
    t.index ["plea_id"], name: "index_counts_on_plea_id"
    t.index ["verdict_id"], name: "index_counts_on_verdict_id"
  end

  create_table "court_cases", force: :cascade do |t|
    t.integer "oscn_id"
    t.bigint "county_id", null: false
    t.bigint "case_type_id", null: false
    t.string "case_number"
    t.date "filed_on"
    t.date "closed_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "logs"
    t.bigint "current_judge_id"
    t.boolean "is_error", default: false, null: false
    t.boolean "enqueued", default: false, null: false
    t.index ["case_type_id"], name: "index_court_cases_on_case_type_id"
    t.index ["county_id", "oscn_id"], name: "index_court_cases_on_county_id_and_oscn_id", unique: true
    t.index ["county_id"], name: "index_court_cases_on_county_id"
    t.index ["current_judge_id"], name: "index_court_cases_on_current_judge_id"
  end

  create_table "district_attorneys", force: :cascade do |t|
    t.string "name", null: false
    t.integer "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "doc_aliases", force: :cascade do |t|
    t.bigint "doc_profile_id", null: false
    t.integer "doc_number"
    t.string "last_name"
    t.string "first_name"
    t.string "middle_name"
    t.string "suffix"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["doc_profile_id", "doc_number", "last_name", "first_name", "middle_name", "suffix"], name: "alias_index", unique: true
    t.index ["doc_profile_id"], name: "index_doc_aliases_on_doc_profile_id"
  end

  create_table "doc_facilities", force: :cascade do |t|
    t.string "name"
    t.boolean "is_prison", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "doc_offense_codes", force: :cascade do |t|
    t.string "statute_code", null: false
    t.string "description", null: false
    t.boolean "is_violent", default: false, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["statute_code", "description", "is_violent"], name: "doc_offense_codes_index", unique: true
    t.index ["statute_code", "description", "is_violent"], name: "offense_code_index", unique: true
  end

  create_table "doc_profiles", force: :cascade do |t|
    t.integer "doc_number", null: false
    t.string "last_name"
    t.string "first_name"
    t.string "middle_name"
    t.string "suffix"
    t.date "last_move_date"
    t.string "facility"
    t.date "birth_date"
    t.integer "sex"
    t.string "race"
    t.string "hair"
    t.string "height_ft"
    t.string "height_in"
    t.string "weight"
    t.string "eye"
    t.integer "status"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "doc_facility_id"
    t.bigint "roster_id"
    t.index ["doc_facility_id"], name: "index_doc_profiles_on_doc_facility_id"
    t.index ["doc_number"], name: "index_doc_profiles_on_doc_number", unique: true
    t.index ["roster_id"], name: "index_doc_profiles_on_roster_id"
  end

  create_table "doc_sentences", force: :cascade do |t|
    t.bigint "doc_profile_id", null: false
    t.bigint "doc_offense_code_id"
    t.string "statute_code"
    t.string "sentencing_county"
    t.date "js_date"
    t.string "crf_number"
    t.decimal "incarcerated_term_in_years"
    t.decimal "probation_term_in_years"
    t.boolean "is_death_sentence", default: false, null: false
    t.boolean "is_life_sentence", default: false, null: false
    t.boolean "is_life_no_parole_sentence", default: false, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "court_case_id"
    t.string "sentence_id", null: false
    t.string "consecutive_to_sentence_id"
    t.bigint "doc_sentencing_county_id"
    t.virtual "clean_case_number", type: :string, as: "\nCASE\n    WHEN ((crf_number)::text ~ 'CF-\\d{4}-[0-9]{1,4}'::text) THEN crf_number\n    WHEN ((crf_number)::text ~ '\\d{4}-[0-9]{1,4}'::text) THEN (('CF-'::text || (crf_number)::text))::character varying\n    WHEN ((crf_number)::text ~ '\\d{2}-[0-9]{1,4}'::text) THEN (('CF-20'::text || (crf_number)::text))::character varying\n    ELSE NULL::character varying\nEND", stored: true
    t.index ["court_case_id"], name: "index_doc_sentences_on_court_case_id"
    t.index ["doc_offense_code_id"], name: "index_doc_sentences_on_doc_offense_code_id"
    t.index ["doc_profile_id", "sentence_id"], name: "index_doc_sentences_on_doc_profile_id_and_sentence_id", unique: true
    t.index ["doc_profile_id"], name: "index_doc_sentences_on_doc_profile_id"
    t.index ["doc_sentencing_county_id"], name: "index_doc_sentences_on_doc_sentencing_county_id"
  end

  create_table "doc_sentencing_counties", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "county_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_doc_sentencing_counties_on_county_id"
  end

  create_table "doc_statuses", force: :cascade do |t|
    t.bigint "doc_profile_id", null: false
    t.string "facility", null: false
    t.date "date"
    t.string "reason"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "doc_facility_id"
    t.index ["doc_facility_id"], name: "index_doc_statuses_on_doc_facility_id"
    t.index ["doc_profile_id", "date", "facility"], name: "status_index", unique: true
    t.index ["doc_profile_id"], name: "index_doc_statuses_on_doc_profile_id"
  end

  create_table "docket_event_links", force: :cascade do |t|
    t.bigint "docket_event_id", null: false
    t.integer "oscn_id", null: false
    t.string "title", null: false
    t.string "link", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["docket_event_id"], name: "index_docket_event_links_on_docket_event_id"
  end

  create_table "docket_event_types", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_docket_event_types_on_code", unique: true
    t.index ["id", "code"], name: "index_docket_event_types_on_id_and_code"
  end

  create_table "docket_events", force: :cascade do |t|
    t.bigint "court_case_id", null: false
    t.date "event_on"
    t.bigint "docket_event_type_id", null: false
    t.text "description"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "party_id"
    t.integer "count"
    t.decimal "payment", default: "0.0", null: false
    t.decimal "adjustment", default: "0.0", null: false
    t.integer "row_index", null: false
    t.boolean "is_otc_payment", default: false, null: false
    t.index ["adjustment"], name: "index_docket_events_on_adjustment", where: "(adjustment <> (0)::numeric)"
    t.index ["amount"], name: "index_docket_events_on_amount", where: "(amount <> (0)::numeric)"
    t.index ["court_case_id"], name: "index_docket_events_on_court_case_id"
    t.index ["docket_event_type_id"], name: "index_docket_events_on_docket_event_type_id"
    t.index ["party_id"], name: "index_docket_events_on_party_id"
    t.index ["payment"], name: "index_docket_events_on_payment", where: "(payment <> (0)::numeric)"
    t.index ["row_index", "court_case_id"], name: "index_docket_events_on_row_index_and_court_case_id", unique: true
  end

  create_table "event_types", force: :cascade do |t|
    t.integer "oscn_id", null: false
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["oscn_id"], name: "index_event_types_on_oscn_id", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.bigint "court_case_id", null: false
    t.bigint "party_id"
    t.datetime "event_at", null: false
    t.string "event_name"
    t.string "docket"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "judge_id"
    t.bigint "event_type_id"
    t.index ["court_case_id"], name: "index_events_on_court_case_id"
    t.index ["event_type_id"], name: "index_events_on_event_type_id"
    t.index ["judge_id"], name: "index_events_on_judge_id"
    t.index ["party_id"], name: "index_events_on_party_id"
  end

  create_table "eviction_files", force: :cascade do |t|
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "generated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "eviction_letters", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.bigint "docket_event_link_id", null: false
    t.string "ocr_plaintiff_address"
    t.string "ocr_agreed_amount"
    t.string "ocr_default_amount"
    t.string "ocr_plaintiff_phone_number"
    t.boolean "is_validated", default: false, null: false
    t.string "validation_granularity"
    t.string "validation_unconfirmed_components"
    t.string "validation_inferred_components"
    t.string "validation_usps_address"
    t.string "validation_usps_state_zip"
    t.float "validation_latitude"
    t.float "validation_longitude"
    t.string "postgrid_id"
    t.datetime "postgrid_sent_to_api_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "validation_object", default: {}, null: false
    t.string "validation_city"
    t.string "validation_zip_code"
    t.string "validation_state"
    t.boolean "is_metadata_present", default: false, null: false
    t.boolean "is_po_box", default: false, null: false
    t.boolean "is_business", default: false, null: false
    t.boolean "is_residential", default: false, null: false
    t.bigint "eviction_file_id"
    t.index ["docket_event_link_id"], name: "index_eviction_letters_on_docket_event_link_id", unique: true
    t.index ["eviction_file_id"], name: "index_eviction_letters_on_eviction_file_id"
  end

  create_table "issue_parties", force: :cascade do |t|
    t.bigint "issue_id", null: false
    t.bigint "party_id", null: false
    t.date "disposition_on"
    t.bigint "verdict_id"
    t.string "verdict_details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_issue_parties_on_issue_id"
    t.index ["party_id"], name: "index_issue_parties_on_party_id"
    t.index ["verdict_id"], name: "index_issue_parties_on_verdict_id"
  end

  create_table "issues", force: :cascade do |t|
    t.integer "number"
    t.string "name"
    t.bigint "court_case_id", null: false
    t.bigint "count_code_id"
    t.date "filed_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "filed_by"
    t.index ["count_code_id"], name: "index_issues_on_count_code_id"
    t.index ["court_case_id"], name: "index_issues_on_court_case_id"
  end

  create_table "judges", force: :cascade do |t|
    t.string "name", null: false
    t.string "courthouse"
    t.bigint "county_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "oscn_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["county_id"], name: "index_judges_on_county_id"
  end

  create_table "ocso_warrants", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "middle_name"
    t.date "birth_date"
    t.string "case_number"
    t.decimal "bond_amount", precision: 14, scale: 2
    t.date "issued"
    t.string "counts"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "resolved_at", precision: nil
    t.virtual "clean_case_number", type: :string, as: "\nCASE\n    WHEN ((case_number)::text ~ '^[A-Za-z]{2}[0-9]{5,}'::text) THEN ((((\"substring\"((case_number)::text, 1, 2) || '-'::text) ||\n    CASE\n        WHEN ((\"substring\"((case_number)::text, 3, 2))::integer <= 23) THEN ('20'::text || \"substring\"((case_number)::text, 3, 2))\n        ELSE ('19'::text || \"substring\"((case_number)::text, 3, 2))\n    END) || '-'::text) || regexp_replace(\"substring\"((case_number)::text, 5), '^0+'::text, ''::text))\n    WHEN ((case_number)::text ~ '^[A-Za-z]{2}-[0-9]{2}-[0-9]{1,}'::text) THEN ((((\"substring\"((case_number)::text, 1, 2) || '-'::text) ||\n    CASE\n        WHEN ((split_part((case_number)::text, '-'::text, 2))::integer <= 23) THEN ('20'::text || split_part((case_number)::text, '-'::text, 2))\n        ELSE ('19'::text || split_part((case_number)::text, '-'::text, 2))\n    END) || '-'::text) || split_part((case_number)::text, '-'::text, 3))\n    WHEN ((case_number)::text ~ '^[A-Za-z]{2}-[0-9]{4}-[0-9]{1,}'::text) THEN (case_number)::text\n    ELSE NULL::text\nEND", stored: true
    t.index ["case_number", "first_name", "last_name", "birth_date"], name: "index_ocso_warrants_on_case_number_etc", unique: true
  end

  create_table "ok2_explore_deaths", force: :cascade do |t|
    t.string "last_name", null: false
    t.string "first_name", null: false
    t.string "middle_name"
    t.integer "sex", null: false
    t.bigint "county_id"
    t.datetime "death_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_ok2_explore_deaths_on_county_id"
  end

  create_table "ok2_explore_scrape_jobs", force: :cascade do |t|
    t.integer "year", null: false
    t.integer "month", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.boolean "is_success", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_too_many_records", default: false, null: false
  end

  create_table "ok_assessor_accounts", force: :cascade do |t|
    t.text "account_num"
    t.bigint "parcel_num"
    t.text "account_type"
    t.integer "house_num"
    t.text "direction"
    t.text "street_name"
    t.text "street_suffix"
    t.text "unit"
    t.text "full_address"
    t.text "city"
    t.text "zipcode"
    t.text "business_name"
    t.integer "map_number"
    t.integer "buildings"
    t.text "full_legal"
    t.text "land_ecomonic_area_id"
    t.text "land_ecomonic_area_description"
    t.integer "subdivision_id"
    t.text "subdivision_description"
    t.decimal "land_total_acres"
    t.decimal "land_total_sq_foot"
    t.text "land_total_front_foot"
    t.text "land_total_units"
    t.decimal "land_width"
    t.decimal "land_depth"
    t.integer "vacant_land"
    t.text "platted_land"
    t.text "tax_district"
    t.decimal "total_mill_levy"
    t.integer "notice_of_valuation_value"
    t.integer "total_market_value"
    t.integer "total_taxable_value"
    t.integer "total_assessed_value"
    t.integer "adjusted_assessed_value"
    t.date "last_doc_date"
    t.date "last_sale_date"
    t.date "legal_change_date"
    t.date "account_created_date"
    t.date "account_deleted_date"
    t.text "status"
    t.integer "account_num_no_prefix"
    t.text "account_num_prefix"
    t.bigint "parent_parcel_num"
    t.text "subdivision_lot_number"
    t.text "subdivision_block_number"
    t.date "account_change_date"
    t.integer "adjustment_code"
    t.integer "adjustment_effective_year"
    t.index ["account_num"], name: "index_ok_assessor_accounts_on_account_num", unique: true
  end

  create_table "ok_assessor_improvement_details", force: :cascade do |t|
    t.bigint "improvement_id", null: false
    t.text "detail_type"
    t.text "detail_description"
    t.decimal "number_of_units"
    t.text "status"
    t.index ["improvement_id", "detail_type", "detail_description", "number_of_units"], name: "index_ok_ass_imp_details_on_imp_id_etc", unique: true
    t.index ["improvement_id"], name: "index_ok_assessor_improvement_details_on_improvement_id"
  end

  create_table "ok_assessor_improvements", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.integer "building_num"
    t.text "property_type"
    t.text "neighborhood_code"
    t.text "owner_occupied"
    t.text "occupancy_code"
    t.text "occupancy_description"
    t.text "building_type"
    t.integer "square_feet"
    t.text "condominium_square_feet"
    t.text "total_basement_square_feet"
    t.text "finished_basement_square_feet"
    t.text "garage_square_feet"
    t.text "carport_square_feet"
    t.text "balcony_square_feet"
    t.text "porch_square_feet"
    t.decimal "linear_feet_of_perimeter"
    t.integer "percent_complete"
    t.text "condition"
    t.text "quality"
    t.integer "heat_vent_air_id"
    t.text "heat_vent_air_description"
    t.text "exterior"
    t.text "interior"
    t.text "unit_type"
    t.decimal "number_of_stories"
    t.text "story_height"
    t.integer "square_feet_of_sprinkler_coverage"
    t.text "roof_type"
    t.text "roof_cover"
    t.text "floor_cover"
    t.text "foundation_type"
    t.integer "number_of_rooms"
    t.integer "number_of_bedrooms"
    t.integer "number_of_bathrooms"
    t.integer "number_of_units"
    t.text "type_of_construction_id"
    t.text "type_of_construction_description"
    t.integer "year_built"
    t.integer "year_remodeled"
    t.decimal "percent_remodeled"
    t.integer "adjusted_year_built"
    t.integer "age"
    t.text "mobilehome_title_number"
    t.text "mobilehome_serial_number"
    t.integer "mobilehome_length"
    t.integer "mobilehome_width"
    t.text "mobilehome_make"
    t.integer "improvement_value"
    t.text "new_construction_value_for_current_year"
    t.text "new_growth_value_for_current_year"
    t.integer "building_permit_value"
    t.text "status"
    t.index ["account_id", "building_num"], name: "index_ok_assessor_improvements_on_account_id_and_building_num", unique: true
    t.index ["account_id"], name: "index_ok_assessor_improvements_on_account_id"
  end

  create_table "ok_assessor_land_attributes", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.text "attribute_type"
    t.text "attribute_description"
    t.decimal "attribute_adjustment"
    t.text "status"
    t.index ["account_id", "attribute_description", "attribute_type"], name: "index_ok_asse_land_attr_on_acc_id_and_attr_desc_and_attr_type", unique: true
    t.index ["account_id"], name: "index_ok_assessor_land_attributes_on_account_id"
  end

  create_table "ok_assessor_owners", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.text "owner1"
    t.text "owner2"
    t.text "owner3"
    t.text "mailing_address1"
    t.text "mailing_address2"
    t.text "mailing_address3"
    t.text "mailing_city"
    t.text "mailing_state"
    t.text "mailing_zipcode"
    t.integer "primary_owner"
    t.text "status"
    t.date "owner_change_date"
    t.date "address_change_date"
    t.index ["account_id"], name: "index_ok_assessor_owners_on_account_id", unique: true
  end

  create_table "ok_assessor_sales", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.decimal "reception_number"
    t.text "grantor"
    t.text "grantee"
    t.integer "sale_price"
    t.date "sale_date"
    t.text "deed_type"
    t.text "valid_sale"
    t.text "confirm"
    t.integer "book"
    t.integer "page"
    t.decimal "revenue_stamps"
    t.date "change_date"
    t.index ["account_id", "reception_number"], name: "index_ok_assessor_sales_on_account_id_and_reception_number", unique: true
    t.index ["account_id"], name: "index_ok_assessor_sales_on_account_id"
  end

  create_table "ok_assessor_section_township_ranges", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.text "quarter"
    t.integer "section"
    t.text "township"
    t.text "range"
    t.index ["account_id"], name: "index_ok_assessor_section_township_ranges_on_account_id", unique: true
  end

  create_table "ok_assessor_value_details", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.text "value_type"
    t.text "abstract_code"
    t.text "abstract_code_description"
    t.decimal "abstract_acres"
    t.integer "abstract_square_feet"
    t.integer "abstract_units"
    t.text "tax_district"
    t.integer "abstract_assessed_value"
    t.integer "abstract_account_value"
    t.text "status"
    t.index ["account_id", "value_type"], name: "index_ok_assessor_value_details_on_account_id_and_value_type", unique: true
    t.index ["account_id"], name: "index_ok_assessor_value_details_on_account_id"
  end

  create_table "ok_county_jail_bookings", force: :cascade do |t|
    t.string "booking_number"
    t.string "full_name"
    t.date "dob"
    t.datetime "booked_at"
    t.integer "height_in"
    t.integer "weight"
    t.string "eyes"
    t.string "hair_color"
    t.string "hair_length"
    t.string "skin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ok_county_jail_offenses", force: :cascade do |t|
    t.bigint "ok_county_jail_bookings_id", null: false
    t.string "code"
    t.string "description"
    t.string "case_number"
    t.string "bond"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ok_county_jail_bookings_id"], name: "index_ok_county_jail_offenses_on_ok_county_jail_bookings_id"
  end

  create_table "ok_election_precincts", force: :cascade do |t|
    t.bigint "county_id", null: false
    t.integer "code", null: false
    t.integer "congressional_district", null: false
    t.integer "state_senate_district", null: false
    t.integer "state_house_district", null: false
    t.integer "county_commissioner", null: false
    t.string "poll_site"
    t.string "poll_site_address"
    t.string "poll_site_address2"
    t.string "poll_site_city"
    t.string "poll_site_zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_ok_election_precincts_on_code", unique: true
    t.index ["county_id"], name: "index_ok_election_precincts_on_county_id"
  end

  create_table "ok_election_voters", force: :cascade do |t|
    t.bigint "precinct_id", null: false
    t.string "last_name"
    t.string "first_name"
    t.string "middle_name"
    t.string "suffix"
    t.integer "voter_id", null: false
    t.integer "political_affiliation", null: false
    t.integer "status", null: false
    t.string "street_number"
    t.string "street_direction"
    t.string "street_name"
    t.string "street_type"
    t.string "building_number"
    t.string "city"
    t.string "zip_code"
    t.datetime "date_of_birth"
    t.datetime "original_registration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["precinct_id"], name: "index_ok_election_voters_on_precinct_id"
    t.index ["voter_id"], name: "index_ok_election_voters_on_voter_id", unique: true
  end

  create_table "ok_election_votes", force: :cascade do |t|
    t.bigint "voter_id", null: false
    t.datetime "election_on"
    t.bigint "voting_method_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["voter_id", "election_on"], name: "index_ok_election_votes_on_voter_id_and_election_on", unique: true
    t.index ["voter_id"], name: "index_ok_election_votes_on_voter_id"
    t.index ["voting_method_id"], name: "index_ok_election_votes_on_voting_method_id"
  end

  create_table "ok_election_voting_methods", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_ok_election_voting_methods_on_code", unique: true
  end

  create_table "ok_real_estate_agents", force: :cascade do |t|
    t.string "external_id", null: false
    t.string "first_name", null: false
    t.string "last_name"
    t.string "middle_name"
    t.string "other_name"
    t.integer "license_number", null: false
    t.string "license_category", null: false
    t.string "license_status", null: false
    t.date "initial_license_on"
    t.date "license_expiration_on"
    t.boolean "has_public_notices", default: false, null: false
    t.datetime "scraped_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_ok_real_estate_agents_on_external_id", unique: true
  end

  create_table "ok_real_estate_places", force: :cascade do |t|
    t.string "external_id", null: false
    t.bigint "agent_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.boolean "primary", default: false, null: false
    t.string "registrant"
    t.string "phone"
    t.string "position"
    t.string "email"
    t.boolean "active", default: false, null: false
    t.string "employer_name"
    t.string "business_address"
    t.string "business_city"
    t.string "business_state"
    t.string "business_zip_code"
    t.string "organization"
    t.boolean "is_branch_office", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_id"], name: "index_ok_real_estate_places_on_agent_id"
    t.index ["external_id"], name: "index_ok_real_estate_places_on_external_id", unique: true
  end

  create_table "ok_real_estate_registration_histories", force: :cascade do |t|
    t.string "external_id", null: false
    t.bigint "agent_id", null: false
    t.string "license_category"
    t.string "status"
    t.date "effective_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_id"], name: "index_ok_real_estate_registration_histories_on_agent_id"
    t.index ["external_id"], name: "index_ok_real_estate_registration_histories_on_external_id", unique: true
  end

  create_table "ok_real_estate_registration_records", force: :cascade do |t|
    t.string "external_id", null: false
    t.bigint "agent_id", null: false
    t.integer "license_number"
    t.string "license_category"
    t.string "status"
    t.date "effective_on"
    t.date "initial_registration_on"
    t.date "expiry_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_id"], name: "index_ok_real_estate_registration_records_on_agent_id"
    t.index ["external_id"], name: "index_ok_real_estate_registration_records_on_external_id", unique: true
  end

  create_table "ok_sos_agents", force: :cascade do |t|
    t.bigint "filing_number", null: false
    t.bigint "external_address_id"
    t.string "business_name"
    t.string "agent_last_name"
    t.string "agent_first_name"
    t.string "agent_middle_name"
    t.string "agent_suffix_id"
    t.datetime "creation_date"
    t.datetime "inactive_date"
    t.string "normalized_name"
    t.integer "sos_ra_flag"
    t.bigint "suffix_id"
    t.bigint "entity_address_id"
    t.bigint "entity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_address_id"], name: "index_ok_sos_agents_on_entity_address_id"
    t.index ["entity_id"], name: "index_ok_sos_agents_on_entity_id"
    t.index ["filing_number"], name: "index_ok_sos_agents_on_filing_number", unique: true
    t.index ["suffix_id"], name: "index_ok_sos_agents_on_suffix_id"
  end

  create_table "ok_sos_associated_entities", force: :cascade do |t|
    t.bigint "filing_number"
    t.bigint "document_number"
    t.bigint "associated_entity_id"
    t.bigint "associated_entity_corp_type_id"
    t.bigint "primary_capacity_id"
    t.bigint "external_capacity_id"
    t.string "associated_entity_name"
    t.bigint "entity_filing_number"
    t.datetime "entity_filing_date"
    t.datetime "inactive_date"
    t.string "jurisdiction_state"
    t.string "jurisdiction_country"
    t.bigint "capacity_id", null: false
    t.bigint "corp_type_id"
    t.bigint "entity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["capacity_id"], name: "index_ok_sos_associated_entities_on_capacity_id"
    t.index ["corp_type_id"], name: "index_ok_sos_associated_entities_on_corp_type_id"
    t.index ["entity_id"], name: "index_ok_sos_associated_entities_on_entity_id"
    t.index ["filing_number", "associated_entity_id"], name: "index_ok_sos_ass_entities_on_filing_number_and_ass_entity_id", unique: true
  end

  create_table "ok_sos_audit_logs", force: :cascade do |t|
    t.string "reference_number", null: false
    t.datetime "audit_date"
    t.integer "table_id"
    t.integer "field_id"
    t.string "previous_value"
    t.string "current_value"
    t.string "action"
    t.string "audit_comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reference_number", "audit_date", "table_id", "field_id", "previous_value", "current_value", "action"], name: "index_sos_audit_logs_cols", unique: true
  end

  create_table "ok_sos_capacities", force: :cascade do |t|
    t.integer "capacity_id", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["capacity_id"], name: "index_ok_sos_capacities_on_capacity_id", unique: true
  end

  create_table "ok_sos_corp_filings", force: :cascade do |t|
    t.bigint "filing_number"
    t.bigint "document_number"
    t.bigint "external_filing_type_id"
    t.string "external_filing_type"
    t.datetime "entry_date"
    t.datetime "filing_date"
    t.datetime "effective_date"
    t.integer "effective_cond_flag"
    t.datetime "inactive_date"
    t.bigint "filing_type_id"
    t.bigint "entity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_ok_sos_corp_filings_on_entity_id"
    t.index ["filing_number", "document_number"], name: "index_ok_sos_corp_filings_on_filing_number_and_document_number", unique: true
    t.index ["filing_type_id"], name: "index_ok_sos_corp_filings_on_filing_type_id"
  end

  create_table "ok_sos_corp_statuses", force: :cascade do |t|
    t.integer "status_id", null: false
    t.string "status_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status_id"], name: "index_ok_sos_corp_statuses_on_status_id", unique: true
  end

  create_table "ok_sos_corp_types", force: :cascade do |t|
    t.integer "corp_type_id", null: false
    t.string "corp_type_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["corp_type_id"], name: "index_ok_sos_corp_types_on_corp_type_id", unique: true
  end

  create_table "ok_sos_entities", force: :cascade do |t|
    t.bigint "filing_number", null: false
    t.bigint "status_id"
    t.bigint "external_corp_type_id", null: false
    t.bigint "external_address_id"
    t.string "name"
    t.integer "perpetual_flag"
    t.datetime "creation_date"
    t.datetime "expiration_date"
    t.datetime "inactive_date"
    t.datetime "formation_date"
    t.datetime "report_due_date"
    t.integer "tax_id"
    t.string "fictitious_name"
    t.datetime "foreign_fein"
    t.string "foreign_state"
    t.string "foreign_country"
    t.datetime "foreign_formation_date"
    t.string "expiration_type"
    t.datetime "last_report_filed_date"
    t.string "telno"
    t.integer "otc_suspension_flag"
    t.string "consent_name_flag"
    t.bigint "corp_type_id", null: false
    t.bigint "entity_address_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["corp_type_id"], name: "index_ok_sos_entities_on_corp_type_id"
    t.index ["entity_address_id"], name: "index_ok_sos_entities_on_entity_address_id"
    t.index ["filing_number"], name: "index_ok_sos_entities_on_filing_number", unique: true
  end

  create_table "ok_sos_entity_addresses", force: :cascade do |t|
    t.bigint "address_id", null: false
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "zip_string"
    t.integer "zip_extension"
    t.string "country"
    t.bigint "zip_code_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_ok_sos_entity_addresses_on_address_id", unique: true
    t.index ["zip_code_id"], name: "index_ok_sos_entity_addresses_on_zip_code_id"
  end

  create_table "ok_sos_filing_types", force: :cascade do |t|
    t.integer "filing_type_id", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["filing_type_id"], name: "index_ok_sos_filing_types_on_filing_type_id", unique: true
  end

  create_table "ok_sos_name_statuses", force: :cascade do |t|
    t.integer "name_status_id", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_status_id"], name: "index_ok_sos_name_statuses_on_name_status_id", unique: true
  end

  create_table "ok_sos_name_types", force: :cascade do |t|
    t.integer "name_type_id", null: false
    t.string "name_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_type_id"], name: "index_ok_sos_name_types_on_name_type_id", unique: true
  end

  create_table "ok_sos_names", force: :cascade do |t|
    t.bigint "filing_number"
    t.bigint "name_id", null: false
    t.string "name"
    t.bigint "external_name_status_id"
    t.bigint "external_name_type_id"
    t.datetime "creation_date"
    t.datetime "inactive_date"
    t.datetime "expire_date"
    t.string "all_counties_flag"
    t.bigint "consent_filing_number"
    t.bigint "search_id"
    t.string "transfer_to"
    t.string "received_from"
    t.bigint "name_type_id"
    t.bigint "name_status_id"
    t.bigint "entity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_ok_sos_names_on_entity_id"
    t.index ["filing_number", "name_id"], name: "index_ok_sos_names_on_filing_number_and_name_id", unique: true
    t.index ["name_status_id"], name: "index_ok_sos_names_on_name_status_id"
    t.index ["name_type_id"], name: "index_ok_sos_names_on_name_type_id"
  end

  create_table "ok_sos_officers", force: :cascade do |t|
    t.bigint "filing_number"
    t.integer "officer_id", null: false
    t.string "officer_title"
    t.string "business_name"
    t.string "last_name"
    t.string "first_name"
    t.string "middle_name"
    t.bigint "external_suffix_id"
    t.bigint "external_address_id"
    t.datetime "creation_date"
    t.datetime "inactive_date"
    t.datetime "last_modified_date"
    t.string "normalized_name"
    t.bigint "entity_address_id"
    t.bigint "entity_id"
    t.bigint "suffix_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_address_id"], name: "index_ok_sos_officers_on_entity_address_id"
    t.index ["entity_id"], name: "index_ok_sos_officers_on_entity_id"
    t.index ["filing_number", "officer_id"], name: "index_ok_sos_officers_on_filing_number_and_officer_id", unique: true
    t.index ["suffix_id"], name: "index_ok_sos_officers_on_suffix_id"
  end

  create_table "ok_sos_stock_data", force: :cascade do |t|
    t.integer "stock_id", null: false
    t.bigint "filing_number"
    t.integer "external_stock_type_id", null: false
    t.integer "stock_series"
    t.float "share_volume"
    t.float "par_value"
    t.bigint "entity_id"
    t.bigint "stock_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_ok_sos_stock_data_on_entity_id"
    t.index ["filing_number", "stock_id"], name: "index_ok_sos_stock_data_on_filing_number_and_stock_id", unique: true
    t.index ["stock_type_id"], name: "index_ok_sos_stock_data_on_stock_type_id"
  end

  create_table "ok_sos_stock_infos", force: :cascade do |t|
    t.bigint "filing_number", null: false
    t.integer "qualify_flag"
    t.integer "unlimited_flag"
    t.float "actual_amount_invested"
    t.float "pd_on_credit"
    t.float "tot_auth_capital"
    t.bigint "entity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_ok_sos_stock_infos_on_entity_id"
    t.index ["filing_number"], name: "index_ok_sos_stock_infos_on_filing_number", unique: true
  end

  create_table "ok_sos_stock_types", force: :cascade do |t|
    t.integer "stock_type_id", null: false
    t.string "stock_type_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_type_id"], name: "index_ok_sos_stock_types_on_stock_type_id", unique: true
  end

  create_table "ok_sos_suffixes", force: :cascade do |t|
    t.integer "suffix_id", null: false
    t.string "suffix"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["suffix_id"], name: "index_ok_sos_suffixes_on_suffix_id", unique: true
  end

  create_table "okc_blotter_bookings", force: :cascade do |t|
    t.bigint "pdf_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.date "dob"
    t.string "sex"
    t.string "race"
    t.string "zip"
    t.boolean "transient", default: false, null: false
    t.string "inmate_number", null: false
    t.string "booking_number", null: false
    t.string "booking_type"
    t.datetime "booking_date", null: false
    t.datetime "release_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "roster_id"
    t.index ["pdf_id"], name: "index_okc_blotter_bookings_on_pdf_id"
    t.index ["roster_id"], name: "index_okc_blotter_bookings_on_roster_id"
  end

  create_table "okc_blotter_offenses", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.string "type", null: false
    t.decimal "bond", precision: 10, scale: 2
    t.string "code"
    t.string "dispo"
    t.string "charge", null: false
    t.string "warrant_number"
    t.string "citation_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_okc_blotter_offenses_on_booking_id"
  end

  create_table "okc_blotter_pdfs", force: :cascade do |t|
    t.datetime "parsed_on"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oklahoma_statutes", force: :cascade do |t|
    t.string "code"
    t.string "ten_digit"
    t.string "severity"
    t.text "description"
    t.date "effective_on"
    t.string "update_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parent_parties", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parties", force: :cascade do |t|
    t.integer "oscn_id"
    t.string "full_name"
    t.bigint "party_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.integer "birth_month"
    t.integer "birth_year"
    t.string "suffix"
    t.bigint "parent_party_id"
    t.boolean "enqueued", default: false
    t.index ["oscn_id"], name: "index_parties_on_oscn_id", unique: true
    t.index ["parent_party_id"], name: "index_parties_on_parent_party_id"
    t.index ["party_type_id"], name: "index_parties_on_party_type_id"
  end

  create_table "party_addresses", force: :cascade do |t|
    t.bigint "party_id", null: false
    t.datetime "record_on", precision: nil
    t.string "city"
    t.string "state"
    t.integer "zip"
    t.string "address_type"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["party_id"], name: "index_party_addresses_on_party_id"
  end

  create_table "party_aliases", force: :cascade do |t|
    t.bigint "party_id", null: false
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["party_id"], name: "index_party_aliases_on_party_id"
  end

  create_table "party_htmls", force: :cascade do |t|
    t.bigint "party_id", null: false
    t.datetime "scraped_at", precision: nil
    t.text "html"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["party_id"], name: "index_party_htmls_on_party_id"
  end

  create_table "party_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_party_types_on_name", unique: true
  end

  create_table "pleas", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_pleas_on_name", unique: true
  end

  create_table "rosters", force: :cascade do |t|
    t.string "birth_year"
    t.string "birth_month"
    t.string "birth_day"
    t.string "sex"
    t.string "race"
    t.string "street_address"
    t.integer "zip"
    t.string "first_name"
    t.string "last_name"
    t.string "middle_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "structure_fire_links", force: :cascade do |t|
    t.string "external_url", null: false
    t.date "pdf_date_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
  end

  create_table "structure_fires", force: :cascade do |t|
    t.integer "incident_number", null: false
    t.string "incident_type", null: false
    t.string "station", null: false
    t.date "incident_date", null: false
    t.integer "street_number", null: false
    t.string "street_prefix", default: "", null: false
    t.string "street_name", default: "", null: false
    t.string "street_type", default: "", null: false
    t.decimal "property_value"
    t.decimal "property_loss"
    t.decimal "content_value"
    t.decimal "content_loss"
    t.bigint "structure_fire_link_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["structure_fire_link_id"], name: "index_structure_fires_on_structure_fire_link_id"
  end

  create_table "titles", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tulsa_blotter_arrest_details_htmls", force: :cascade do |t|
    t.bigint "arrest_id"
    t.datetime "scraped_at", precision: nil, null: false
    t.text "html"
    t.index ["arrest_id"], name: "index_tulsa_blotter_arrest_details_htmls_on_arrest_id"
  end

  create_table "tulsa_blotter_arrests", force: :cascade do |t|
    t.string "dlm"
    t.string "first"
    t.string "middle"
    t.string "last"
    t.string "gender"
    t.bigint "roster_id"
    t.string "booking_id", null: false
    t.string "race"
    t.string "address"
    t.string "height"
    t.integer "weight"
    t.string "city_state_zip"
    t.string "hair"
    t.string "eyes"
    t.date "last_scraped_at"
    t.datetime "arrest_date", precision: nil
    t.string "arrested_by"
    t.string "arresting_agency"
    t.datetime "booking_date", precision: nil
    t.datetime "release_date", precision: nil
    t.date "freedom_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["roster_id"], name: "index_tulsa_blotter_arrests_on_roster_id"
  end

  create_table "tulsa_blotter_arrests_page_htmls", force: :cascade do |t|
    t.bigint "page_html_id"
    t.bigint "arrest_id"
    t.index ["arrest_id"], name: "index_tulsa_blotter_arrests_page_htmls_on_arrest_id"
    t.index ["page_html_id"], name: "index_tulsa_blotter_arrests_page_htmls_on_page_html_id"
  end

  create_table "tulsa_blotter_offenses", force: :cascade do |t|
    t.string "description"
    t.string "case_number"
    t.string "bond_type"
    t.string "disposition"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "arrests_id"
    t.decimal "bond_amount", precision: 14, scale: 2
    t.date "court_date"
    t.index ["arrests_id"], name: "index_tulsa_blotter_offenses_on_arrests_id"
  end

  create_table "tulsa_blotter_page_htmls", force: :cascade do |t|
    t.integer "page_number", null: false
    t.datetime "scraped_at", precision: nil, null: false
    t.text "html"
  end

  create_table "tulsa_city_inmates", force: :cascade do |t|
    t.string "inmate_id"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.date "dob"
    t.string "height"
    t.string "weight"
    t.string "hair_color"
    t.string "eye_color"
    t.string "race"
    t.string "gender"
    t.datetime "arrest_date", precision: nil
    t.string "arresting_officer"
    t.string "arresting_agency"
    t.datetime "booking_date_time", precision: nil
    t.date "court_date"
    t.datetime "released_date_time", precision: nil
    t.string "court_division"
    t.string "incident_record_id"
    t.string "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["incident_record_id"], name: "index_tulsa_city_inmates_on_incident_record_id", unique: true
  end

  create_table "tulsa_city_offenses", force: :cascade do |t|
    t.bigint "inmate_id"
    t.string "bond"
    t.datetime "court_date", precision: nil
    t.string "case_number"
    t.string "court_division"
    t.string "hold"
    t.string "docket_id"
    t.string "title"
    t.string "section"
    t.string "paragraph"
    t.string "crime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["docket_id", "inmate_id"], name: "index_tulsa_city_offenses_on_docket_id_and_inmate_id", unique: true
    t.index ["inmate_id"], name: "index_tulsa_city_offenses_on_inmate_id"
  end

  create_table "verdicts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_verdicts_on_name", unique: true
  end

  create_table "zip_codes", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_zip_codes_on_name", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "case_htmls", "court_cases"
  add_foreign_key "case_not_founds", "counties"
  add_foreign_key "case_parties", "court_cases"
  add_foreign_key "case_parties", "parties"
  add_foreign_key "case_parties", "rosters"
  add_foreign_key "census_data", "census_statistics", column: "statistic_id"
  add_foreign_key "census_statistics", "census_surveys", column: "survey_id"
  add_foreign_key "counsel_parties", "counsels"
  add_foreign_key "counsel_parties", "court_cases"
  add_foreign_key "counsel_parties", "parties"
  add_foreign_key "counts", "count_codes", column: "disposed_statute_code_id"
  add_foreign_key "counts", "count_codes", column: "filed_statute_code_id"
  add_foreign_key "counts", "court_cases"
  add_foreign_key "counts", "parties"
  add_foreign_key "counts", "pleas"
  add_foreign_key "counts", "verdicts"
  add_foreign_key "court_cases", "case_types"
  add_foreign_key "court_cases", "counties"
  add_foreign_key "court_cases", "judges", column: "current_judge_id"
  add_foreign_key "doc_aliases", "doc_profiles"
  add_foreign_key "doc_profiles", "doc_facilities"
  add_foreign_key "doc_profiles", "rosters"
  add_foreign_key "doc_sentences", "court_cases"
  add_foreign_key "doc_sentences", "doc_offense_codes"
  add_foreign_key "doc_sentences", "doc_profiles"
  add_foreign_key "doc_sentencing_counties", "counties"
  add_foreign_key "doc_statuses", "doc_facilities"
  add_foreign_key "doc_statuses", "doc_profiles"
  add_foreign_key "docket_event_links", "docket_events"
  add_foreign_key "docket_events", "court_cases"
  add_foreign_key "docket_events", "docket_event_types"
  add_foreign_key "docket_events", "parties"
  add_foreign_key "events", "court_cases"
  add_foreign_key "events", "event_types"
  add_foreign_key "events", "parties"
  add_foreign_key "eviction_letters", "docket_event_links"
  add_foreign_key "eviction_letters", "eviction_files"
  add_foreign_key "issue_parties", "issues"
  add_foreign_key "issue_parties", "parties"
  add_foreign_key "issue_parties", "verdicts"
  add_foreign_key "issues", "count_codes"
  add_foreign_key "issues", "court_cases"
  add_foreign_key "judges", "counties"
  add_foreign_key "ok2_explore_deaths", "counties"
  add_foreign_key "ok_assessor_improvement_details", "ok_assessor_improvements", column: "improvement_id"
  add_foreign_key "ok_assessor_improvements", "ok_assessor_accounts", column: "account_id"
  add_foreign_key "ok_assessor_land_attributes", "ok_assessor_accounts", column: "account_id"
  add_foreign_key "ok_assessor_owners", "ok_assessor_accounts", column: "account_id"
  add_foreign_key "ok_assessor_sales", "ok_assessor_accounts", column: "account_id"
  add_foreign_key "ok_assessor_section_township_ranges", "ok_assessor_accounts", column: "account_id"
  add_foreign_key "ok_assessor_value_details", "ok_assessor_accounts", column: "account_id"
  add_foreign_key "ok_county_jail_offenses", "ok_county_jail_bookings", column: "ok_county_jail_bookings_id"
  add_foreign_key "ok_election_precincts", "counties"
  add_foreign_key "ok_election_voters", "ok_election_precincts", column: "precinct_id"
  add_foreign_key "ok_election_votes", "ok_election_voters", column: "voter_id"
  add_foreign_key "ok_election_votes", "ok_election_voting_methods", column: "voting_method_id"
  add_foreign_key "ok_real_estate_places", "ok_real_estate_agents", column: "agent_id"
  add_foreign_key "ok_real_estate_registration_histories", "ok_real_estate_agents", column: "agent_id"
  add_foreign_key "ok_real_estate_registration_records", "ok_real_estate_agents", column: "agent_id"
  add_foreign_key "ok_sos_agents", "ok_sos_entities", column: "entity_id"
  add_foreign_key "ok_sos_agents", "ok_sos_entity_addresses", column: "entity_address_id"
  add_foreign_key "ok_sos_agents", "ok_sos_suffixes", column: "suffix_id"
  add_foreign_key "ok_sos_associated_entities", "ok_sos_capacities", column: "capacity_id"
  add_foreign_key "ok_sos_associated_entities", "ok_sos_corp_types", column: "corp_type_id"
  add_foreign_key "ok_sos_associated_entities", "ok_sos_entities", column: "entity_id"
  add_foreign_key "ok_sos_corp_filings", "ok_sos_entities", column: "entity_id"
  add_foreign_key "ok_sos_corp_filings", "ok_sos_filing_types", column: "filing_type_id"
  add_foreign_key "okc_blotter_bookings", "okc_blotter_pdfs", column: "pdf_id"
  add_foreign_key "okc_blotter_bookings", "rosters"
  add_foreign_key "okc_blotter_offenses", "okc_blotter_bookings", column: "booking_id"
  add_foreign_key "parties", "parent_parties"
  add_foreign_key "parties", "party_types"
  add_foreign_key "party_addresses", "parties"
  add_foreign_key "party_aliases", "parties"
  add_foreign_key "party_htmls", "parties"
  add_foreign_key "structure_fires", "structure_fire_links"
  add_foreign_key "tulsa_blotter_arrest_details_htmls", "tulsa_blotter_arrests", column: "arrest_id"
  add_foreign_key "tulsa_blotter_arrests", "rosters"
  add_foreign_key "tulsa_blotter_arrests_page_htmls", "tulsa_blotter_arrests", column: "arrest_id"
  add_foreign_key "tulsa_blotter_arrests_page_htmls", "tulsa_blotter_page_htmls", column: "page_html_id"
  add_foreign_key "tulsa_blotter_offenses", "tulsa_blotter_arrests", column: "arrests_id"
  add_foreign_key "tulsa_city_offenses", "tulsa_city_inmates", column: "inmate_id"

  create_view "payments", sql_definition: <<-SQL
      SELECT court_cases.id AS court_case_id,
      docket_events.party_id,
      sum(docket_events.amount) AS total,
      sum(docket_events.payment) AS payment,
      sum(docket_events.adjustment) AS adjustment,
      ((sum(docket_events.amount) - sum(docket_events.adjustment)) - sum(docket_events.payment)) AS owed
     FROM (((docket_events
       JOIN court_cases ON ((court_cases.id = docket_events.court_case_id)))
       JOIN parties ON ((docket_events.party_id = parties.id)))
       JOIN party_types ON ((parties.party_type_id = party_types.id)))
    WHERE ((party_types.name)::text = 'defendant'::text)
    GROUP BY docket_events.party_id, court_cases.id;
  SQL
  create_view "party_stats", materialized: true, sql_definition: <<-SQL
      SELECT parties.id AS party_id,
      ( SELECT count(*) AS count
             FROM case_parties
            WHERE (case_parties.party_id = parties.id)) AS cases_count,
      ( SELECT count(*) AS count
             FROM ((case_parties
               JOIN court_cases ON ((case_parties.court_case_id = court_cases.id)))
               JOIN case_types ON ((case_types.id = court_cases.case_type_id)))
            WHERE ((case_parties.party_id = parties.id) AND ((case_types.abbreviation)::text = 'CF'::text))) AS cf_count,
      ( SELECT count(*) AS count
             FROM ((case_parties
               JOIN court_cases ON ((case_parties.court_case_id = court_cases.id)))
               JOIN case_types ON ((case_types.id = court_cases.case_type_id)))
            WHERE ((case_parties.party_id = parties.id) AND ((case_types.abbreviation)::text = 'CM'::text))) AS cm_count,
      ( SELECT count(*) AS count
             FROM (docket_events
               JOIN docket_event_types ON ((docket_events.docket_event_type_id = docket_event_types.id)))
            WHERE ((docket_events.party_id = parties.id) AND ((docket_event_types.code)::text = ANY ((ARRAY['WAI$'::character varying, 'BWIFAP'::character varying, 'BWIFA'::character varying, 'BWIFC'::character varying, 'BWIAR'::character varying, 'BWIAA'::character varying, 'BWICA'::character varying, 'BWIFAR'::character varying, 'BWIFAA'::character varying, 'BWIFP'::character varying, 'BWIMW'::character varying, 'BWIR8'::character varying, 'BWIS'::character varying, 'BWIS$'::character varying, 'WAI'::character varying, 'WAIMV'::character varying, 'WAIMW'::character varying, 'BWIFAR'::character varying])::text[])))) AS warrants_count,
      ( SELECT sum(docket_events.amount) AS sum
             FROM docket_events
            WHERE (docket_events.party_id = parties.id)) AS total_fined,
      ( SELECT sum(docket_events.payment) AS sum
             FROM docket_events
            WHERE (docket_events.party_id = parties.id)) AS total_paid,
      ( SELECT sum(docket_events.adjustment) AS sum
             FROM docket_events
            WHERE (docket_events.party_id = parties.id)) AS total_adjusted,
      ((( SELECT sum(docket_events.amount) AS sum
             FROM docket_events
            WHERE (docket_events.party_id = parties.id)) - ( SELECT sum(docket_events.payment) AS sum
             FROM docket_events
            WHERE (docket_events.party_id = parties.id))) - ( SELECT sum(docket_events.adjustment) AS sum
             FROM docket_events
            WHERE (docket_events.party_id = parties.id))) AS account_balance
     FROM (parties
       JOIN party_types ON ((parties.party_type_id = party_types.id)))
    WHERE ((party_types.name)::text = 'defendant'::text);
  SQL
  add_index "party_stats", ["party_id"], name: "index_party_stats_on_party_id"

  create_view "case_stats", materialized: true, sql_definition: <<-SQL
      SELECT court_cases.id AS court_case_id,
      (court_cases.closed_on - court_cases.filed_on) AS length_of_case_in_days,
      ( SELECT count(*) AS count
             FROM counts
            WHERE (court_cases.id = counts.court_case_id)) AS counts_count,
      ( SELECT count(*) AS count
             FROM ((case_parties
               JOIN parties ON ((case_parties.party_id = parties.id)))
               JOIN party_types ON ((parties.party_type_id = party_types.id)))
            WHERE ((court_cases.id = case_parties.court_case_id) AND ((party_types.name)::text = 'defendant'::text))) AS defendant_count,
          CASE
              WHEN (( SELECT count(*) AS count
                 FROM (docket_events
                   JOIN docket_event_types ON ((docket_events.docket_event_type_id = docket_event_types.id)))
                WHERE ((docket_events.court_case_id = court_cases.id) AND ((docket_event_types.code)::text = 'CTRS'::text))) > 0) THEN true
              ELSE false
          END AS is_tax_intercepted,
      ( SELECT count(*) AS count
             FROM (docket_events
               JOIN docket_event_types ON ((docket_events.docket_event_type_id = docket_event_types.id)))
            WHERE ((docket_events.court_case_id = court_cases.id) AND ((docket_event_types.code)::text = ANY ((ARRAY['WAI$'::character varying, 'BWIFAP'::character varying, 'BWIFA'::character varying, 'BWIFC'::character varying, 'BWIAR'::character varying, 'BWIAA'::character varying, 'BWICA'::character varying, 'BWIFAR'::character varying, 'BWIFAA'::character varying, 'BWIFP'::character varying, 'BWIMW'::character varying, 'BWIR8'::character varying, 'BWIS'::character varying, 'BWIS$'::character varying, 'WAI'::character varying, 'WAIMV'::character varying, 'WAIMW'::character varying, 'BWIFAR'::character varying])::text[])))) AS warrants_count
     FROM court_cases;
  SQL
  add_index "case_stats", ["court_case_id"], name: "index_case_stats_on_court_case_id"

  create_view "report_arresting_agencies", materialized: true, sql_definition: <<-SQL
      SELECT court_cases.id AS court_case_id,
      court_cases.county_id,
      court_cases.case_number,
      a.parent_party_id AS arresting_agency_id,
          CASE
              WHEN (a.parent_parties_name IS NULL) THEN 'NOT PROVIDED'::character varying
              ELSE a.parent_parties_name
          END AS arresting_agency,
      case_types.abbreviation AS case_type,
      court_cases.filed_on,
      COALESCE(counts.as_filed, 'No Charges Filed'::character varying) AS charges_as_filed,
      COALESCE(counts.filed_statute_violation, 'No Charges Filed'::character varying) AS filed_statute_violation,
      ( SELECT (regexp_matches(split_part((counts.filed_statute_violation)::text, 'O.S.'::text, 1), '[0-9]{2}[A-Z]?'::text))[1] AS title_code
             FROM counts c2
            WHERE ((counts.court_case_id = court_cases.id) AND (counts.id = c2.id))) AS title_code
     FROM (((court_cases
       LEFT JOIN ( SELECT case_parties.court_case_id,
              parent_parties.id AS parent_party_id,
              parent_parties.name AS parent_parties_name
             FROM (((case_parties
               JOIN parties ON ((case_parties.party_id = parties.id)))
               JOIN party_types ON ((parties.party_type_id = party_types.id)))
               JOIN parent_parties ON ((parties.parent_party_id = parent_parties.id)))
            WHERE ((party_types.name)::text = 'arresting agency'::text)) a ON ((court_cases.id = a.court_case_id)))
       LEFT JOIN case_types ON ((court_cases.case_type_id = case_types.id)))
       LEFT JOIN counts ON ((counts.court_case_id = court_cases.id)))
    WHERE ((case_types.abbreviation)::text <> 'CPC'::text);
  SQL
  add_index "report_arresting_agencies", ["arresting_agency_id"], name: "index_report_arresting_agencies_on_arresting_agency_id"
  add_index "report_arresting_agencies", ["filed_on"], name: "index_report_arresting_agencies_on_filed_on"
  add_index "report_arresting_agencies", ["title_code"], name: "index_report_arresting_agencies_on_title_code"

  create_view "report_fines_and_fees", materialized: true, sql_definition: <<-SQL
      SELECT court_cases.id AS court_case_id,
      court_cases.county_id,
      case_types.id AS case_type_id,
      docket_event_types.id AS docket_event_types_id,
      docket_events.event_on,
      docket_events.amount,
      docket_events.payment,
      docket_events.adjustment,
          CASE
              WHEN (( SELECT count(*) AS count
                 FROM (docket_events docket_events_1
                   JOIN docket_event_types docket_event_types_1 ON ((docket_events_1.docket_event_type_id = docket_event_types_1.id)))
                WHERE ((docket_events_1.court_case_id = court_cases.id) AND ((docket_event_types_1.code)::text = 'CTRS'::text))) > 0) THEN true
              ELSE false
          END AS is_tax_intercepted
     FROM (((docket_events
       JOIN docket_event_types ON ((docket_event_types.id = docket_events.docket_event_type_id)))
       JOIN court_cases ON ((court_cases.id = docket_events.court_case_id)))
       JOIN case_types ON ((court_cases.case_type_id = case_types.id)))
    WHERE ((docket_events.amount <> (0)::numeric) OR (docket_events.adjustment <> (0)::numeric) OR (docket_events.payment <> (0)::numeric));
  SQL
  add_index "report_fines_and_fees", ["case_type_id"], name: "index_report_fines_and_fees_on_case_type_id"
  add_index "report_fines_and_fees", ["court_case_id"], name: "index_report_fines_and_fees_on_court_case_id"
  add_index "report_fines_and_fees", ["docket_event_types_id"], name: "index_report_fines_and_fees_on_docket_event_types_id"
  add_index "report_fines_and_fees", ["event_on"], name: "index_report_fines_and_fees_on_event_on"

  create_view "report_evictions", sql_definition: <<-SQL
      SELECT court_cases.id AS court_case_id,
      court_cases.filed_on AS case_filed_on,
      court_cases.closed_on AS case_closed_on,
      court_cases.case_number,
      ( SELECT string_agg((parties.full_name)::text, '; '::text) AS string_agg
             FROM ((parties
               JOIN case_parties ON ((case_parties.party_id = parties.id)))
               JOIN party_types ON ((parties.party_type_id = party_types.id)))
            WHERE ((case_parties.court_case_id = court_cases.id) AND ((party_types.name)::text = 'defendant'::text))) AS defendant_name,
      ( SELECT count(DISTINCT verdicts.id) AS count
             FROM ((issue_parties
               JOIN verdicts ON ((verdicts.id = issue_parties.verdict_id)))
               JOIN parties ON ((issue_parties.party_id = parties.id)))
            WHERE (issue_parties.issue_id = issues.id)) AS distinct_verdicts_count,
      ( SELECT string_agg(DISTINCT (verdicts.name)::text, ', '::text) AS string_agg
             FROM ((issue_parties
               JOIN verdicts ON ((verdicts.id = issue_parties.verdict_id)))
               JOIN parties ON ((issue_parties.party_id = parties.id)))
            WHERE (issue_parties.issue_id = issues.id)) AS verdict,
      ( SELECT string_agg(DISTINCT (issue_parties.verdict_details)::text, ', '::text) AS string_agg
             FROM ((issue_parties
               JOIN verdicts ON ((verdicts.id = issue_parties.verdict_id)))
               JOIN parties ON ((issue_parties.party_id = parties.id)))
            WHERE (issue_parties.issue_id = issues.id)) AS verdict_details,
      ( SELECT count(parties.id) AS count
             FROM ((parties
               JOIN case_parties ON ((case_parties.party_id = parties.id)))
               JOIN party_types ON ((parties.party_type_id = party_types.id)))
            WHERE ((case_parties.court_case_id = court_cases.id) AND ((party_types.name)::text = 'defendant'::text))) AS defendant_count,
      ( SELECT DISTINCT parties.full_name
             FROM ((parties
               JOIN case_parties ON ((case_parties.party_id = parties.id)))
               JOIN party_types ON ((parties.party_type_id = party_types.id)))
            WHERE ((case_parties.court_case_id = court_cases.id) AND ((party_types.name)::text = 'plaintiff'::text))
           LIMIT 1) AS plaintiff_name,
      ('https://www.oscn.net/dockets/GetCaseInformation.aspx?db=oklahoma&number='::text || (court_cases.case_number)::text) AS case_link,
      ( SELECT (translate(translate((regexp_matches(de.description, '\\$\\s{0,2}[0-9]{1,3}(?:,?[0-9]{3})*\\.?[0-9]{0,2}'::text))[1], ','::text, ''::text), '$'::text, ''::text))::numeric AS money
             FROM (docket_events de
               JOIN docket_event_types docket_event_types_1 ON ((de.docket_event_type_id = docket_event_types_1.id)))
            WHERE (((docket_event_types_1.code)::text = 'P'::text) AND (de.court_case_id = court_cases.id))
           LIMIT 1) AS rent_owed,
      ( SELECT (de.description ~~ '%POS%'::text) AS money
             FROM (docket_events de
               JOIN docket_event_types docket_event_types_1 ON ((de.docket_event_type_id = docket_event_types_1.id)))
            WHERE (((docket_event_types_1.code)::text = 'P'::text) AND (de.court_case_id = court_cases.id))
           LIMIT 1) AS possession
     FROM ((((court_cases
       JOIN counties ON ((court_cases.county_id = counties.id)))
       JOIN case_types ON ((court_cases.case_type_id = case_types.id)))
       JOIN issues ON ((court_cases.id = issues.court_case_id)))
       JOIN count_codes ON ((issues.count_code_id = count_codes.id)))
    WHERE (((count_codes.code)::text = ANY (ARRAY['SCFED1'::text, 'SCFED2'::text, 'FED1'::text, 'FED2'::text, 'ENTRY'::text])) AND ((counties.name)::text = 'Oklahoma'::text));
  SQL
  create_view "report_tulsa_evictions", sql_definition: <<-SQL
      SELECT court_cases.id AS court_case_id,
      court_cases.filed_on AS case_filed_on,
      court_cases.closed_on AS case_closed_on,
      court_cases.case_number,
      ( SELECT string_agg((parties.full_name)::text, '; '::text) AS string_agg
             FROM ((parties
               JOIN case_parties ON ((case_parties.party_id = parties.id)))
               JOIN party_types ON ((parties.party_type_id = party_types.id)))
            WHERE ((case_parties.court_case_id = court_cases.id) AND ((party_types.name)::text = 'defendant'::text))) AS defendant_name,
      ( SELECT count(DISTINCT verdicts.id) AS count
             FROM ((issue_parties
               JOIN verdicts ON ((verdicts.id = issue_parties.verdict_id)))
               JOIN parties ON ((issue_parties.party_id = parties.id)))
            WHERE (issue_parties.issue_id = issues.id)) AS distinct_verdicts_count,
      ( SELECT string_agg(DISTINCT (verdicts.name)::text, ', '::text) AS string_agg
             FROM ((issue_parties
               JOIN verdicts ON ((verdicts.id = issue_parties.verdict_id)))
               JOIN parties ON ((issue_parties.party_id = parties.id)))
            WHERE (issue_parties.issue_id = issues.id)) AS verdict,
      ( SELECT string_agg(DISTINCT (issue_parties.verdict_details)::text, ', '::text) AS string_agg
             FROM ((issue_parties
               JOIN verdicts ON ((verdicts.id = issue_parties.verdict_id)))
               JOIN parties ON ((issue_parties.party_id = parties.id)))
            WHERE (issue_parties.issue_id = issues.id)) AS verdict_details,
      ( SELECT count(parties.id) AS count
             FROM ((parties
               JOIN case_parties ON ((case_parties.party_id = parties.id)))
               JOIN party_types ON ((parties.party_type_id = party_types.id)))
            WHERE ((case_parties.court_case_id = court_cases.id) AND ((party_types.name)::text = 'defendant'::text))) AS defendant_count,
      ( SELECT DISTINCT parties.full_name
             FROM ((parties
               JOIN case_parties ON ((case_parties.party_id = parties.id)))
               JOIN party_types ON ((parties.party_type_id = party_types.id)))
            WHERE ((case_parties.court_case_id = court_cases.id) AND ((party_types.name)::text = 'plaintiff'::text))
           LIMIT 1) AS plaintiff_name,
      ('https://www.oscn.net/dockets/GetCaseInformation.aspx?db=tulsa&number='::text || (court_cases.case_number)::text) AS case_link,
      ( SELECT (translate(translate((regexp_matches(replace(de.description, ','::text, ''::text), '\\d+\\.?\\d*'::text))[1], ','::text, ''::text), '$'::text, ''::text))::numeric AS money
             FROM (docket_events de
               JOIN docket_event_types docket_event_types_1 ON ((de.docket_event_type_id = docket_event_types_1.id)))
            WHERE (((docket_event_types_1.code)::text = 'A/'::text) AND (de.court_case_id = court_cases.id))
           LIMIT 1) AS rent_owed,
      ( SELECT (de.description ~~ '%POS%'::text) AS money
             FROM (docket_events de
               JOIN docket_event_types docket_event_types_1 ON ((de.docket_event_type_id = docket_event_types_1.id)))
            WHERE (((docket_event_types_1.code)::text = 'A/'::text) AND (de.court_case_id = court_cases.id))
           LIMIT 1) AS possession
     FROM ((((court_cases
       JOIN counties ON ((court_cases.county_id = counties.id)))
       JOIN case_types ON ((court_cases.case_type_id = case_types.id)))
       JOIN issues ON ((court_cases.id = issues.court_case_id)))
       JOIN count_codes ON ((issues.count_code_id = count_codes.id)))
    WHERE (((count_codes.code)::text = ANY (ARRAY['SCFED1'::text, 'SCFED2'::text, 'FED1'::text, 'FED2'::text, 'ENTRY'::text])) AND ((counties.name)::text = 'Tulsa'::text));
  SQL
  create_view "report_oklahoma_domestics", sql_definition: <<-SQL
      SELECT court_cases.case_number,
      parties.first_name,
      parties.last_name,
      court_cases.filed_on,
      counts.number AS count_number,
      counts.as_filed AS count_filed_as,
      counts.offense_on,
      counts.disposition_on,
      counts.charge AS disposed_as,
      verdicts.name,
      ( SELECT count(*) AS count
             FROM (docket_events
               JOIN docket_event_types ON ((docket_events.docket_event_type_id = docket_event_types.id)))
            WHERE ((docket_events.court_case_id = court_cases.id) AND ((docket_event_types.code)::text = ANY ((ARRAY['WAI$'::character varying, 'BWIFAP'::character varying, 'BWIFA'::character varying, 'BWIFC'::character varying, 'BWIAR'::character varying, 'BWIAA'::character varying, 'BWICA'::character varying, 'BWIFAR'::character varying, 'BWIFAA'::character varying, 'BWIFP'::character varying, 'BWIMW'::character varying, 'BWIR8'::character varying, 'BWIS'::character varying, 'BWIS$'::character varying, 'WAI'::character varying, 'WAIMV'::character varying, 'WAIMW'::character varying])::text[])))) AS warrants_issued
     FROM ((((((court_cases
       JOIN counties ON ((court_cases.county_id = counties.id)))
       JOIN case_types ON ((court_cases.case_type_id = case_types.id)))
       JOIN counts ON ((counts.court_case_id = court_cases.id)))
       JOIN parties ON ((counts.party_id = parties.id)))
       LEFT JOIN verdicts ON ((counts.verdict_id = verdicts.id)))
       LEFT JOIN count_codes ON ((counts.disposed_statute_code_id = count_codes.id)))
    WHERE (((counties.name)::text = 'Oklahoma'::text) AND (court_cases.filed_on > '2000-01-01'::date) AND (court_cases.id IN ( SELECT DISTINCT counts_1.court_case_id
             FROM counts counts_1
            WHERE ((counts_1.as_filed)::text ~~* '%domes%'::text))));
  SQL
  create_view "report_juvenile_firearms", materialized: true, sql_definition: <<-SQL
      SELECT court_cases.id AS court_case_id,
      court_cases.case_number,
      court_cases.filed_on,
      court_cases.closed_on,
      ('https://www.oscn.net/dockets/GetCaseInformation.aspx?db=oklahoma&number='::text || (court_cases.case_number)::text) AS case_link,
      parties.id AS party_id,
      parties.full_name,
      counts.offense_on,
      counts.as_filed,
      counts.charge AS as_disposed,
      counts.disposition,
      counts.disposition_on,
      (counts.disposition_on - court_cases.filed_on) AS days_to_judgement,
      COALESCE(verdicts.name, 'none'::character varying) AS verdict
     FROM ((((counts
       JOIN court_cases ON ((counts.court_case_id = court_cases.id)))
       JOIN counties ON ((court_cases.county_id = counties.id)))
       JOIN parties ON ((parties.id = counts.party_id)))
       LEFT JOIN verdicts ON ((counts.verdict_id = verdicts.id)))
    WHERE (((counties.name)::text = 'Oklahoma'::text) AND (((counts.as_filed)::text ~~* '%AFJA%'::text) OR ((counts.as_filed)::text % 'JUVENILE ADJUDICATION'::text) OR ((counts.charge)::text ~~* '%AFJA%'::text) OR ((counts.charge)::text % 'JUVENILE ADJUDICATION'::text) OR ((counts.as_filed)::text % 'YOUTHFUL OFFENDER ADJUDICATION'::text) OR ((counts.charge)::text % 'YOUTHFUL OFFENDER ADJUDICATION'::text) OR ((counts.as_filed)::text % 'YOUTHFUL ADJUDICATION'::text) OR ((counts.charge)::text % 'YOUTHFUL ADJUDICATION'::text)));
  SQL
  create_view "report_criminal_cases", materialized: true, sql_definition: <<-SQL
      SELECT counts.id AS count_id,
      counts.offense_on AS count_offense_on,
      counts.as_filed AS count_as_filed,
      filed_code.code AS count_code_as_filed,
      counts.filed_statute_violation AS statute,
      counts.disposition AS count_as_disposed,
      disposed_code.code AS count_code_as_disposed,
      counts.disposition_on AS count_disposition_on,
      pleas.name AS plea,
      verdicts.name AS verdict,
      court_cases.id AS court_case_id,
      court_cases.county_id,
      court_cases.case_type_id,
      court_cases.case_number AS court_case_case_number,
      court_cases.filed_on AS court_case_filed_on,
      court_cases.closed_on AS court_case_closed_on
     FROM ((((((counts
       JOIN court_cases ON ((counts.court_case_id = court_cases.id)))
       JOIN case_types ON ((court_cases.case_type_id = case_types.id)))
       LEFT JOIN pleas ON ((counts.plea_id = pleas.id)))
       LEFT JOIN verdicts ON ((counts.verdict_id = verdicts.id)))
       LEFT JOIN count_codes filed_code ON ((counts.filed_statute_code_id = filed_code.id)))
       LEFT JOIN count_codes disposed_code ON ((counts.disposed_statute_code_id = disposed_code.id)))
    WHERE ((case_types.abbreviation)::text = ANY ((ARRAY['CF'::character varying, 'CM'::character varying, 'MI'::character varying, 'CPC'::character varying])::text[]));
  SQL
  add_index "report_criminal_cases", ["count_code_as_disposed"], name: "index_report_criminal_cases_on_count_code_as_disposed"
  add_index "report_criminal_cases", ["count_code_as_filed"], name: "index_report_criminal_cases_on_count_code_as_filed"
  add_index "report_criminal_cases", ["count_disposition_on"], name: "index_report_criminal_cases_on_count_disposition_on"
  add_index "report_criminal_cases", ["count_offense_on"], name: "index_report_criminal_cases_on_count_offense_on"
  add_index "report_criminal_cases", ["county_id"], name: "index_report_criminal_cases_on_county_id"
  add_index "report_criminal_cases", ["court_case_closed_on"], name: "index_report_criminal_cases_on_court_case_closed_on"
  add_index "report_criminal_cases", ["court_case_filed_on"], name: "index_report_criminal_cases_on_court_case_filed_on"
  add_index "report_criminal_cases", ["court_case_id"], name: "index_report_criminal_cases_on_court_case_id"

  create_view "report_ocis_counties_evictions", materialized: true, sql_definition: <<-SQL
      SELECT count_codes.code,
      court_cases.id AS court_case_id,
      court_cases.county_id,
      court_cases.filed_on AS case_filed_on,
      court_cases.closed_on AS case_closed_on,
      court_cases.case_number,
      issues.name AS issue_name,
      ( SELECT
                  CASE
                      WHEN (count(
                      CASE
                          WHEN (issue_parties.disposition_on IS NULL) THEN 1
                          ELSE NULL::integer
                      END) > 0) THEN NULL::date
                      ELSE max(issue_parties.disposition_on)
                  END AS max
             FROM issue_parties
            WHERE (issue_parties.issue_id = issues.id)
            GROUP BY court_cases.id) AS max_judgement_date,
      ( SELECT
                  CASE
                      WHEN (count(
                      CASE
                          WHEN (issue_parties.disposition_on IS NULL) THEN 1
                          ELSE NULL::integer
                      END) > 0) THEN NULL::integer
                      ELSE (max(issue_parties.disposition_on) - court_cases.filed_on)
                  END AS difference
             FROM issue_parties
            WHERE (issue_parties.issue_id = issues.id)
            GROUP BY court_cases.id) AS days_to_judgement,
      ( SELECT string_agg((parties.full_name)::text, '; '::text) AS string_agg
             FROM ((parties
               JOIN case_parties ON ((case_parties.party_id = parties.id)))
               JOIN party_types ON ((parties.party_type_id = party_types.id)))
            WHERE ((case_parties.court_case_id = court_cases.id) AND ((party_types.name)::text = 'defendant'::text))) AS defendant_name,
      ( SELECT count(DISTINCT verdicts.id) AS count
             FROM ((issue_parties
               JOIN verdicts ON ((verdicts.id = issue_parties.verdict_id)))
               JOIN parties ON ((issue_parties.party_id = parties.id)))
            WHERE (issue_parties.issue_id = issues.id)) AS distinct_verdicts_count,
      ( SELECT string_agg(DISTINCT (verdicts.name)::text, ', '::text) AS string_agg
             FROM ((issue_parties
               JOIN verdicts ON ((verdicts.id = issue_parties.verdict_id)))
               JOIN parties ON ((issue_parties.party_id = parties.id)))
            WHERE (issue_parties.issue_id = issues.id)) AS verdict,
      ( SELECT string_agg(DISTINCT (issue_parties.verdict_details)::text, ', '::text) AS string_agg
             FROM ((issue_parties
               JOIN verdicts ON ((verdicts.id = issue_parties.verdict_id)))
               JOIN parties ON ((issue_parties.party_id = parties.id)))
            WHERE (issue_parties.issue_id = issues.id)) AS verdict_details,
      ( SELECT count(DISTINCT parties.id) AS count
             FROM ((parties
               JOIN case_parties ON ((case_parties.party_id = parties.id)))
               JOIN party_types ON ((parties.party_type_id = party_types.id)))
            WHERE ((case_parties.court_case_id = court_cases.id) AND ((party_types.name)::text = 'defendant'::text))) AS defendant_count,
      ( SELECT count(DISTINCT parties.id) AS count
             FROM (((counsels
               JOIN counsel_parties ON (((counsels.id = counsel_parties.counsel_id) AND (counsel_parties.court_case_id = court_cases.id))))
               JOIN parties ON ((counsel_parties.party_id = parties.id)))
               JOIN party_types ON ((parties.party_type_id = party_types.id)))
            WHERE ((party_types.name)::text = 'defendant'::text)) AS defendant_represented_parties_count,
      ( SELECT string_agg(DISTINCT (parties.full_name)::text, '; '::text) AS string_agg
             FROM (((counsels
               JOIN counsel_parties ON (((counsels.id = counsel_parties.counsel_id) AND (counsel_parties.court_case_id = court_cases.id))))
               JOIN parties ON ((counsel_parties.party_id = parties.id)))
               JOIN party_types ON ((parties.party_type_id = party_types.id)))
            WHERE ((party_types.name)::text = 'defendant'::text)) AS defendant_represented_party,
      ( SELECT count(DISTINCT parties.id) AS count
             FROM (((counsels
               JOIN counsel_parties ON (((counsels.id = counsel_parties.counsel_id) AND (counsel_parties.court_case_id = court_cases.id))))
               JOIN parties ON ((counsel_parties.party_id = parties.id)))
               JOIN party_types ON ((parties.party_type_id = party_types.id)))
            WHERE ((party_types.name)::text = 'plaintiff'::text)) AS plaintiff_represented_parties_count,
      ( SELECT string_agg(DISTINCT (parties.full_name)::text, '; '::text) AS string_agg
             FROM (((counsels
               JOIN counsel_parties ON (((counsels.id = counsel_parties.counsel_id) AND (counsel_parties.court_case_id = court_cases.id))))
               JOIN parties ON ((counsel_parties.party_id = parties.id)))
               JOIN party_types ON ((parties.party_type_id = party_types.id)))
            WHERE ((party_types.name)::text = 'plaintiff'::text)) AS plaintiff_represented_party,
      ( SELECT DISTINCT parties.full_name
             FROM ((parties
               JOIN case_parties ON ((case_parties.party_id = parties.id)))
               JOIN party_types ON ((parties.party_type_id = party_types.id)))
            WHERE ((case_parties.court_case_id = court_cases.id) AND ((party_types.name)::text = 'plaintiff'::text))
           LIMIT 1) AS plaintiff_name,
      ((('https://www.oscn.net/dockets/GetCaseInformation.aspx?db='::text || (counties.name)::text) || '&number='::text) || (court_cases.case_number)::text) AS case_link
     FROM ((((court_cases
       JOIN counties ON ((court_cases.county_id = counties.id)))
       JOIN case_types ON ((court_cases.case_type_id = case_types.id)))
       JOIN issues ON ((court_cases.id = issues.court_case_id)))
       JOIN count_codes ON ((issues.count_code_id = count_codes.id)))
    WHERE (((case_types.abbreviation)::text = 'SC'::text) AND ((count_codes.code)::text = ANY (ARRAY['SCFED1'::text, 'SCFED2'::text, 'FED1'::text, 'FED2'::text, 'ENTRY'::text])) AND (court_cases.is_error = false));
  SQL
  add_index "report_ocis_counties_evictions", ["case_closed_on"], name: "index_report_ocis_counties_evictions_on_case_closed_on"
  add_index "report_ocis_counties_evictions", ["case_filed_on"], name: "index_report_ocis_counties_evictions_on_case_filed_on"
  add_index "report_ocis_counties_evictions", ["county_id"], name: "index_report_ocis_counties_evictions_on_county_id"
  add_index "report_ocis_counties_evictions", ["court_case_id"], name: "index_report_ocis_counties_evictions_on_court_case_id"

  create_view "report_warrants", materialized: true, sql_definition: <<-SQL
      SELECT docket_events.id,
      docket_events.court_case_id,
      court_cases.county_id,
      case_types.name,
      case_types.abbreviation,
      docket_events.party_id,
      ( SELECT party_addresses.zip
             FROM party_addresses
            WHERE (party_addresses.party_id = docket_events.party_id)
            ORDER BY party_addresses.record_on DESC
           LIMIT 1) AS zip_code,
      docket_events.event_on,
      docket_event_types.code,
          CASE
              WHEN (( SELECT count(*) AS count
                 FROM ((((case_parties
                   JOIN parties ON ((case_parties.party_id = parties.id)))
                   JOIN parent_parties ON ((parties.parent_party_id = parent_parties.id)))
                   JOIN party_types ON ((parties.party_type_id = party_types.id)))
                   JOIN court_cases court_cases_1 ON ((court_cases_1.id = case_parties.court_case_id)))
                WHERE (((party_types.name)::text = 'arresting agency'::text) AND (court_cases_1.id = docket_events.court_case_id))) = 1) THEN ( SELECT parent_parties.name
                 FROM ((((case_parties
                   JOIN parties ON ((case_parties.party_id = parties.id)))
                   JOIN parent_parties ON ((parties.parent_party_id = parent_parties.id)))
                   JOIN party_types ON ((parties.party_type_id = party_types.id)))
                   JOIN court_cases court_cases_1 ON ((court_cases_1.id = case_parties.court_case_id)))
                WHERE (((party_types.name)::text = 'arresting agency'::text) AND (court_cases_1.id = docket_events.court_case_id)))
              WHEN (( SELECT count(*) AS count
                 FROM ((((case_parties
                   JOIN parties ON ((case_parties.party_id = parties.id)))
                   JOIN parent_parties ON ((parties.parent_party_id = parent_parties.id)))
                   JOIN party_types ON ((parties.party_type_id = party_types.id)))
                   JOIN court_cases court_cases_1 ON ((court_cases_1.id = case_parties.court_case_id)))
                WHERE (((party_types.name)::text = 'arresting agency'::text) AND (court_cases_1.id = docket_events.court_case_id))) > 1) THEN 'MULTIPLE ARRESTING AGENCIES'::character varying
              ELSE 'NOT PROVIDED'::character varying
          END AS arresting_agency,
          CASE docket_event_types.code
              WHEN 'WAI$'::text THEN 'Warrant of Arrest Issued'::text
              WHEN 'BWIFAP'::text THEN 'Bench Warrant Issued - Failed to Appear and Pay'::text
              WHEN 'BWIFA'::text THEN 'Bench Warrant Issued - Failed to Appear'::text
              WHEN 'BWIFC'::text THEN 'Bench Warrant Issued - Failure to Comply'::text
              WHEN 'BWIAR'::text THEN 'Bench Warrant Issued - Application to Revoke'::text
              WHEN 'BWIAA'::text THEN 'Bench Warrant Issued - Application to Accelerate'::text
              WHEN 'BWICA'::text THEN 'Bench Warrant Issued - Cause'::text
              WHEN 'BWIFAR'::text THEN 'Bench Warrant Issued - Failure to Appear - Application to Revoke'::text
              WHEN 'BWIFAA'::text THEN 'Bench Warrant Issued - Failure To Appear - Application to Accelerate'::text
              WHEN 'BWIFP'::text THEN 'Bench Warrant Issued - Failed To Pay'::text
              WHEN 'BWIMW'::text THEN 'Bench Warrant Issued - Material Witness'::text
              WHEN 'BWIR8'::text THEN 'Bench Warrant Issued - Rule 8'::text
              WHEN 'BWIS'::text THEN 'Bench Warrant Issued - Service By Sheriff - No Money'::text
              WHEN 'BWIS$'::text THEN 'Bench Warrant Issued - Service By Sheriff'::text
              WHEN 'WAI'::text THEN 'Warrant of Arrest Issued - No Money'::text
              WHEN 'WAIMV'::text THEN 'Warrant of Arrest Issued - Material Warrant'::text
              WHEN 'WAIMW'::text THEN 'Warrant of Arrest Issued - Material Witness'::text
              WHEN 'RETBW'::text THEN 'Warrant Returned'::text
              WHEN 'RETWA'::text THEN 'Warrant Returned'::text
              ELSE NULL::text
          END AS shortdescription,
          CASE
              WHEN ((docket_event_types.code)::text = ANY ((ARRAY['BWIFA'::character varying, 'BWIFAA'::character varying, 'BWIFAR'::character varying])::text[])) THEN true
              ELSE false
          END AS is_failure_to_appear,
          CASE
              WHEN ((docket_event_types.code)::text = 'BWIFAP'::text) THEN true
              ELSE false
          END AS is_failure_to_appear_and_pay,
          CASE
              WHEN ((docket_event_types.code)::text = 'BWIFP'::text) THEN true
              ELSE false
          END AS is_failure_to_pay,
          CASE
              WHEN ((docket_event_types.code)::text = 'BWIFC'::text) THEN true
              ELSE false
          END AS is_failure_to_comply,
          CASE
              WHEN ((docket_event_types.code)::text = ANY ((ARRAY['BWIFAP'::character varying, 'BWIFA'::character varying, 'BWIFC'::character varying, 'BWIAA'::character varying, 'BWIAR'::character varying, 'BWICA'::character varying, 'BWIFAR'::character varying, 'BWIFAA'::character varying, 'BWIR8'::character varying, 'BWIS'::character varying, 'BWIS$'::character varying, 'BWIFP'::character varying, 'BWIMW'::character varying])::text[])) THEN true
              ELSE false
          END AS is_bench_warrant_issued,
          CASE
              WHEN ((docket_event_types.code)::text = ANY ((ARRAY['WAI'::character varying, 'WAI$'::character varying])::text[])) THEN true
              ELSE false
          END AS is_arrest_warrant_issued,
          CASE
              WHEN ((docket_event_types.code)::text = 'BWIAA'::text) THEN true
              ELSE false
          END AS is_application_to_accelerate,
          CASE
              WHEN ((docket_event_types.code)::text = 'BWIAR'::text) THEN true
              ELSE false
          END AS is_application_to_revoke,
          CASE
              WHEN ((docket_event_types.code)::text = 'BWICA'::text) THEN true
              ELSE false
          END AS is_cause,
          CASE
              WHEN ((docket_event_types.code)::text = ANY ((ARRAY['BWIMW'::character varying, 'WAIMW'::character varying])::text[])) THEN true
              ELSE false
          END AS is_material_witness,
          CASE
              WHEN ((docket_event_types.code)::text = 'WAIMV'::text) THEN true
              ELSE false
          END AS is_material_warrant,
          CASE
              WHEN ((docket_event_types.code)::text = 'BWIR8'::text) THEN true
              ELSE false
          END AS is_material_rule_8,
          CASE
              WHEN ((docket_event_types.code)::text = ANY ((ARRAY['BWIS$'::character varying, 'BWIS'::character varying])::text[])) THEN true
              ELSE false
          END AS is_service_by_sheriff,
          CASE
              WHEN (docket_events.description ~~ '%CLEARED%'::text) THEN true
              ELSE false
          END AS is_cleared,
      ((( SELECT (regexp_matches(docket_events.description, '[0-9]{1,3}(?:,?[0-9]{3})*\\.[0-9]{2}'::text))[1] AS regexp_matches))::money)::numeric AS bond_amount,
      ( SELECT (regexp_matches((( SELECT regexp_matches(docket_events.description, 'WARRANT RETURNED \\d{1,2}/\\d{1,2}/\\d{4}'::text) AS regexp_matches))[1], '\\d{1,2}/\\d{1,2}/\\d{4}'::text))[1] AS regexp_matches) AS warrant_returned_on,
          CASE
              WHEN (( SELECT (regexp_matches((( SELECT regexp_matches(docket_events.description, 'WARRANT ISSUED ON \\d{1,2}/\\d{1,2}/\\d{4}'::text) AS regexp_matches))[1], '\\d{1,2}/\\d{1,2}/\\d{4}'::text))[1] AS regexp_matches) IS NULL) THEN docket_events.event_on
              ELSE (( SELECT (regexp_matches((( SELECT regexp_matches(docket_events.description, 'WARRANT ISSUED ON \\d{1,2}/\\d{1,2}/\\d{4}'::text) AS regexp_matches))[1], '\\d{1,2}/\\d{1,2}/\\d{4}'::text))[1] AS regexp_matches))::date
          END AS warrant_issued_on,
      ( SELECT (regexp_matches((( SELECT regexp_matches(docket_events.description, 'WARRANT RECALLED \\d{1,2}/\\d{1,2}/\\d{4}'::text) AS regexp_matches))[1], '\\d{1,2}/\\d{1,2}/\\d{4}'::text))[1] AS regexp_matches) AS warrant_recalled_on,
      docket_events.description
     FROM (((docket_events
       JOIN docket_event_types ON ((docket_event_types.id = docket_events.docket_event_type_id)))
       JOIN court_cases ON ((court_cases.id = docket_events.court_case_id)))
       JOIN case_types ON ((court_cases.case_type_id = case_types.id)))
    WHERE ((docket_event_types.code)::text = ANY ((ARRAY['WAI$'::character varying, 'BWIFAP'::character varying, 'BWIFA'::character varying, 'BWIAR'::character varying, 'BWIAA'::character varying, 'BWIFC'::character varying, 'BWIFAR'::character varying, 'BWICA'::character varying, 'BWIFAA'::character varying, 'BWIFP'::character varying, 'BWIMW'::character varying, 'BWIR8'::character varying, 'BWIS'::character varying, 'BWIS$'::character varying, 'WAI'::character varying, 'WAIMV'::character varying, 'WAIMW'::character varying, 'RETBW'::character varying, 'RETWA'::character varying])::text[]));
  SQL
  add_index "report_warrants", ["party_id", "code"], name: "index_report_warrants_on_party_id_and_code"

  create_view "report_searchable_cases", materialized: true, sql_definition: <<-SQL
      SELECT court_cases.case_number,
      court_cases.filed_on,
      court_cases.county_id,
      parties.full_name,
      parties.first_name,
      parties.last_name,
      parties.birth_month,
      parties.birth_year,
          CASE
              WHEN (( SELECT count(*) AS count
                 FROM report_warrants
                WHERE ((parties.id = report_warrants.party_id) AND ((report_warrants.code)::text = ANY ((ARRAY['WAI$'::character varying, 'BWIFAP'::character varying, 'BWIFA'::character varying, 'BWIFC'::character varying, 'BWIAR'::character varying, 'BWIAA'::character varying, 'BWICA'::character varying, 'BWIFAR'::character varying, 'BWIFAA'::character varying, 'BWIFP'::character varying, 'BWIMW'::character varying, 'BWIR8'::character varying, 'BWIS'::character varying, 'BWIS$'::character varying, 'WAI'::character varying, 'WAIMV'::character varying, 'WAIMW'::character varying, 'BWIFAR'::character varying])::text[])))) > ( SELECT count(*) AS count
                 FROM report_warrants
                WHERE ((parties.id = report_warrants.party_id) AND ((report_warrants.code)::text = 'RETWA'::text)))) THEN 'Yes'::text
              ELSE 'No'::text
          END AS has_active_warrant,
      counts.offense_on AS date_of_offense,
      counts.as_filed AS count_as_filed,
      counts.charge AS count_as_disposed,
          CASE
              WHEN (( SELECT count(*) AS count
                 FROM (docket_events
                   JOIN docket_event_types ON ((docket_events.docket_event_type_id = docket_event_types.id)))
                WHERE ((docket_events.court_case_id = court_cases.id) AND ((docket_event_types.code)::text = ANY ((ARRAY['WAI$'::character varying, 'BWIFAP'::character varying, 'BWIFA'::character varying, 'BWIFC'::character varying, 'BWIAR'::character varying, 'BWIAA'::character varying, 'BWICA'::character varying, 'BWIFAR'::character varying, 'BWIFAA'::character varying, 'BWIFP'::character varying, 'BWIMW'::character varying, 'BWIR8'::character varying, 'BWIS'::character varying, 'BWIS$'::character varying, 'WAI'::character varying, 'WAIMV'::character varying, 'WAIMW'::character varying, 'BWIFAR'::character varying])::text[])))) > 0) THEN 'Yes'::text
              ELSE 'No'::text
          END AS warrant_on_case,
      pleas.name AS plea,
      verdicts.name AS verdict,
      (regexp_matches(split_part((counts.filed_statute_violation)::text, 'O.S.'::text, 1), '[0-9]{2}[A-Z]?'::text))[1] AS title_code
     FROM ((((counts
       JOIN court_cases ON ((counts.court_case_id = court_cases.id)))
       JOIN parties ON ((parties.id = counts.party_id)))
       JOIN pleas ON ((pleas.id = counts.plea_id)))
       JOIN verdicts ON ((verdicts.id = counts.verdict_id)));
  SQL
  create_view "report_ocso_oscn_joins", sql_definition: <<-SQL
      WITH clean_ocso AS (
           SELECT ocso_warrants.id AS ocso_id,
              ocso_warrants.first_name AS ocso_first_name,
              ocso_warrants.last_name AS ocso_last_name,
              ocso_warrants.middle_name AS ocso_middle_name,
              ocso_warrants.birth_date AS ocso_birth_date,
              ocso_warrants.bond_amount AS ocso_bond_amount,
              ocso_warrants.issued AS ocso_issued,
              ocso_warrants.counts AS ocso_counts,
              ocso_warrants.resolved_at AS ocso_resolved_at,
              ocso_warrants.case_number AS ocso_case_number,
                  CASE
                      WHEN ((ocso_warrants.case_number)::text ~ '^[A-Za-z]{2}[0-9]{5,}'::text) THEN "substring"((ocso_warrants.case_number)::text, 1, 2)
                      WHEN ((ocso_warrants.case_number)::text ~ '^[A-Za-z]{2}-[0-9]{2,}-[0-9]{1,}'::text) THEN "substring"((ocso_warrants.case_number)::text, '[A-Za-z]{1,}'::text)
                      ELSE NULL::text
                  END AS case_type,
                  CASE
                      WHEN ((ocso_warrants.case_number)::text ~ '^[A-Za-z]{2}[0-9]{5,}'::text) THEN (
                      CASE
                          WHEN ((("substring"((ocso_warrants.case_number)::text, 3, 2))::integer)::numeric <= (EXTRACT(year FROM CURRENT_DATE) % (100)::numeric)) THEN ('20'::text || "substring"((ocso_warrants.case_number)::text, 3, 2))
                          ELSE ('19'::text || "substring"((ocso_warrants.case_number)::text, 3, 2))
                      END)::integer
                      WHEN ((ocso_warrants.case_number)::text ~ '^[A-Za-z]{2}-[0-9]{2}-[0-9]{1,}'::text) THEN (
                      CASE
                          WHEN (((split_part((ocso_warrants.case_number)::text, '-'::text, 2))::integer)::numeric <= (EXTRACT(year FROM CURRENT_DATE) % (100)::numeric)) THEN ('20'::text || split_part((ocso_warrants.case_number)::text, '-'::text, 2))
                          ELSE ('19'::text || split_part((ocso_warrants.case_number)::text, '-'::text, 2))
                      END)::integer
                      WHEN ((ocso_warrants.case_number)::text ~ '^[A-Za-z]{2}-[0-9]{4}-[0-9]{1,}'::text) THEN (split_part((ocso_warrants.case_number)::text, '-'::text, 2))::integer
                      ELSE NULL::integer
                  END AS full_year,
                  CASE
                      WHEN ((ocso_warrants.case_number)::text ~ '^[A-Za-z]{2}[0-9]{5,}'::text) THEN regexp_replace("substring"((ocso_warrants.case_number)::text, 5), '^0+'::text, ''::text)
                      WHEN ((ocso_warrants.case_number)::text ~ '^[A-Za-z]{2}-[0-9]{2,}-[0-9]{1,}'::text) THEN split_part((ocso_warrants.case_number)::text, '-'::text, 3)
                      ELSE NULL::text
                  END AS last_case_number,
                  CASE
                      WHEN ((ocso_warrants.case_number)::text ~ '^[A-Za-z]{2}[0-9]{5,}'::text) THEN (((("substring"((ocso_warrants.case_number)::text, 1, 2) || '-'::text) ||
                      CASE
                          WHEN ((("substring"((ocso_warrants.case_number)::text, 3, 2))::integer)::numeric <= (EXTRACT(year FROM CURRENT_DATE) % (100)::numeric)) THEN ('20'::text || "substring"((ocso_warrants.case_number)::text, 3, 2))
                          ELSE ('19'::text || "substring"((ocso_warrants.case_number)::text, 3, 2))
                      END) || '-'::text) || regexp_replace("substring"((ocso_warrants.case_number)::text, 5), '^0+'::text, ''::text))
                      WHEN ((ocso_warrants.case_number)::text ~ '^[A-Za-z]{2}-[0-9]{2}-[0-9]{1,}'::text) THEN (((("substring"((ocso_warrants.case_number)::text, 1, 2) || '-'::text) ||
                      CASE
                          WHEN (((split_part((ocso_warrants.case_number)::text, '-'::text, 2))::integer)::numeric <= (EXTRACT(year FROM CURRENT_DATE) % (100)::numeric)) THEN ('20'::text || split_part((ocso_warrants.case_number)::text, '-'::text, 2))
                          ELSE ('19'::text || split_part((ocso_warrants.case_number)::text, '-'::text, 2))
                      END) || '-'::text) || split_part((ocso_warrants.case_number)::text, '-'::text, 3))
                      WHEN ((ocso_warrants.case_number)::text ~ '^[A-Za-z]{2}-[0-9]{4}-[0-9]{1,}'::text) THEN (ocso_warrants.case_number)::text
                      ELSE NULL::text
                  END AS clean_case_number,
                  CASE
                      WHEN ((ocso_warrants.case_number)::text ~ '^[A-Za-z]{2}[0-9]{5,}'::text) THEN ((((('https://www.oscn.net/dockets/GetCaseInformation.aspx?db=oklahoma&number='::text || "substring"((ocso_warrants.case_number)::text, 1, 2)) || '-'::text) || "substring"((ocso_warrants.case_number)::text, 3, 2)) || '-'::text) || regexp_replace("substring"((ocso_warrants.case_number)::text, 5), '^0+'::text, ''::text))
                      WHEN ((ocso_warrants.case_number)::text ~ '^[A-Za-z]{2}-[0-9]{2,}-[0-9]{1,}'::text) THEN ('https://www.oscn.net/dockets/GetCaseInformation.aspx?db=oklahoma&number='::text || (ocso_warrants.case_number)::text)
                      ELSE NULL::text
                  END AS link
             FROM ocso_warrants
          ), added_defendant_counts AS (
           SELECT clean_ocso.ocso_id,
              clean_ocso.ocso_first_name,
              clean_ocso.ocso_last_name,
              clean_ocso.ocso_middle_name,
              clean_ocso.ocso_birth_date,
              clean_ocso.ocso_bond_amount,
              clean_ocso.ocso_issued,
              clean_ocso.ocso_counts,
              clean_ocso.ocso_resolved_at,
              clean_ocso.ocso_case_number,
              clean_ocso.case_type,
              clean_ocso.full_year,
              clean_ocso.last_case_number,
              clean_ocso.clean_case_number,
              clean_ocso.link,
              ( SELECT count(DISTINCT parties.id) AS count
                     FROM ((((case_parties
                       JOIN parties ON ((case_parties.party_id = parties.id)))
                       JOIN court_cases ON ((court_cases.id = case_parties.court_case_id)))
                       JOIN counties ON ((court_cases.county_id = counties.id)))
                       JOIN party_types ON ((parties.party_type_id = party_types.id)))
                    WHERE (((party_types.name)::text = 'defendant'::text) AND ((court_cases.case_number)::text = clean_ocso.clean_case_number) AND ((counties.name)::text = 'Oklahoma'::text))) AS defendant_count
             FROM clean_ocso
            WHERE (clean_ocso.ocso_resolved_at IS NULL)
          )
   SELECT added_defendant_counts.ocso_id,
      added_defendant_counts.ocso_first_name,
      added_defendant_counts.ocso_last_name,
      added_defendant_counts.ocso_middle_name,
      added_defendant_counts.ocso_birth_date,
      added_defendant_counts.ocso_bond_amount,
      added_defendant_counts.ocso_issued,
      added_defendant_counts.ocso_counts,
      added_defendant_counts.ocso_resolved_at,
      added_defendant_counts.ocso_case_number,
      added_defendant_counts.case_type,
      added_defendant_counts.full_year,
      added_defendant_counts.last_case_number,
      added_defendant_counts.clean_case_number,
      added_defendant_counts.link,
      added_defendant_counts.defendant_count,
          CASE
              WHEN (added_defendant_counts.defendant_count = 0) THEN NULL::bigint
              WHEN (added_defendant_counts.defendant_count = 1) THEN ( SELECT count(*) AS count
                 FROM (((docket_events
                   JOIN court_cases ON ((docket_events.court_case_id = court_cases.id)))
                   JOIN counties ON ((court_cases.county_id = counties.id)))
                   JOIN docket_event_types ON ((docket_events.docket_event_type_id = docket_event_types.id)))
                WHERE (((docket_event_types.code)::text = ANY ((ARRAY['BWIFP'::character varying, 'WAIMW'::character varying, 'BWIFAP'::character varying, 'BWIFC'::character varying, 'BWIR8'::character varying, 'BWIAR'::character varying, 'BWICA'::character varying, 'BWIFA'::character varying, 'BWIFAA'::character varying, 'BWIS$'::character varying, 'BWIFAR'::character varying, 'BWIAA'::character varying, 'BWIMW'::character varying, 'WAI$'::character varying, 'WAI'::character varying, 'BWIS'::character varying])::text[])) AND ((counties.name)::text = 'Oklahoma'::text) AND ((court_cases.case_number)::text = added_defendant_counts.clean_case_number) AND (( SELECT count(DISTINCT parties.id) AS count
                         FROM ((case_parties
                           JOIN parties ON ((case_parties.party_id = parties.id)))
                           JOIN party_types ON ((parties.party_type_id = party_types.id)))
                        WHERE (((party_types.name)::text = 'defendant'::text) AND (case_parties.court_case_id = court_cases.id))) = 1)))
              WHEN (added_defendant_counts.defendant_count > 1) THEN ( SELECT count(*) AS count
                 FROM ((((docket_events
                   JOIN court_cases ON ((docket_events.court_case_id = court_cases.id)))
                   JOIN counties ON ((court_cases.county_id = counties.id)))
                   JOIN parties ON ((docket_events.party_id = parties.id)))
                   JOIN docket_event_types ON ((docket_events.docket_event_type_id = docket_event_types.id)))
                WHERE (((docket_event_types.code)::text = ANY ((ARRAY['BWIFP'::character varying, 'WAIMW'::character varying, 'BWIFAP'::character varying, 'BWIFC'::character varying, 'BWIR8'::character varying, 'BWIAR'::character varying, 'BWICA'::character varying, 'BWIFA'::character varying, 'BWIFAA'::character varying, 'BWIS$'::character varying, 'BWIFAR'::character varying, 'BWIAA'::character varying, 'BWIMW'::character varying, 'WAI$'::character varying, 'WAI'::character varying, 'BWIS'::character varying])::text[])) AND ((counties.name)::text = 'Oklahoma'::text) AND ((court_cases.case_number)::text = added_defendant_counts.clean_case_number) AND ((levenshtein(lower((parties.first_name)::text), lower((added_defendant_counts.ocso_first_name)::text)) <= 2) OR (levenshtein(lower((parties.last_name)::text), lower((added_defendant_counts.ocso_last_name)::text)) <= 2))))
              ELSE NULL::bigint
          END AS warrant_count,
          CASE
              WHEN (added_defendant_counts.defendant_count = 0) THEN NULL::bigint
              WHEN (added_defendant_counts.defendant_count = 1) THEN ( SELECT count(*) AS count
                 FROM (((docket_events
                   JOIN court_cases ON ((docket_events.court_case_id = court_cases.id)))
                   JOIN counties ON ((court_cases.county_id = counties.id)))
                   JOIN docket_event_types ON ((docket_events.docket_event_type_id = docket_event_types.id)))
                WHERE (((docket_event_types.code)::text = ANY ((ARRAY['RETBW'::character varying, 'RETWA'::character varying])::text[])) AND ((counties.name)::text = 'Oklahoma'::text) AND ((court_cases.case_number)::text = added_defendant_counts.clean_case_number) AND (( SELECT count(DISTINCT parties.id) AS count
                         FROM ((case_parties
                           JOIN parties ON ((case_parties.party_id = parties.id)))
                           JOIN party_types ON ((parties.party_type_id = party_types.id)))
                        WHERE (((party_types.name)::text = 'defendant'::text) AND (case_parties.court_case_id = court_cases.id))) = 1)))
              WHEN (added_defendant_counts.defendant_count > 1) THEN ( SELECT count(*) AS count
                 FROM ((((docket_events
                   JOIN court_cases ON ((docket_events.court_case_id = court_cases.id)))
                   JOIN counties ON ((court_cases.county_id = counties.id)))
                   JOIN parties ON ((docket_events.party_id = parties.id)))
                   JOIN docket_event_types ON ((docket_events.docket_event_type_id = docket_event_types.id)))
                WHERE (((docket_event_types.code)::text = ANY ((ARRAY['RETBW'::character varying, 'RETWA'::character varying])::text[])) AND ((counties.name)::text = 'Oklahoma'::text) AND ((court_cases.case_number)::text = added_defendant_counts.clean_case_number) AND ((levenshtein(lower((parties.first_name)::text), lower((added_defendant_counts.ocso_first_name)::text)) <= 2) OR (levenshtein(lower((parties.last_name)::text), lower((added_defendant_counts.ocso_last_name)::text)) <= 2))))
              ELSE NULL::bigint
          END AS return_warrant_count,
          CASE
              WHEN (added_defendant_counts.defendant_count = 0) THEN NULL::character varying
              WHEN (added_defendant_counts.defendant_count = 1) THEN ( SELECT docket_event_types.code
                 FROM (((docket_events
                   JOIN court_cases ON ((docket_events.court_case_id = court_cases.id)))
                   JOIN counties ON ((court_cases.county_id = counties.id)))
                   JOIN docket_event_types ON ((docket_events.docket_event_type_id = docket_event_types.id)))
                WHERE (((docket_event_types.code)::text = ANY ((ARRAY['BWIFP'::character varying, 'WAIMW'::character varying, 'BWIFAP'::character varying, 'BWIFC'::character varying, 'BWIR8'::character varying, 'BWIAR'::character varying, 'BWICA'::character varying, 'BWIFA'::character varying, 'BWIFAA'::character varying, 'BWIS$'::character varying, 'BWIFAR'::character varying, 'BWIAA'::character varying, 'BWIMW'::character varying, 'WAI$'::character varying, 'WAI'::character varying, 'BWIS'::character varying])::text[])) AND ((counties.name)::text = 'Oklahoma'::text) AND ((court_cases.case_number)::text = added_defendant_counts.clean_case_number) AND (( SELECT count(DISTINCT parties.id) AS count
                         FROM ((case_parties
                           JOIN parties ON ((case_parties.party_id = parties.id)))
                           JOIN party_types ON ((parties.party_type_id = party_types.id)))
                        WHERE (((party_types.name)::text = 'defendant'::text) AND (case_parties.court_case_id = court_cases.id))) = 1))
                ORDER BY docket_events.event_on DESC
               LIMIT 1)
              WHEN (added_defendant_counts.defendant_count > 1) THEN ( SELECT docket_event_types.code
                 FROM ((((docket_events
                   JOIN court_cases ON ((docket_events.court_case_id = court_cases.id)))
                   JOIN counties ON ((court_cases.county_id = counties.id)))
                   JOIN parties ON ((docket_events.party_id = parties.id)))
                   JOIN docket_event_types ON ((docket_events.docket_event_type_id = docket_event_types.id)))
                WHERE (((docket_event_types.code)::text = ANY ((ARRAY['BWIFP'::character varying, 'WAIMW'::character varying, 'BWIFAP'::character varying, 'BWIFC'::character varying, 'BWIR8'::character varying, 'BWIAR'::character varying, 'BWICA'::character varying, 'BWIFA'::character varying, 'BWIFAA'::character varying, 'BWIS$'::character varying, 'BWIFAR'::character varying, 'BWIAA'::character varying, 'BWIMW'::character varying, 'WAI$'::character varying, 'WAI'::character varying, 'BWIS'::character varying])::text[])) AND ((counties.name)::text = 'Oklahoma'::text) AND ((court_cases.case_number)::text = added_defendant_counts.clean_case_number) AND ((levenshtein(lower((parties.first_name)::text), lower((added_defendant_counts.ocso_first_name)::text)) <= 2) OR (levenshtein(lower((parties.last_name)::text), lower((added_defendant_counts.ocso_last_name)::text)) <= 2)))
                ORDER BY docket_events.event_on DESC
               LIMIT 1)
              ELSE NULL::character varying
          END AS most_recent_warrant_type,
      ( SELECT DISTINCT party_addresses.zip
             FROM (((((court_cases
               JOIN case_parties ON ((court_cases.id = case_parties.court_case_id)))
               JOIN counties ON ((court_cases.county_id = counties.id)))
               JOIN parties ON ((parties.id = case_parties.party_id)))
               JOIN party_types ON ((parties.party_type_id = party_types.id)))
               JOIN party_addresses ON ((parties.id = party_addresses.party_id)))
            WHERE (((party_addresses.status)::text = 'Current'::text) AND ((counties.name)::text = 'Oklahoma'::text) AND ((party_types.name)::text = 'defendant'::text) AND ((court_cases.case_number)::text = added_defendant_counts.clean_case_number) AND (party_addresses.zip <> 0) AND ((levenshtein(lower((parties.first_name)::text), lower((added_defendant_counts.ocso_first_name)::text)) <= 2) OR (levenshtein(lower((parties.last_name)::text), lower((added_defendant_counts.ocso_last_name)::text)) <= 2)))
           LIMIT 1) AS defendant_zip_codes,
      ( SELECT case_htmls.scraped_at
             FROM ((court_cases
               JOIN counties ON ((court_cases.county_id = counties.id)))
               JOIN case_htmls ON ((case_htmls.court_case_id = court_cases.id)))
            WHERE (((court_cases.case_number)::text = added_defendant_counts.clean_case_number) AND ((counties.name)::text = 'Oklahoma'::text))
           LIMIT 1) AS scraped_at
     FROM added_defendant_counts;
  SQL
  create_view "report_oklahoma_evictions", materialized: true, sql_definition: <<-SQL
      WITH view_data AS (
           SELECT court_cases.id AS court_case_id,
              court_cases.filed_on AS case_filed_on,
              court_cases.closed_on AS case_closed_on,
              ( SELECT eviction_letters.eviction_file_id
                     FROM ((eviction_letters
                       JOIN docket_event_links ON ((docket_event_links.id = eviction_letters.docket_event_link_id)))
                       JOIN docket_events ON ((docket_event_links.docket_event_id = docket_events.id)))
                    WHERE (docket_events.court_case_id = court_cases.id)
                   LIMIT 1) AS eviction_file_id,
              court_cases.case_number,
              ( SELECT
                          CASE
                              WHEN (count(
                              CASE
                                  WHEN (issue_parties.disposition_on IS NULL) THEN 1
                                  ELSE NULL::integer
                              END) > 0) THEN NULL::date
                              ELSE max(issue_parties.disposition_on)
                          END AS max
                     FROM issue_parties
                    WHERE (issue_parties.issue_id = issues.id)
                    GROUP BY court_cases.id) AS max_judgement_date,
              ( SELECT
                          CASE
                              WHEN (count(
                              CASE
                                  WHEN (issue_parties.disposition_on IS NULL) THEN 1
                                  ELSE NULL::integer
                              END) > 0) THEN NULL::integer
                              ELSE (max(issue_parties.disposition_on) - court_cases.filed_on)
                          END AS difference
                     FROM issue_parties
                    WHERE (issue_parties.issue_id = issues.id)
                    GROUP BY court_cases.id) AS days_to_judgement,
              ( SELECT string_agg((parties.full_name)::text, '; '::text) AS string_agg
                     FROM ((parties
                       JOIN case_parties ON ((case_parties.party_id = parties.id)))
                       JOIN party_types ON ((parties.party_type_id = party_types.id)))
                    WHERE ((case_parties.court_case_id = court_cases.id) AND ((party_types.name)::text = 'defendant'::text))) AS defendant_name,
              ( SELECT count(DISTINCT verdicts.id) AS count
                     FROM ((issue_parties
                       JOIN verdicts ON ((verdicts.id = issue_parties.verdict_id)))
                       JOIN parties ON ((issue_parties.party_id = parties.id)))
                    WHERE (issue_parties.issue_id = issues.id)) AS distinct_verdicts_count,
              ( SELECT string_agg(DISTINCT (verdicts.name)::text, ', '::text) AS string_agg
                     FROM ((issue_parties
                       JOIN verdicts ON ((verdicts.id = issue_parties.verdict_id)))
                       JOIN parties ON ((issue_parties.party_id = parties.id)))
                    WHERE (issue_parties.issue_id = issues.id)) AS verdict,
              ( SELECT string_agg(DISTINCT (issue_parties.verdict_details)::text, ', '::text) AS string_agg
                     FROM ((issue_parties
                       JOIN verdicts ON ((verdicts.id = issue_parties.verdict_id)))
                       JOIN parties ON ((issue_parties.party_id = parties.id)))
                    WHERE (issue_parties.issue_id = issues.id)) AS verdict_details,
              ( SELECT count(DISTINCT parties.id) AS count
                     FROM ((parties
                       JOIN case_parties ON ((case_parties.party_id = parties.id)))
                       JOIN party_types ON ((parties.party_type_id = party_types.id)))
                    WHERE ((case_parties.court_case_id = court_cases.id) AND ((party_types.name)::text = 'defendant'::text))) AS defendant_count,
              ( SELECT count(DISTINCT parties.id) AS count
                     FROM (((counsels
                       JOIN counsel_parties ON (((counsels.id = counsel_parties.counsel_id) AND (counsel_parties.court_case_id = court_cases.id))))
                       JOIN parties ON ((counsel_parties.party_id = parties.id)))
                       JOIN party_types ON ((parties.party_type_id = party_types.id)))
                    WHERE ((party_types.name)::text = 'defendant'::text)) AS defendant_represented_parties_count,
              ( SELECT string_agg(DISTINCT (parties.full_name)::text, '; '::text) AS string_agg
                     FROM (((counsels
                       JOIN counsel_parties ON (((counsels.id = counsel_parties.counsel_id) AND (counsel_parties.court_case_id = court_cases.id))))
                       JOIN parties ON ((counsel_parties.party_id = parties.id)))
                       JOIN party_types ON ((parties.party_type_id = party_types.id)))
                    WHERE ((party_types.name)::text = 'defendant'::text)) AS defendant_represented_party,
              ( SELECT count(DISTINCT parties.id) AS count
                     FROM (((counsels
                       JOIN counsel_parties ON (((counsels.id = counsel_parties.counsel_id) AND (counsel_parties.court_case_id = court_cases.id))))
                       JOIN parties ON ((counsel_parties.party_id = parties.id)))
                       JOIN party_types ON ((parties.party_type_id = party_types.id)))
                    WHERE ((party_types.name)::text = 'plaintiff'::text)) AS plaintiff_represented_parties_count,
              ( SELECT string_agg(DISTINCT (parties.full_name)::text, '; '::text) AS string_agg
                     FROM (((counsels
                       JOIN counsel_parties ON (((counsels.id = counsel_parties.counsel_id) AND (counsel_parties.court_case_id = court_cases.id))))
                       JOIN parties ON ((counsel_parties.party_id = parties.id)))
                       JOIN party_types ON ((parties.party_type_id = party_types.id)))
                    WHERE ((party_types.name)::text = 'plaintiff'::text)) AS plaintiff_represented_party,
              ( SELECT DISTINCT parties.full_name
                     FROM ((parties
                       JOIN case_parties ON ((case_parties.party_id = parties.id)))
                       JOIN party_types ON ((parties.party_type_id = party_types.id)))
                    WHERE ((case_parties.court_case_id = court_cases.id) AND ((party_types.name)::text = 'plaintiff'::text))
                   LIMIT 1) AS plaintiff_name,
              ('https://www.oscn.net/dockets/GetCaseInformation.aspx?db=oklahoma&number='::text || (court_cases.case_number)::text) AS case_link,
              ( SELECT (translate(translate((regexp_matches(de.description, '\\$\\s{0,2}[0-9]{1,3}(?:,?[0-9]{3})*\\.?[0-9]{0,2}'::text))[1], ','::text, ''::text), '$'::text, ''::text))::numeric AS money
                     FROM (docket_events de
                       JOIN docket_event_types docket_event_types_1 ON ((de.docket_event_type_id = docket_event_types_1.id)))
                    WHERE (((docket_event_types_1.code)::text = 'P'::text) AND (de.court_case_id = court_cases.id))
                   LIMIT 1) AS rent_owed,
              ( SELECT (de.description ~~ '%POS%'::text) AS money
                     FROM (docket_events de
                       JOIN docket_event_types docket_event_types_1 ON ((de.docket_event_type_id = docket_event_types_1.id)))
                    WHERE (((docket_event_types_1.code)::text = 'P'::text) AND (de.court_case_id = court_cases.id))
                   LIMIT 1) AS possession,
              ( SELECT el.ocr_plaintiff_address
                     FROM ((eviction_letters el
                       JOIN docket_event_links del ON ((el.docket_event_link_id = del.id)))
                       JOIN docket_events de ON ((del.docket_event_id = de.id)))
                    WHERE (de.court_case_id = court_cases.id)
                   LIMIT 1) AS ocr_plaintiff_address,
              ( SELECT el.validation_usps_address
                     FROM ((eviction_letters el
                       JOIN docket_event_links del ON ((el.docket_event_link_id = del.id)))
                       JOIN docket_events de ON ((del.docket_event_id = de.id)))
                    WHERE (de.court_case_id = court_cases.id)
                   LIMIT 1) AS validated_address,
              ( SELECT el.validation_usps_state_zip
                     FROM ((eviction_letters el
                       JOIN docket_event_links del ON ((el.docket_event_link_id = del.id)))
                       JOIN docket_events de ON ((del.docket_event_id = de.id)))
                    WHERE (de.court_case_id = court_cases.id)
                   LIMIT 1) AS valdated_state_zip,
              ( SELECT el.validation_city
                     FROM ((eviction_letters el
                       JOIN docket_event_links del ON ((el.docket_event_link_id = del.id)))
                       JOIN docket_events de ON ((del.docket_event_id = de.id)))
                    WHERE (de.court_case_id = court_cases.id)
                   LIMIT 1) AS validation_city,
              ( SELECT el.validation_zip_code
                     FROM ((eviction_letters el
                       JOIN docket_event_links del ON ((el.docket_event_link_id = del.id)))
                       JOIN docket_events de ON ((del.docket_event_id = de.id)))
                    WHERE (de.court_case_id = court_cases.id)
                   LIMIT 1) AS validation_zip_code,
              ( SELECT el.validation_state
                     FROM ((eviction_letters el
                       JOIN docket_event_links del ON ((el.docket_event_link_id = del.id)))
                       JOIN docket_events de ON ((del.docket_event_id = de.id)))
                    WHERE (de.court_case_id = court_cases.id)
                   LIMIT 1) AS validation_state,
              ( SELECT el.validation_latitude
                     FROM ((eviction_letters el
                       JOIN docket_event_links del ON ((el.docket_event_link_id = del.id)))
                       JOIN docket_events de ON ((del.docket_event_id = de.id)))
                    WHERE (de.court_case_id = court_cases.id)
                   LIMIT 1) AS valdated_latitude,
              ( SELECT el.validation_longitude
                     FROM ((eviction_letters el
                       JOIN docket_event_links del ON ((el.docket_event_link_id = del.id)))
                       JOIN docket_events de ON ((del.docket_event_id = de.id)))
                    WHERE (de.court_case_id = court_cases.id)
                   LIMIT 1) AS validation_longitude,
              ( SELECT el.status
                     FROM ((eviction_letters el
                       JOIN docket_event_links del ON ((el.docket_event_link_id = del.id)))
                       JOIN docket_events de ON ((del.docket_event_id = de.id)))
                    WHERE (de.court_case_id = court_cases.id)
                   LIMIT 1) AS letter_status,
              ( SELECT string_agg(DISTINCT (counsels.name)::text, '; '::text) AS string_agg
                     FROM (((counsels
                       JOIN counsel_parties ON (((counsels.id = counsel_parties.counsel_id) AND (counsel_parties.court_case_id = court_cases.id))))
                       JOIN parties ON ((counsel_parties.party_id = parties.id)))
                       JOIN party_types ON ((parties.party_type_id = party_types.id)))
                    WHERE ((party_types.name)::text = 'plaintiff'::text)) AS plaintiff_attorneys
             FROM ((((court_cases
               JOIN counties ON ((court_cases.county_id = counties.id)))
               JOIN case_types ON ((court_cases.case_type_id = case_types.id)))
               JOIN issues ON ((court_cases.id = issues.court_case_id)))
               JOIN count_codes ON ((issues.count_code_id = count_codes.id)))
            WHERE (((count_codes.code)::text = ANY (ARRAY['SCFED1'::text, 'SCFED2'::text, 'FED1'::text, 'FED2'::text, 'ENTRY'::text])) AND ((counties.name)::text = 'Oklahoma'::text) AND (court_cases.is_error IS FALSE))
          )
   SELECT view_data.court_case_id,
      view_data.case_filed_on,
      view_data.case_closed_on,
      view_data.case_number,
      view_data.max_judgement_date,
      view_data.days_to_judgement,
      view_data.defendant_name,
      view_data.distinct_verdicts_count,
      view_data.verdict,
      view_data.verdict_details,
      view_data.defendant_count,
      view_data.defendant_represented_parties_count,
      view_data.defendant_represented_party,
      view_data.plaintiff_represented_parties_count,
      view_data.plaintiff_represented_party,
      view_data.plaintiff_name,
      view_data.plaintiff_attorneys,
      view_data.case_link,
      view_data.rent_owed,
      view_data.possession,
      view_data.ocr_plaintiff_address,
      view_data.validated_address,
      view_data.valdated_state_zip,
      view_data.validation_city,
      view_data.validation_zip_code,
      view_data.validation_state,
      view_data.valdated_latitude,
      view_data.validation_longitude,
      view_data.letter_status,
      view_data.eviction_file_id,
          CASE
              WHEN (view_data.verdict ~ 'juvenile'::text) THEN 'Juvenile'::text
              WHEN (view_data.verdict ~ 'default judgement'::text) THEN 'Default Judgement'::text
              WHEN (view_data.verdict ~ 'judgement'::text) THEN 'Judgement'::text
              WHEN ((view_data.verdict = ANY (ARRAY['final order'::text, 'final judgment'::text])) OR (view_data.verdict ~ 'rights of majority'::text)) THEN 'Judgement'::text
              WHEN (view_data.verdict ~ 'deferred'::text) THEN 'Deferred'::text
              WHEN ((view_data.verdict ~ 'consolidated'::text) OR (view_data.verdict ~ 'transferred'::text)) THEN 'Transferred'::text
              WHEN (view_data.verdict ~ 'bankruptcy'::text) THEN 'Bankruptcy Filed'::text
              WHEN ((view_data.verdict ~ 'dismissed'::text) AND (view_data.verdict ~ 'satisfied'::text)) THEN 'Dismissed - Satisfied'::text
              WHEN ((view_data.verdict ~ 'settled'::text) OR (view_data.verdict ~ 'settlement'::text)) THEN 'Dismissed - Settlement'::text
              WHEN ((view_data.verdict ~ 'dismissed'::text) OR (view_data.verdict ~ 'vacated'::text)) THEN 'Dismissed'::text
              WHEN (view_data.verdict = 'discharge filed'::text) THEN 'Dismissed'::text
              WHEN (view_data.case_closed_on IS NULL) THEN 'Active Case'::text
              ELSE 'Other'::text
          END AS simple_judgement
     FROM view_data;
  SQL
  add_index "report_oklahoma_evictions", ["case_closed_on"], name: "index_report_oklahoma_evictions_on_case_closed_on"
  add_index "report_oklahoma_evictions", ["case_filed_on"], name: "index_report_oklahoma_evictions_on_case_filed_on"
  add_index "report_oklahoma_evictions", ["court_case_id"], name: "index_report_oklahoma_evictions_on_court_case_id", unique: true
  add_index "report_oklahoma_evictions", ["max_judgement_date"], name: "index_report_oklahoma_evictions_on_max_judgement_date"

end
