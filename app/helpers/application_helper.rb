module ApplicationHelper
  def render_field_errors(field, errors)
    return unless errors.any?
    content_tag(:ul, id: "errors_for_#{field}", data: { field: field }) do
      safe_join(errors.map { |e| content_tag(:li, e, class: 'mt-1 text-sm text-red-600 font-medium') })
    end
  end
end
