# -*- encoding : utf-8 -*-"

class UserPresenter

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

  def name_and_email
    [
      view.content_tag(:strong, user.name),
      view.content_tag(:small,  view.mail_link_to( user.email, user.email ))
    ].join( '&nbsp;'*3).html_safe
  end

  def delete_user_link
    view.delete_link_tag view.user_path(user)
  end

  def edit_user_link
    view.edit_button_tag view.t(:edit), view.edit_user_path(user)
  end

  private

  attr_reader :view

end
