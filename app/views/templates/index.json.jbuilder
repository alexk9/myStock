json.array!(@templates) do |template|
  json.extract! template, :temp
  json.url template_url(template, format: :json)
end
