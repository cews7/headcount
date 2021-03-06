require_relative 'test_helper'
require_relative '../lib/district'
require_relative '../lib/district_repository'


class DistrictTest < Minitest::Test
  def test_name_returns_upcased_string
    d = District.new({:name => "Colorado"})

    assert_equal "COLORADO", d.name
  end

  def test_district_repo_is_nil_by_default
    d = District.new({:name => "Colorado"})

    refute d.district_repo
  end

  def test_district_repo_is_not_nil_after_data_is_loaded
    dr = DistrictRepository.new

    dr.load_data({
                    :enrollment => {
                      :kindergarten => "./data/Kindergartners in full-day program.csv",
                      :high_school_graduation => "./data/High school graduation rates.csv"
                                    }
                  })

    district = dr.find_by_name("COLORADO")
    assert district.district_repo
  end

  def test_relationship_between_district_and_enrollment
    dr = DistrictRepository.new

    dr.load_data({
                    :enrollment => {
                      :kindergarten => "./data/Kindergartners in full-day program.csv",
                      :high_school_graduation => "./data/High school graduation rates.csv"
                                    }
                  })

    district = dr.find_by_name("ACADEMY 20")

    assert_instance_of District, district
    assert_equal "ACADEMY 20", district.enrollment.name
    assert_instance_of EnrollmentRepository, district.district_repo.enrollments
  end

  def test_relationship_between_district_and_statewidetest
    dr = DistrictRepository.new

    dr.load_data({
                    :enrollment => {
                      :kindergarten => "./data/Kindergartners in full-day program.csv",
                      :high_school_graduation => "./data/High school graduation rates.csv",
                                    },
                    :statewide_testing => {
                      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                                           }
                  })

    district = dr.find_by_name("ACADEMY 20")

    assert_instance_of District, district
    assert_equal "ACADEMY 20", district.statewide_test.name
    assert_instance_of StatewideTestRepository, district.district_repo.statewidetests
  end

  def test_relationship_between_district_and_economic_profile
    dr = DistrictRepository.new

    dr.load_data({
                  :enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv",
                    :high_school_graduation => "./data/High school graduation rates.csv",
                                  },
                  :statewide_testing => {
                    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                                         },
                  :economic_profile => {
                    :median_household_income => "./data/Median household income.csv",
                    :children_in_poverty => "./data/School-aged children in poverty.csv",
                    :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                    :title_i => "./data/Title I students.csv"
                                        }
                  })

      district = dr.find_by_name("ACADEMY 20")

      assert_instance_of District, district
      assert_equal "ACADEMY 20", district.economic_profile.name
      assert_instance_of EconomicProfileRepository, district.district_repo.economic_profiles
  end
end
