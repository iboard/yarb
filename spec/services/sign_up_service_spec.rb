require_relative '../spec_helper'

describe "Sign Up Service" do

  it "is tested through SignUpController" do
    # Make sure guard will run it
    expect(
      cover_source_by(
        "app/services/sign_up_service.rb",
        "controllers/sign_up_controller_spec.rb"
      )
    ).to be_true
  end

end

