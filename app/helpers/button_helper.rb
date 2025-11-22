module ButtonHelper
  def action_button(text, url_or_params, color: :gray, method: :get, data: {})
    color_classes = button_color_classes(color)

    if method == :delete
      button_to url_or_params,
        method: :delete,
        data: data,
        class: "#{color_classes} px-4 py-2 rounded-md text-sm font-semibold transition-all border-2" do
        text
      end
    else
      link_to text, url_or_params,
        class: "#{color_classes} px-4 py-2 rounded-md text-sm font-semibold transition-all border-2 inline-block"
    end
  end

  private

  def button_color_classes(color)
    case color
    when :blue
      "bg-blue-500 text-white border-blue-700 hover:bg-blue-600 hover:border-blue-800 active:bg-blue-700"
    when :red
      "bg-red-500 text-white border-red-700 hover:bg-red-600 hover:border-red-800 active:bg-red-700"
    when :orange
      "bg-orange-500 text-white border-orange-700 hover:bg-orange-600 hover:border-orange-800 active:bg-orange-700"
    when :green
      "bg-green-500 text-white border-green-700 hover:bg-green-600 hover:border-green-800 active:bg-green-700"
    when :yellow
      "bg-yellow-500 text-white border-yellow-700 hover:bg-yellow-600 hover:border-yellow-800 active:bg-yellow-700"
    else
      "bg-gray-500 text-white border-gray-700 hover:bg-gray-600 hover:border-gray-800 active:bg-gray-700"
    end
  end
end
