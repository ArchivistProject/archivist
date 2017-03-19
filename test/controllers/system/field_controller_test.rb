require 'test_helper'

class FieldControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group = Grouping::Group.new(name: 'G')
  end

  teardown do
    @group.destroy
  end

  test 'deleting a field updates the group as well' do
    row1 = Grouping::Row.new(name: 'R1', type: MetadataField::String::TYPE)
    row2 = Grouping::Row.new(name: 'R2', type: MetadataField::Date::TYPE)
    @group.rows << row1 << row2
    @group.save!

    delete system_group_field_path(@group.id, row1.id), headers: http_login

    assert_response :success
    assert_equal 1, Grouping::Group.find(@group.id).rows.size
  end
end
