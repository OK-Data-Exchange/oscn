class Merge9bDb < ActiveRecord::Migration[7.0]
  def change
    change_table "doc_profiles", force: :cascade do |t|
      t.index "lower((first_name)::text)", name: "doc_profiles_first_name_index_2"
      t.index "lower((last_name)::text)", name: "doc_profiles_last_name_index_2"
      t.index ["first_name"], name: "doc_profiles_first_name_index"
      t.index ["last_name"], name: "doc_profiles_last_name_index"
    end

    # todo: find a better way to genrate clean case numbers
    change_table "doc_sentences", force: :cascade do |t|
      t.remove "clean_case_number"
      t.virtual "clean_case_number", type: :string, as: "\nCASE\n    WHEN ((crf_number)::text ~ '^([A-Za-z]{2,3})?-?[0-9]{2,4}-[0-9]{1,8}'::text) THEN ((((\n    CASE\n        WHEN ((crf_number)::text ~ '^[A-Za-z]{2,3}'::text) THEN \"substring\"((crf_number)::text, '^([A-Za-z]{2,3})'::text)\n        ELSE 'CF'::text\n    END || '-'::text) ||\n    CASE\n        WHEN (length(\"substring\"((crf_number)::text, '([0-9]{2,4})-'::text)) = 2) THEN\n        CASE\n            WHEN ((\"substring\"((crf_number)::text, '([0-9]{2,4})-'::text))::integer <= 40) THEN ('20'::text || \"substring\"((crf_number)::text, '([0-9]{2,4})-'::text))\n            ELSE ('19'::text || \"substring\"((crf_number)::text, '([0-9]{2,4})-'::text))\n        END\n        ELSE \"substring\"((crf_number)::text, '([0-9]{2,4})-'::text)\n    END) || '-'::text) || regexp_replace(\"substring\"((crf_number)::text, '-([0-9]{1,8})$'::text), '^0+'::text, ''::text))\n    ELSE NULL::text\nEND", stored: true
    end

    change_table "court_cases", force: :cascade do |t|
      t.virtual "clean_case_number", type: :string, as: "\nCASE\n    WHEN ((case_number)::text ~ '^([A-Za-z]{2,3})?-?[0-9]{2,4}-[0-9]{1,8}'::text) THEN ((((\n    CASE\n        WHEN ((case_number)::text ~ '^[A-Za-z]{2,3}'::text) THEN \"substring\"((case_number)::text, '^([A-Za-z]{2,3})'::text)\n        ELSE 'CF'::text\n    END || '-'::text) ||\n    CASE\n        WHEN (length(\"substring\"((case_number)::text, '([0-9]{2,4})-'::text)) = 2) THEN\n        CASE\n            WHEN ((\"substring\"((case_number)::text, '([0-9]{2,4})-'::text))::integer <= 40) THEN ('20'::text || \"substring\"((case_number)::text, '([0-9]{2,4})-'::text))\n            ELSE ('19'::text || \"substring\"((case_number)::text, '([0-9]{2,4})-'::text))\n        END\n        ELSE \"substring\"((case_number)::text, '([0-9]{2,4})-'::text)\n    END) || '-'::text) || regexp_replace(\"substring\"((case_number)::text, '-([0-9]{1,8})$'::text), '^0+'::text, ''::text))\n    ELSE NULL::text\nEND", stored: true
      t.index ["case_number"], name: "court_cases_case_number_index"
      t.index ["clean_case_number"], name: "clean_court_cases_case_number_index"
    end

    change_table "docket_events", force: :cascade do |t|
      t.index ["court_case_id", "docket_event_type_id"], name: "index_court_case_event_type"
      t.index ["created_at"], name: "docket_events_created_at_index"
      t.index ["event_on"], name: "docket_events_event_on_index"
    end

    change_column_null :issues, :count_code_id, true

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
      t.bigint "ok_county_jail_booking_id", null: false
      t.string "code"
      t.string "description"
      t.string "case_number"
      t.string "bond"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["ok_county_jail_booking_id"], name: "index_ok_county_jail_offenses_on_ok_county_jail_bookings_id"
    end

    change_table "parties", force: :cascade do |t|
      t.index "lower((first_name)::text)", name: "parties_first_name_index_2"
      t.index "lower((last_name)::text)", name: "parties_last_name_index_2"
      t.index ["first_name"], name: "parties_first_name_index"
      t.index ["last_name"], name: "parties_last_name_index"
    end

    create_table "pd_bookings", force: :cascade do |t|
      t.string "jailnet_inmate_id"
      t.string "initial_docket_id"
      t.string "inmate_name"
      t.string "inmate_aka"
      t.datetime "birth_date", precision: nil
      t.string "city_of_birth"
      t.string "state_of_birth"
      t.integer "current_age"
      t.string "race"
      t.string "gender"
      t.integer "height"
      t.float "weight"
      t.string "hair_color"
      t.string "eye_color"
      t.string "build"
      t.string "complexion"
      t.string "facial_hair"
      t.string "martial_status"
      t.string "emergency_contact"
      t.string "emergency_phone"
      t.string "drivers_state"
      t.string "drivers_license"
      t.string "address1"
      t.string "address2"
      t.string "city"
      t.string "state"
      t.string "zip_code"
      t.string "home_phone"
      t.string "fbi_nbr"
      t.string "osbi_nbr"
      t.string "tpd_nbr"
      t.integer "age_at_booking"
      t.integer "age_at_release"
      t.string "arrest_date"
      t.string "arrest_by"
      t.string "agency"
      t.string "booking_date"
      t.string "booking_by"
      t.string "otn_nbr"
      t.string "estimated_release_date"
      t.string "release_date"
      t.string "release_by"
      t.string "release_reason"
      t.string "weekend_server"
      t.string "custody_level"
      t.string "assigned_cell_id"
      t.string "current_location"
      t.string "booking_notes"
      t.string "booking_alerts"
      t.string "booking_trustees"
      t.virtual "first_name", type: :string, as: "split_part(split_part((inmate_name)::text, ', '::text, 2), ' '::text, 1)", stored: true
      t.virtual "last_name", type: :string, as: "split_part((inmate_name)::text, ', '::text, 1)", stored: true
      t.virtual "clean_dlm", type: :string, as: "ltrim((jailnet_inmate_id)::text, '0'::text)", stored: true
      t.index "lower((inmate_name)::text)", name: "pd_bookings_inmate_name_index_2"
      t.index ["inmate_name"], name: "pd_bookings_inmate_name_index"
    end

    create_table "pd_offense_minutes", force: :cascade do |t|
      t.bigint "offense_id", null: false
      t.datetime "minute_date", precision: nil
      t.string "minute"
      t.string "minute_by"
      t.string "judge"
      t.string "next_proceeding"
      t.index ["offense_id"], name: "index_pd_offense_minutes_on_offense_id"
    end

    create_table "pd_offenses", force: :cascade do |t|
      t.bigint "booking_id", null: false
      t.string "docket_id"
      t.integer "offense_seq"
      t.string "case_number"
      t.string "offense_code"
      t.string "offense_special_code"
      t.string "offense_description"
      t.string "offense_category"
      t.string "court"
      t.string "judge"
      t.datetime "court_date", precision: nil
      t.float "bond_amount"
      t.string "bond_type"
      t.integer "jail_term"
      t.string "jail_sentence_term_type"
      t.datetime "jail_conviction_date", precision: nil
      t.datetime "jail_start_date", precision: nil
      t.string "form41_filed"
      t.string "docsentence_term"
      t.string "docsentence_term_type"
      t.datetime "docsentence_date", precision: nil
      t.string "docnotified"
      t.string "sentence_agent"
      t.string "narative"
      t.string "disposition"
      t.datetime "disposition_date", precision: nil
      t.datetime "entered_date", precision: nil
      t.string "entered_by"
      t.datetime "modified_date", precision: nil
      t.string "modified_by"
      t.virtual "clean_case_number", type: :string, as: "\nCASE\n    WHEN ((case_number)::text ~ '^[A-Za-z]{2,3}-?[0-9]{2,4}-[0-9]{2,8}'::text) THEN ((((\"substring\"((case_number)::text, '^([A-Za-z]{2,3})-?[0-9]{2,4}-[0-9]{2,8}'::text) || '-'::text) ||\n    CASE\n        WHEN (length(\"substring\"((case_number)::text, '^[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text)) = 2) THEN\n        CASE\n            WHEN ((\"substring\"((case_number)::text, '^[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text))::integer <= 40) THEN ('20'::text || \"substring\"((case_number)::text, '[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text))\n            ELSE ('19'::text || \"substring\"((case_number)::text, '[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text))\n        END\n        ELSE \"substring\"((case_number)::text, '^[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text)\n    END) || '-'::text) || regexp_replace(\"substring\"((case_number)::text, '^[A-Za-z]{2,3}-?[0-9]{2,4}-([0-9]{2,8})'::text), '^0+'::text, ''::text))\n    ELSE NULL::text\nEND", stored: true
      t.index ["booking_id"], name: "index_pd_offenses_on_booking_id"
      t.index ["clean_case_number"], name: "pd_offenses_clean_case_number_index"
    end

    change_table "tulsa_blotter_arrests", force: :cascade do |t|
      t.virtual "clean_dlm", type: :string, as: "ltrim((dlm)::text, '0'::text)", stored: true
    end

    change_table "tulsa_blotter_offenses", force: :cascade do |t|
      t.virtual "clean_case_number", type: :string, as: "\nCASE\n    WHEN ((case_number)::text ~ '^[A-Za-z]{2}-[0-9]{4}-[0-9]{1,}'::text) THEN (\"substring\"((case_number)::text, 1, 8) || regexp_replace(\"substring\"((case_number)::text, 9), '^0+'::text, ''::text))\n    WHEN ((case_number)::text ~ '^[A-Za-z]{2}-[0-9]{2}-[0-9]{1,}'::text) THEN ((((\"substring\"((case_number)::text, 1, 2) || '-'::text) ||\n    CASE\n        WHEN ((\"substring\"((case_number)::text, 4, 2))::integer <= 40) THEN ('20'::text || \"substring\"((case_number)::text, 4, 2))\n        ELSE ('19'::text || \"substring\"((case_number)::text, 4, 2))\n    END) || '-'::text) || regexp_replace(\"substring\"((case_number)::text, 7), '^0+'::text, ''::text))\n    ELSE NULL::text\nEND", stored: true
      t.index ["clean_case_number"], name: "tulsa_blotter_offenses_clean_case_number_index"
    end

    create_table "users", force: :cascade do |t|
      t.string "email", default: "", null: false
      t.string "encrypted_password", default: "", null: false
      t.string "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer "sign_in_count", default: 0, null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string "current_sign_in_ip"
      t.string "last_sign_in_ip"
      t.integer "failed_attempts", default: 0, null: false
      t.string "unlock_token"
      t.datetime "locked_at"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.boolean "admin_role", default: false
      t.boolean "user_role", default: true
      t.string "otp_secret"
      t.integer "consumed_timestep"
      t.boolean "otp_required_for_login"
      t.index ["email"], name: "index_users_on_email", unique: true
      t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    end

    add_foreign_key "ok_county_jail_offenses", "ok_county_jail_bookings"
    add_foreign_key "pd_offense_minutes", "pd_offenses", column: "offense_id"
    add_foreign_key "pd_offenses", "pd_bookings", column: "booking_id"


  end
end
