class NotificationsController < ApplicationController
  before_action :set_notifications, only: [:index, :update_all]
  before_action :set_notification,  only: [:update]

  def index
    @notifications = @notifications.paginate(page: params[:page], per_page: 10 ).order(created_at: :desc)
  end

  def update_all
    @notifications.each do |notification|
      notification.update_attribute('read', true)
    end
    respond_to do |format|
      format.html { redirect_to notifications_path }
      format.js   { render :update_all }
    end
  end

  def update
    @notification.update_attribute('read', true)
    redirect_to question_path(@notification.question_id)
  end

  def update_selected
    @notification_ids = params[:notification_ids]
    if !@notification_ids.nil?
      @notification_ids.each do |notification_id|
        notification = Notification.find(notification_id)
        notification.update_attribute('read', true)
      end
    end
    # Notification.update_all({read: true}, {id: params[:notification_ids]}) #it supposes to work but doesn't;(
    respond_to do |format|
      format.html { redirect_to notifications_path }
      format.js   { render :update_selected }
    end
  end

  #################################

  private

  #before actions

  def set_notifications
    @notifications = current_user.notifications
  end

  def set_notification
    @notification = Notification.find(params[:id])
  end

end


