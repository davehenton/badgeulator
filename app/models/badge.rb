class Badge < ActiveRecord::Base
  has_attached_file :picture, styles: { badge: "300x400>", thumb: "150x200>" }, processors: [:cropper]
  has_attached_file :card, styles: { preview: [ "318x200>", :jpg ] } # TODO! , processors: [:pdf2ppm]

  attr_accessor :crop_x, :crop_y, :crop_h, :crop_w

  validates_attachment :picture, content_type: { content_type: "image/jpeg" }
  validates_attachment :card, content_type: { content_type: "application/pdf" }

  validates :name, presence: true
  validates :department, presence: true
  validates :title, presence: true
  validates :employee_id, presence: true

  def cropping?
    return !crop_x.blank?
  end

  def picture_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(picture.path(style))
  end

  def self.lookup_employee(attribute, value)
    info = {}

    if ENV["USE_LDAP"] == "true"
      Rails.logger.debug("using ldap employee lookup")
      require 'net/ldap'

      ldap_config = YAML.load(ERB.new(File.read(Devise.ldap_config || "#{Rails.root}/config/ldap.yml")).result)[Rails.env]
      ldap_config["ssl"] = :simple_tls if ldap_config["ssl"] === true
      ldap_options = {}
      ldap_options[:encryption] = ldap_config["ssl"].to_sym if ldap_config["ssl"]

      ldap = Net::LDAP.new(ldap_options)
      ldap.host = ldap_config["host"]
      ldap.port = ldap_config["port"]
      ldap.base = ldap_config["base"]
      ldap.auth ldap_config["admin_user"], ldap_config["admin_password"] 

      if ldap.bind
        # active_filter = Net::LDAP::Filter.construct("(&
        #     (|(mail=*@kpb.us)(mail=*@borough.kenai.ak.us))
        #     (objectCategory=person)
        #     (objectClass=user)
        #     (givenName=*)
        #     (!(userAccountControl:1.2.840.113556.1.4.803:=2)))")
        results = ldap.search(
          filter: "(#{attribute}=#{value})",      # active_filter, 
          attributes: %w(givenname mail dn sn employeeID manager title department) )
          Rails.logger.debug("#{results.size} results found")        
        if results.size == 1
          results = results.first
          info = {
            name: results.givenname.first + " " + results.sn.first,
            department: results.department.first,
            title: results.title.first,
            employee_id: results.employeeid.first,
          }
        end
      end
    else
      Rails.logger.debug("no employee lookup defined")
    end
    
    info
  end

end
