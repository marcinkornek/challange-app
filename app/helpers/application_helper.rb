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

end
