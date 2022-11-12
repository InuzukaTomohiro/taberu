class Public::NotificationsController < ApplicationController

  def index

    @notifications = current_user.active_notifications
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
    @notification = @notifications.where.not(visitor_id: current_user.id)
    # @visitor = notification.visitor
    # @visited = notification.visited
  end

end