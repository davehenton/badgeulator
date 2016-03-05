json.array!(@badges) do |badge|
  json.extract! badge, :id, :employee_id, :name, :title, :department, :picture
  json.url badge_url(badge, format: :json)
end
