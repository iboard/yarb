# SignUpService is tested through '../controllers/sign_up_controller_spec'

describe "Sign Up Service" do

  it "is tested through SignUpController" do
    # Make sure guard will run it
    _source = File.expand_path( '../../../app/services/sign_up_service.rb', __FILE__ )
    _spec   = File.expand_path('../../controllers/sign_up_controller_spec.rb', __FILE__)
    if File.mtime(_source) > File.mtime(_spec)
      FileUtils.touch(_spec)
    end

    expect( File.mtime(_source) <= File.mtime(_spec) ).to be_true
  end

end
