require 'test_helper'
require 'ultimate_test_helper'

class DiningOpportunitiesControllerTest < UltimateTestHelper
  def setup
    @the_controller = Api::V1::DiningOpportunitiesController.new
    @attributes = [:id, :dining_opportunity_type, :institution_id, :format, :authentication]
    @params_index = {:format => :json, :authentication => session_create}
    @params_show = {:id => 2, :dining_opportunity_type => "dinner", :institution_id => 1, :format => :json, :authentication => session_create}
    @params_create = {:dining_opportunity_type => "lunch", :institution_id => 2}
    @params_update = {:dining_opportunity_type => "breakfast"}
    @model_type = :dining_opportunity
    @model = DiningOpportunity
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

    @controller = @the_controller

    get :index, @params_index

    assert_response :success

    assert_not_nil assigns(:dining_opportunities), "response must contain the dining_opportunities object"

    # assert_not_nil(@response[:dining_opportunities], "response must contain the dining_opportunities object")

    early_late = []

    (0..6).each { |dow|

      early_late = DiningOpportunity.earliest_start_latest_end(dow)

      DiningPeriod.where(:day_of_week => dow).pluck(:dining_opportunity_id).each { |opp_id|

        early = early_late[opp_id][0]
        late = early_late[opp_id][1]

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
