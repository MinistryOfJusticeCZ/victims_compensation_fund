class Offender < ApplicationRecord
  belongs_to :person, class_name: 'EgovUtils::Person'
  belongs_to :claim
  has_many :appeals
  has_many :debts

  accepts_nested_attributes_for :person

  def to_s
    case person.person_type
    when 'natural'
      "#{person.fullname} (#{I18n.t(:text_born_on_at, place: person.natural_person.birth_place, date: I18n.l(person.natural_person.birth_date.to_date))})"
    else
      person.to_s
    end
  end
end
