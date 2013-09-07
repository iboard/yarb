require_relative '../spec_helper'

describe "Change Password Service" do

  it "is tested through UsersController" do
    # Make sure guard will run it
    expect(
      cover_source_by(
        "app/services/change_password_service.rb",
        "controllers/users_controller_spec.rb"
      )
    ).to be_true
  end

end

