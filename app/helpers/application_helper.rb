module ApplicationHelper
  def active_menu_class(path)
    "text-gray-500" if current_page?(path)
  end
end
