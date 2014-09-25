class NotificationsController < ApplicationController
  before_action :set_notifications
  before_action :set_notification, only: [:destroy]

  def index
    # @notifications = current_user.notifications
  end

  def destroy_all
    @notifications.each do |notification|
      notification.destroy
    end
    redirect_to questions_path
  end

  def destroy
    @notification.destroy
    if @notifications.empty?
      redirect_to questions_path
    else
      redirect_to user_notifications_path
    end
  end

  #################################

  private

  def set_notifications
    @notifications = current_user.notifications
  end

  def set_notification
    @notification = Notification.find(params[:id])
  end

end


