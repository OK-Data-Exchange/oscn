class CreatePdOffenses < ActiveRecord::Migration[6.0]
  def change
    create_table :pd_offenses do |t|
      t.references :booking, null: false, foreign_key: {to_table: :pd_bookings}
      t.string 	:docket_id
      t.string 	:offense_seq 
      t.string	:case_number
      t.string 	:offense_code
      t.string 	:offense_special_code
      t.string	:offense_description
      t.string 	:offense_category
      t.string 	:court
      t.string	:judge
      t.datetime 	:court_date
      t.string 	:bond_amount
      t.string	:bond_type
      t.string 	:jail_term
      t.string 	:jail_sentence_term_type
      t.datetime	:jail_conviction_date
      t.datetime 	:jail_start_date
      t.string 	:form41_filed
      t.string	:docsentence_term
      t.string 	:docsentence_term_type
      t.datetime 	:docsentence_date
      t.string	:docnotified
      t.string 	:sentence_agent
      t.string 	:narative
      t.string	:disposition
      t.datetime 	:disposition_date
      t.datetime 	:entered_date
      t.string	:entered_by
      t.datetime 	:modified_date
      t.string 	:modified_by
    end

  end
end
