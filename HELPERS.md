View and Application Helpers
============================

Please use the following helpers instead defining your own.
Find the definition of this functions in `helpers/application_helper.rb`
or in `helpers/layout_helper.rb`


File                  | Method                                | Description
----------------------|---------------------------------------|-----------------------------------------
application_helper.rb | def markdown(text)                    | Formatting
application_helper.rb | def render_errors_for object          | HTML-Wrap
application_helper.rb | def alert_box &block                  | HTML-Wrap
application_helper.rb | def render_alert_box_for object       | HTML-Wrap
application_helper.rb | def error_entry_for tag, error        | HTML-Wrap
layout_helper.rb      | def icon symbol                       | HTML-Wrap, Insert Twitter Bootstrap icon
layout_helper.rb      | def icon_with_text symbol, text       | HTML-Wrap
layout_helper.rb      | def delete_link_tag path              | HTML-Wrap, Trash-button red
layout_helper.rb      | def new_button_tag label, path        | HTML-Wrap, Plus-sign button
layout_helper.rb      | def edit_button_tag label, path       | HTML-Wrap, Edit-sign button
layout_helper.rb      | def cancel_button_tag label, path     | HTML-Wrap, cancel/remove icon
layout_helper.rb      | def list_button_tag label, path       | HTML-Wrap, List-icon button
layout_helper.rb      | def save_button_classes               | HTML-Wrap, Primary Button (blue)
layout_helper.rb      | def switch_to_locale_path_link locale | HTML-Wrap, Wrap CSS
layout_helper.rb      | def active_class path                 | CSS-Wrap,  Add class .active if current_path
layout_helper.rb      | def standard_form_classes             | CSS-Wrap, Bootstrap classes
layout_helper.rb      | def model_date_information _model     | CSS-Wrap, define information class
pages_helper.rb       | def page_list_css_sort_options        | CSS-Wrap, define
pages_helper.rb       | def allow_page_sort_class             | true if user can sort
users_helper.rb       | def user_role_checkbox_selection      | String - concatinate translated roles
application_helper    | dev gravatar_tag(email)               | img-tag
to gravatar
