class NotificationsController < ApplicationController
  before_action :set_notifications, only: [:index, :update_all]
  before_action :set_notification, only: [:update]

  def index
    @notifications = @notifications.paginate(page: params[:page], per_page: 10 )
  end

  def update_all
    @notifications.each do |notification|
      notification.update_attribute('read', true)
    end
    redirect_to notifications_path
  end

  def update
    @notification.update_attribute('read', true)
    redirect_to question_path(@notification.question_id)
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


