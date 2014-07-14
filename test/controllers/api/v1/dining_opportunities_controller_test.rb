require 'test_helper'
require 'ultimate_test_helper'

class DiningOpportunitiesControllerTest < UltimateTestHelper
  def setup
    @controller = Api::V1::DiningOpportunitiesController.new
    @attributes = [:id, :dining_opportunity_type, :institution_id, :format]
    @params_index = {:format => :json}
    @params_show = {:id => 2, :dining_opportunity_type => "dinner", :institution_id => 1, :format => :json}
    @params_create = {:dining_opportunity_type => "lunch", :institution_id => 2}
    @params_update = {:dining_opportunity_type => "breakfast"}
    @model_type = :dining_opportunity
    @id = 2
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
  end

  def teardown
     ActionController::Parameters.action_on_unpermitted_parameters = false
  end

  ###################################
  ## TESTS SPECIFIC TO DINING OPPS ##
  ###################################

  test "every dining opportunity for given day has an earliest start and latest end" do

    get :index, @params_index

    assert_response :success

    assert_not_nil assigns(:dining_opportunities), "response must contain the dining_opportunities object"

    # assert_not_nil(@response[:dining_opportunities], "response must contain the dining_opportunities object")

    early_late = []

    (0..6).each { |dow|
      DiningPeriod.where(:day_of_week => dow).pluck(:dining_opportunity_id).each { |opp_id|

        early_late = DiningOpportunity.find(opp_id).earliest_start_latest_end(dow)
        early = early_late[0]
        late = early_late[1]

        # assert start
        assert( ! early.blank? , "the following opportunity has no start: day # #{dow} for #{DiningOpportunity.find(opp_id).dining_opportunity_type}")

        # assert end
        assert( ! late.blank? , "the following opportunity has no end: day # #{dow} for #{DiningOpportunity.find(opp_id).dining_opportunity_type}")

        # assert start is before end
        assert(early < late, "earliest start must always be before latest end")
      }
    }


  end

end
