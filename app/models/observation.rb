require 'couchrest_model'
class Observation < CouchRest::Model::Base
  property :national_id, String
  property :gender, String
  property :age, String
  property :diagnosis_short_name, String
  property :diagnosis_full_name, String
  property :diagnosis_category, String
  property :facility, String
  property :zone, String
  property :obs_date, Date
  property :obs_id, Integer
  timestamps!

  design do
    view :by_national_id
    view :by_gender
    view :by_age
    view :by_diagnosis_short_name
    view :by_diagnosis_full_name
    view :by_diagnosis_category
    view :by_facility
    view :by_zone
    view :by_obs_id_and_facility
    view :by_zone_and_diagnosis_category
    view :by_diagnosis_full_name_and_zone
    view :by_diagnosis_category_and_zone
    view :by_diagnosis_category_and_zone_and_obs_date
    view :by_obs_date
    view :by_diagnosis_category_and_obs_date
    view :by_obs_date_and_diagnosis_category
    view :by_obs_date_and_diagnosis_category_and_zone
    view :by_obs_date_and_diagnosis_category_and_diagnosis_full_name
    view :by_obs_date_and_diagnosis_category_and_zone_and_diagnosis_full_name
  end

end
