# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User::ROLES.each do |r|
  Role.find_or_create_by(name: r)
end

Design.create!([
  {name: "KPB Portrait w/New Logo", sample_file_name: "badge_24.pdf", sample_content_type: "application/pdf", sample_file_size: 725289, sample_updated_at: "2016-03-10 22:19:36", default: true},
  {name: "KPB Traditional Landscape", sample_file_name: nil, sample_content_type: nil, sample_file_size: nil, sample_updated_at: nil, default: nil}
])

Side.create!([
  {design_id: 1, order: 0, orientation: 0, margin: 7, width: 243, height: 153},
  {design_id: 2, order: 0, orientation: 0, margin: 1, width: 153, height: 243}
])

Artifact.create!([
  {side_id: 1, name: "image", order: 10, description: "logo", value: "{attachment}", attachment_file_name: "OldkpblogoT.JPG", attachment_content_type: "image/jpeg", attachment_file_size: 4958, attachment_updated_at: "2016-03-10 18:49:03"},
  {side_id: 1, name: "move_down", order: 20, description: "space for hanger hole", value: "30", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 1, name: "textbox", order: 30, description: "KPB", value: "Kenai Peninsula Borough", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 1, name: "move_down", order: 40, description: "spacing above name", value: "15", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 1, name: "textbox", order: 50, description: "name", value: "{name}", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 1, name: "textbox", order: 60, description: "department", value: "{department}", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 1, name: "textbox", order: 70, description: "title", value: "{title}", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 1, name: "textbox", order: 80, description: "employee id", value: "{employee_id}", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 1, name: "image", order: 90, description: "photo", value: "{photo}", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 2, name: "font", order: 10, description: "Base Font", value: "{attachment}", attachment_file_name: "AlegreyaSC-Regular.ttf", attachment_content_type: "application/x-font-ttf", attachment_file_size: 73388, attachment_updated_at: "2016-03-10 18:44:36"},
  {side_id: 2, name: "fill_gradient", order: 20, description: "background gradient", value: "", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 2, name: "fill_rectangle", order: 30, description: "background rectangle", value: "", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 2, name: "move_down", order: 40, description: "spacing for hole", value: "10", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 2, name: "image", order: 50, description: "photo", value: "{photo}", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 2, name: "fill_rectangle", order: 60, description: "name background", value: "", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 2, name: "image", order: 70, description: "logo", value: "{attachment}", attachment_file_name: "kpblogoshadow.png", attachment_content_type: "image/png", attachment_file_size: 714260, attachment_updated_at: "2016-03-10 18:47:46"},
  {side_id: 2, name: "move_up", order: 80, description: "position text after picture", value: "0", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 2, name: "text_box", order: 90, description: "first name", value: "{first_name}", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 2, name: "move_up", order: 100, description: "adjust for font irregular spacing", value: "10", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 2, name: "font", order: 110, description: "bold", value: "{attachment}", attachment_file_name: "AlegreyaSC-Bold.ttf", attachment_content_type: "application/x-font-ttf", attachment_file_size: 72460, attachment_updated_at: "2016-03-10 22:15:11"},
  {side_id: 2, name: "text_box", order: 120, description: "last name", value: "{last_name}", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 2, name: "font", order: 130, description: "normal", value: "{attachment}", attachment_file_name: "AlegreyaSC-Regular.ttf", attachment_content_type: "application/x-font-ttf", attachment_file_size: 73388, attachment_updated_at: "2016-03-10 22:13:47"},
  {side_id: 2, name: "move_down", order: 140, description: "space after name", value: "0", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 2, name: "text_box", order: 150, description: "department", value: "{department}", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 2, name: "text_box", order: 160, description: "title", value: "{title}", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 2, name: "text_box", order: 170, description: "employee number", value: "Employee # {employee_id}", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 2, name: "move_down", order: 180, description: "spacing after employee number", value: "0", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 2, name: "text_box", order: 190, description: "Kenai Peninsula", value: "Kenai Peninsula", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 2, name: "text_box", order: 200, description: "Borough", value: "Borough", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 2, name: "text_box", order: 210, description: "address", value: "144 N. Binkley St.", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 2, name: "text_box", order: 220, description: "city state zip", value: "Soldotna, AK 99669", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 2, name: "move_down", order: 230, description: "spacing above phone", value: "0", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 2, name: "text_box", order: 240, description: "phone", value: "(907) 262-4441", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil},
  {side_id: 2, name: "text_box", order: 250, description: "url", value: "www.kpb.us", attachment_file_name: nil, attachment_content_type: nil, attachment_file_size: nil, attachment_updated_at: nil}
])

Property.create!([
  {artifact_id: 2, name: "align", value: "left"},
  {artifact_id: 4, name: "align", value: "left"},
  {artifact_id: 5, name: "align", value: "left"},
  {artifact_id: 7, name: "align", value: "left"},
  {artifact_id: 22, name: "align", value: "center"},
  {artifact_id: 13, name: "align", value: "center"},
  {artifact_id: 14, name: "align", value: "center"},
  {artifact_id: 15, name: "align", value: "center"},
  {artifact_id: 16, name: "align", value: "center"},
  {artifact_id: 24, name: "align", value: "center"},
  {artifact_id: 18, name: "align", value: "center"},
  {artifact_id: 19, name: "align", value: "center"},
  {artifact_id: 21, name: "align", value: "center"},
  {artifact_id: 20, name: "align", value: "center"},
  {artifact_id: 34, name: "align", value: "center"},
  {artifact_id: 1, name: "at", value: "75, {cursor}"},
  {artifact_id: 2, name: "at", value: "0, {cursor}"},
  {artifact_id: 4, name: "at", value: "0, {cursor}"},
  {artifact_id: 5, name: "at", value: "0, {cursor}"},
  {artifact_id: 7, name: "at", value: "0, {cursor}"},
  {artifact_id: 8, name: "at", value: "155, 90"},
  {artifact_id: 11, name: "at", value: "0, {cursor}"},
  {artifact_id: 17, name: "at", value: "-2, 75"},
  {artifact_id: 22, name: "at", value: "60, 16"},
  {artifact_id: 13, name: "at", value: "0, {cursor}"},
  {artifact_id: 14, name: "at", value: "0, {cursor}"},
  {artifact_id: 15, name: "at", value: "0, {cursor}"},
  {artifact_id: 16, name: "at", value: "0, {cursor}"},
  {artifact_id: 24, name: "at", value: "0, {cursor}"},
  {artifact_id: 18, name: "at", value: "60, {cursor}"},
  {artifact_id: 19, name: "at", value: "70, {cursor}"},
  {artifact_id: 21, name: "at", value: "60, 24"},
  {artifact_id: 20, name: "at", value: "70, {cursor}"},
  {artifact_id: 27, name: "at", value: "0, {cursor}"},
  {artifact_id: 31, name: "at", value: "0, {height}"},
  {artifact_id: 34, name: "at", value: "60, {cursor}"},
  {artifact_id: 27, name: "color", value: "FFFF99"},
  {artifact_id: 30, name: "color1", value: "0682CF"},
  {artifact_id: 30, name: "color2", value: "DAECF8"},
  {artifact_id: 8, name: "fit", value: "true"},
  {artifact_id: 11, name: "fit", value: "true"},
  {artifact_id: 12, name: "fit", value: "true"},
  {artifact_id: 17, name: "fit", value: "true"},
  {artifact_id: 30, name: "from", value: "0, {height}"},
  {artifact_id: 1, name: "height", value: "18"},
  {artifact_id: 2, name: "height", value: "14"},
  {artifact_id: 4, name: "height", value: "14"},
  {artifact_id: 5, name: "height", value: "14"},
  {artifact_id: 7, name: "height", value: "14"},
  {artifact_id: 8, name: "height", value: "90"},
  {artifact_id: 11, name: "height", value: "70"},
  {artifact_id: 12, name: "height", value: "80"},
  {artifact_id: 17, name: "height", value: "75"},
  {artifact_id: 22, name: "height", value: "12"},
  {artifact_id: 13, name: "height", value: "24"},
  {artifact_id: 14, name: "height", value: "24"},
  {artifact_id: 15, name: "height", value: "16"},
  {artifact_id: 16, name: "height", value: "16"},
  {artifact_id: 24, name: "height", value: "16"},
  {artifact_id: 18, name: "height", value: "20"},
  {artifact_id: 19, name: "height", value: "14"},
  {artifact_id: 21, name: "height", value: "12"},
  {artifact_id: 20, name: "height", value: "14"},
  {artifact_id: 27, name: "height", value: "36"},
  {artifact_id: 31, name: "height", value: "{height}"},
  {artifact_id: 34, name: "height", value: "20"},
  {artifact_id: 1, name: "overflow", value: "shrink_to_fit"},
  {artifact_id: 2, name: "overflow", value: "shrink_to_fit"},
  {artifact_id: 4, name: "overflow", value: "shrink_to_fit"},
  {artifact_id: 5, name: "overflow", value: "shrink_to_fit"},
  {artifact_id: 7, name: "overflow", value: "shrink_to_fit"},
  {artifact_id: 13, name: "overflow", value: "shrink_to_fit"},
  {artifact_id: 14, name: "overflow", value: "shrink_to_fit"},
  {artifact_id: 15, name: "overflow", value: "shrink_to_fit"},
  {artifact_id: 16, name: "overflow", value: "shrink_to_fit"},
  {artifact_id: 24, name: "overflow", value: "shrink_to_fit"},
  {artifact_id: 18, name: "overflow", value: "shrink_to_fit"},
  {artifact_id: 19, name: "overflow", value: "shrink_to_fit"},
  {artifact_id: 21, name: "overflow", value: "shrink_to_fit"},
  {artifact_id: 20, name: "overflow", value: "shrink_to_fit"},
  {artifact_id: 22, name: "overflow", value: "shrink_to_fit"},
  {artifact_id: 34, name: "overflow", value: "shrink_to_fit"},
  {artifact_id: 8, name: "position", value: "center"},
  {artifact_id: 12, name: "position", value: "center"},
  {artifact_id: 17, name: "position", value: "center"},
  {artifact_id: 1, name: "size", value: "12"},
  {artifact_id: 2, name: "size", value: "10"},
  {artifact_id: 4, name: "size", value: "10"},
  {artifact_id: 5, name: "size", value: "10"},
  {artifact_id: 7, name: "size", value: "10"},
  {artifact_id: 22, name: "size", value: "8"},
  {artifact_id: 13, name: "size", value: "16"},
  {artifact_id: 14, name: "size", value: "16"},
  {artifact_id: 15, name: "size", value: "10"},
  {artifact_id: 16, name: "size", value: "10"},
  {artifact_id: 24, name: "size", value: "10"},
  {artifact_id: 18, name: "size", value: "12"},
  {artifact_id: 19, name: "size", value: "10"},
  {artifact_id: 21, name: "size", value: "8"},
  {artifact_id: 20, name: "size", value: "10"},
  {artifact_id: 34, name: "size", value: "12"},
  {artifact_id: 1, name: "style", value: "bold"},
  {artifact_id: 30, name: "to", value: "{width}, 0"},
  {artifact_id: 16, name: "up", value: "6"},
  {artifact_id: 24, name: "up", value: "12"},
  {artifact_id: 34, name: "up", value: "16"},
  {artifact_id: 18, name: "up", value: "8"},
  {artifact_id: 19, name: "up", value: "22"},
  {artifact_id: 20, name: "up", value: "24"},
  {artifact_id: 2, name: "valign", value: "middle"},
  {artifact_id: 1, name: "valign", value: "middle"},
  {artifact_id: 4, name: "valign", value: "middle"},
  {artifact_id: 5, name: "valign", value: "middle"},
  {artifact_id: 7, name: "valign", value: "middle"},
  {artifact_id: 22, name: "valign", value: "middle"},
  {artifact_id: 13, name: "valign", value: "middle"},
  {artifact_id: 14, name: "valign", value: "middle"},
  {artifact_id: 15, name: "valign", value: "middle"},
  {artifact_id: 16, name: "valign", value: "middle"},
  {artifact_id: 24, name: "valign", value: "middle"},
  {artifact_id: 18, name: "valign", value: "middle"},
  {artifact_id: 19, name: "valign", value: "middle"},
  {artifact_id: 21, name: "valign", value: "middle"},
  {artifact_id: 20, name: "valign", value: "middle"},
  {artifact_id: 34, name: "valign", value: "middle"},
  {artifact_id: 12, name: "vposition", value: "10"},
  {artifact_id: 8, name: "vposition", value: "center"},
  {artifact_id: 17, name: "vposition", value: "center"},
  {artifact_id: 1, name: "width", value: "163"},
  {artifact_id: 2, name: "width", value: "134"},
  {artifact_id: 4, name: "width", value: "134"},
  {artifact_id: 5, name: "width", value: "134"},
  {artifact_id: 7, name: "width", value: "134"},
  {artifact_id: 8, name: "width", value: "85"},
  {artifact_id: 11, name: "width", value: "70"},
  {artifact_id: 12, name: "width", value: "{width}"},
  {artifact_id: 17, name: "width", value: "75"},
  {artifact_id: 22, name: "width", value: "{remaining}"},
  {artifact_id: 13, name: "width", value: "{width}"},
  {artifact_id: 14, name: "width", value: "{width}"},
  {artifact_id: 15, name: "width", value: "{width}"},
  {artifact_id: 16, name: "width", value: "{width}"},
  {artifact_id: 24, name: "width", value: "{width}"},
  {artifact_id: 18, name: "width", value: "{remaining}"},
  {artifact_id: 19, name: "width", value: "{remaining}"},
  {artifact_id: 21, name: "width", value: "{remaining}"},
  {artifact_id: 20, name: "width", value: "{remaining}"},
  {artifact_id: 27, name: "width", value: "{width}"},
  {artifact_id: 31, name: "width", value: "{width}"},
  {artifact_id: 34, name: "width", value: "{remaining}"}
])
