class Victim < EgovUtils::Person

  def to_s
    "#{fullname} (#{I18n.t(:text_born_on_at, place: birth_place, date: I18n.l(birth_date.to_date))})"
  end

end
