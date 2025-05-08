module Offense
  def offense_clean_case_number
    attributes["clean_case_number"]
  end

  def offense_description
    raise 'Not implemented'
  end

  def case_link
    raise 'Not implemented'
  end
end
