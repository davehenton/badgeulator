json.array!(@badges) do |badge|
  json.extract! badge, :id, :employee_id, :first_name, :last_name, :title, :department
  json.url badge_url(badge, format: :json)
end
