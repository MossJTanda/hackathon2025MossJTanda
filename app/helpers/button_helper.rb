module ButtonHelper
  def action_button(text, url_or_params, color: :gray, method: :get, data: {})
    color_classes = button_color_classes(color)

    if method == :delete
      button_to url_or_params,
        method: :delete,
        data: data,
        class: "#{color_classes} px-3 py-1.5 rounded text-xs font-medium transition-colors" do
        text
      end
    else
      link_to text, url_or_params,
        class: "#{color_classes} px-3 py-1.5 rounded text-xs font-medium transition-colors"
    end
  end

  private

  def button_color_classes(color)
    case color
    when :orange
      "bg-orange-100 text-orange-700 hover:bg-orange-200"
    when :red
      "bg-red-100 text-red-700 hover:bg-red-200"
    when :blue
      "bg-blue-100 text-blue-700 hover:bg-blue-200"
    when :green
      "bg-green-100 text-green-700 hover:bg-green-200"
    when :yellow
      "bg-yellow-100 text-yellow-700 hover:bg-yellow-200"
    else
      "bg-gray-100 text-gray-700 hover:bg-gray-200"
    end
  end
end
