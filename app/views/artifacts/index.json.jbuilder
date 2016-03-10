json.array!(@artifacts) do |artifact|
  json.extract! artifact, :id, :side_id, :name, :order, :description, :value
  json.url artifact_url(artifact, format: :json)
end
