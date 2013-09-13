# Helper functions for UsersController
module UsersHelper

  # Array of check-box-options for simple_form
  # @return [Array] [[label, value], [label, value],... ]
  def user_role_checkbox_selection
    Roles::ROLES.map{|r| [ t("roles.#{r}"), r] }
  end

end
