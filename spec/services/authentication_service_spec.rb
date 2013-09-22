require_relative '../spec_helper'

describe "Authentication Service" do

  it "is tested through SignUp" do
    # Make sure guard will run it
    expect(
      cover_source_by(
        "app/services/authentication_service.rb",
        "controllers/sign_up_controller_spec.rb"
      )
    ).to be_true
  end

end

