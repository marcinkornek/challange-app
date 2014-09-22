class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_user? # to use this function in views (without it can be used in controllers only!!)
  def current_user?(user)
    user == current_user
  end

  helper_method :accepted_answer? # to use this function in views (without it can be used in controllers only!!)
  def accepted_answer?(answer)
    answer.id == answer.question.accepted_answer_id
  end

  helper_method :markdown
  def markdown
    options = [escape_html: true, hard_wrap: true, no_intra_emphasis: true, with_toc_data: true]
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(*options), fenced_code_blocks: true, autolink: true)
  end

  ############################################

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation) }

    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }

    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password,
      :password_confirmation, :current_password, :avatar, :avatar_cache,
      :send_new_message_email, :send_accepted_answer_email, :crop_x, :crop_y, :crop_w, :crop_h) }
  end


end

