require_relative '../lib/day_attribute'
require 'minitest/autorun'

class DayAttributeTest < Minitest::Test
    def setup
        @valid_day_of_the_week_changes = nil
        @valid_is_makeup_class = false
        @valid_is_exam_period = false
        @valid_is_public_holiday = false
        @valid_is_holiday = false
        @valid_comments = nil
    end

    def test_valid_initialization
        attr = DayAttribute.new(
            day_of_the_week_changes: @valid_day_of_the_week_changes,
            is_makeup_class: @valid_is_makeup_class,
            is_exam_period: @valid_is_exam_period,
            is_public_holiday: @valid_is_public_holiday,
            is_holiday: @valid_is_holiday,
            comments: @valid_comments
        )
        assert_equal @valid_day_of_the_week_changes, attr.day_of_the_week_changes
        assert_equal @valid_is_makeup_class, attr.is_makeup_class
        assert_equal @valid_is_exam_period, attr.is_exam_period
        assert_equal @valid_is_public_holiday, attr.is_public_holiday
        assert_equal @valid_is_holiday, attr.is_holiday
        assert_equal @valid_comments, attr.comments
    end

    def test_invalid_day_of_the_week_changes
        assert_raises(ArgumentError) do
            DayAttribute.new(
                day_of_the_week_changes: "Monday",
                is_makeup_class: @valid_is_makeup_class,
                is_exam_period: @valid_is_exam_period,
                is_public_holiday: @valid_is_public_holiday,
                is_holiday: @valid_is_holiday,
                comments: @valid_comments
            )
        end
    end

    def test_invalid_is_makeup_class
        assert_raises(ArgumentError) do
            DayAttribute.new(
                day_of_the_week_changes: @valid_day_of_the_week_changes,
                is_makeup_class: "false",
                is_exam_period: @valid_is_exam_period,
                is_public_holiday: @valid_is_public_holiday,
                is_holiday: @valid_is_holiday,
                comments: @valid_comments
            )
        end
    end

    def test_invalid_is_exam_period
        assert_raises(ArgumentError) do
            DayAttribute.new(
                day_of_the_week_changes: @valid_day_of_the_week_changes,
                is_makeup_class: @valid_is_makeup_class,
                is_exam_period: "false",
                is_public_holiday: @valid_is_public_holiday,
                is_holiday: @valid_is_holiday,
                comments: @valid_comments
            )
        end
    end

    def test_invalid_is_public_holiday
        assert_raises(ArgumentError) do
            DayAttribute.new(
                day_of_the_week_changes: @valid_day_of_the_week_changes,
                is_makeup_class: @valid_is_makeup_class,
                is_exam_period: @valid_is_exam_period,
                is_public_holiday: "false",
                is_holiday: @valid_is_holiday,
                comments: @valid_comments
            )
        end
    end

    def test_invalid_is_holiday
        assert_raises(ArgumentError) do
            DayAttribute.new(
                day_of_the_week_changes: @valid_day_of_the_week_changes,
                is_makeup_class: @valid_is_makeup_class,
                is_exam_period: @valid_is_exam_period,
                is_public_holiday: @valid_is_public_holiday,
                is_holiday: "false",
                comments: @valid_comments
            )
        end
    end

    def test_invalid_comments
        assert_raises(ArgumentError) do
            DayAttribute.new(
                day_of_the_week_changes: @valid_day_of_the_week_changes,
                is_makeup_class: @valid_is_makeup_class,
                is_exam_period: @valid_is_exam_period,
                is_public_holiday: @valid_is_public_holiday,
                is_holiday: @valid_is_holiday,
                comments: 123
            )
        end
    end
end

    