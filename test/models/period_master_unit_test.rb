require_relative '../test_helper'
require_relative '../../lib/period_master'

class PeriodMasterTest < Minitest::Test
    def test_period_master_constants
        assert_equal [:p1, :p2, :p3, :p4, :lunch, :p5, :p6, :p7, :p8], PeriodMaster::SEQUENCE
        assert_equal({
            p1: 1,
            p2: 2,
            p3: 3,
            p4: 4,
            lunch: 5,
            p5: 6,
            p6: 7,
            p7: 8,
            p8: 9
        }, PeriodMaster::ORDER)
        assert_equal({
            p1: "1",
            p2: "2",
            p3: "3",
            p4: "4",
            lunch: "昼休み",
            p5: "5",
            p6: "6",
            p7: "7",
            p8: "8"
        }, PeriodMaster::SYMBOL_TO_STRING)
    end
end
