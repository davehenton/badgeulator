json.array!(@sides) do |side|
  json.extract! side, :id, :design_id, :order, :orientation, :margin, :width, :height
  json.url side_url(side, format: :json)
end
