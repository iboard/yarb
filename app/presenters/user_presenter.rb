# -*- encoding : utf-8 -*-"

# Present a User-object
class UserPresenter

  # Instantiate presenter object
  # @param [User] user - the user to be presented
  # @param [ActionView|ApplicationController] view - used for view-helpers
  # @yield [UserPresenter]
  # @return [UserPresenter]
  def self.present user, view, &block
    presenter = new user, view
    yield presenter if block_given?
    presenter
  end

  attr_reader :user

  def initialize _user, _view
    @user = _user
    @view = _view
  end

  # @return [String] html-string "email@example.com  [envelope] email-link"
  def name_and_email
    [
      view.content_tag(:strong, user.name, class: 'user-name'),
      view.content_tag(:small,  view.mail_link_to( user.email, user.email ), class: 'user-email'),
    ].join('&nbsp;'*3).html_safe
  end

  # @return [String] html-string "confirmed at DATE"
  def email_confirmed_at
    [
      view.content_tag(:strong, view.t("user.confirmed_at")),
      view.content_tag(:small,  user.confirmed_at.to_s, class: 'user-email')
    ].join('&nbsp;'*3).html_safe
  end

  # @return [String] html-string, link to delete user
  def delete_user_link
    view.delete_link_tag view.user_path(user), view.t("user.delete_user")
  end


  # @return [String] html-string, link to edit user
  def edit_user_link
    view.edit_button_tag view.t(:edit), view.edit_user_path(user)
  end


  # Format a div-tag with user-id
  # A right aligned edit-button
  # And the given block
  # @yield
  # @return [String] html-string, div-tag with user-id
  def user_listing_tag &block
    view.content_tag(:div, id: "user-#{user.id}") do
      view.content_tag(:div, class: 'user-fields') do
        view.content_tag(:span) { yield } +
        edit_user_button
      end
    end
  end

  # @return [String] html-string, the user-id as string
  def user_id
    user.id
  end

  # @return [String] html-string, user-roles
  def authentications
    view.t("user.authentications_label").html_safe +
    ApplicationHelper.available_authentication_providers.map { |provider|
      provider if user.authentication(provider)
    }.compact.join(", ")
  end

  # @return [String] html-string, user-roles
  def user_roles
    view.t("user.roles_label").html_safe +
    user.roles.map { |r| view.t("roles.#{r}") }.join(", ")
  end

  # @return [String] html-string, user's email
  def user_email
    user.email
  end

  private

  attr_reader :view

  def edit_user_button
    view.content_tag(:div ) do
      view.edit_button_tag(view.t(:edit),view.edit_user_path(user)) if view.allow_edit_user?(user)
    end
  end
end
