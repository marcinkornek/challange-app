module ApplicationHelper
  def full_title(page_title)
    base_title = "Challange App"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def devise_flash
    if controller.devise_controller? && resource.errors.any?
      flash.now[:error] = flash[:error].to_a.concat resource.errors.full_messages
      flash.now[:error].uniq!
    end
  end

  def sortable(column, title = nil)
    column ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to column.titleize, {sort: column, direction: direction}, {class: "#{css_class} btn btn-default btn-sm"}
  end


end
