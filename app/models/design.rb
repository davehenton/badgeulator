class Design < ActiveRecord::Base
  has_many :sides

  accepts_nested_attributes_for :sides, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true

  def render_card(badge = nil)
    # the document is created with the properties of the front side
    return if sides.empty?

    front = sides.first
    back = sides.last if sides.size > 1

    # TODO! doument should have custom properties too
    p = Prawn::Document.new({ page_size: [front.width, front.height], page_layout: front.orientation_name.downcase.to_sym, margin: front.margin })

    #p.stroke_bounds
    p.stroke_axis step_length: 20 #unless !badge.blank?

    front.artifacts.includes(:properties).each do |artifact|
      # build the properties
      props = {}
      # TODO! these properties/value formats/ranges need to be validated when saved
      artifact.properties.each do |property|
        name = property.name.downcase.to_sym
        value = property.value
        # make sure value is in the right format
        if [:at].include?(name)
          value = []
          property.value.downcase.split(',').each do |v|
            v = v.strip
            if v == "{cursor}"
              value << p.cursor
            elsif v == "{width}"
              value << p.bounds.width
            else
              value << v.to_i
            end
          end
        elsif [:width].include?(name)
          if property.value.downcase == "{width}"
            value = p.bounds.width
          elsif property.value.downcase == "{remaining}"
            value = p.bounds.right
            offset = 0
            offset = props[:left] if props.key?(:left)
            offset = props[:at].first if props.key?(:at)
            value = value - offset
          else
            value = property.value.to_i
          end
        elsif [:height, :size, :rotate].include?(name)
          value = property.value.to_i
        elsif [:overflow, :style, :align, :valign].include?(name)
          value = property.value.downcase.to_sym
        elsif [:position, :vposition].include?(name)
          value = property.value.downcase.to_sym
          if ![:left, :center, :right, :top, :center, :bottom].include?(value)
            value = property.value.to_i rescue 0
          end
        elsif [:final_gap, :fit].include?(name)
          value = property.value == "true"
        end
        props[name] = value
      end
      # post property processing because fit needs width and height
      if props.key?(:fit) && props.key?(:width) && props.key?(:height)
        props[:fit] = [props[:width], props[:height]]
      end

      # render the artifact
      value = artifact.value
      unless badge.blank?
        value = value.gsub("{employee_id}", badge.employee_id)
        value = value.gsub("{name}", badge.name)
        value = value.gsub("{first_name}", badge.first_name)
        value = value.gsub("{last_name}", badge.last_name)
        value = value.gsub("{department}", badge.department)
        value = value.gsub("{title}", badge.title)
        value = value.gsub("{photo}", badge.picture.path(:badge)) unless badge.picture.blank?
        value = value.gsub("{logo}", artifact.logo.path) unless artifact.logo.blank?
      end

      if false
      elsif artifact.name == "fill_rectangle"
        color = p.fill_color
        p.fill_color = props[:color] if props.key?(:color)
        p.fill_rectangle props[:at], props[:width], props[:height]
        p.fill_color = color
      elsif artifact.name == "image"
        if badge.blank? || !File.exist?(value)
          if props.key?(:at) && props.key?(:height) && props.key?(:width)
            p.stroke_rectangle props[:at], props[:width], props[:height]
            p.text_box value, props
          else
            p.text value
          end
        else
          p.image value, props
        end
      elsif artifact.name == "move_down"
        p.move_down value.to_i
      elsif artifact.name == "move_up"
        p.move_up value.to_i
      elsif artifact.name == "textbox" || artifact.name == "text_box"
        p.text_box value, props
        p.move_down props[:height] if props.key?(:height)
      end

      puts "#{artifact.name} #{artifact.value}, #{props}"
    end

    # p.transparent(0.5) do
    #   p.image Rails.root.join('app', 'assets', 'images', 'kpblogot.jpg'), width: 90, at: [0, p.bounds.bottom + 86]
    # end

    # THIS IS WHERE WE WOULD DO THE OTHER SIDE

    if badge.blank?
      filename = "/tmp/design#{id}.pdf"
      p.render_file(filename)

      filename
    else
      filename = "/tmp/badge_#{badge.id}.pdf"
      p.render_file(filename)
      badge.card = File.open filename
      badge.save!
      File.delete filename

      badge.card.path
    end
  end
end
