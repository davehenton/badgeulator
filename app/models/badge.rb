require 'ldap_helper'
include LdapHelper

class Badge < ApplicationRecord

  has_attached_file :picture, styles: { badge: "300x400>", thumb: ["96x96#", :png] }, processors: [:cropper]
  has_attached_file :card, styles: { preview: { geometry: "318x200>", format: :png, convert_options: "-png" } }, processors: [:pdftoppm]

  default_scope { order(created_at: :desc) }

  attr_accessor :crop_x, :crop_y, :crop_h, :crop_w

  validates_attachment :picture, content_type: { content_type: ["image/jpeg", "image/png"] }
  validates_attachment :card, content_type: { content_type: "application/pdf" }

  validates :first_name, presence: true
  validates :last_name, presence: true
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

  def self.ad_lookup(attribute, value)
    entry = nil

    if ENV["USE_LDAP"] == "true"
      with_ldap do |ldap|
        results = ldap.search(
          filter: "(#{attribute}=#{value})",      # active_filter,
          attributes: %w(givenname mail dn sn employeeID manager title department thumbnailPhoto) )
        Rails.logger.debug("#{results.size} results found")
        if results.size == 1
          entry = results.first
        end
      end
    end

    entry
  end

  # must populate dn for ad thumbnail to be updated
  def self.lookup_employee(attribute, value)
    info = {}

    if ENV["USE_LDAP"] == "true"
      Rails.logger.debug("using ldap employee lookup")

      entry = ad_lookup(attribute, value)
      unless entry.blank?
        info = {
          first_name: entry.givenname.first,
          last_name:  entry.sn.first,
          department: entry.department.first,
          title: entry.title.first,
          employee_id: entry.employeeid.first,
          dn: entry.dn
        }
        # write current ad thumbnail photo to tmp dir
        # File.open("/tmp/adthumb-#{entry.employeeid.first}", "wb") do |file|
        #   entry.thumbnailPhoto.each do |b|
        #     file.write b
        #   end
        # end
      end
    else
      Rails.logger.debug("no employee lookup defined")
    end

    info
  end

  def name
    "#{first_name} #{last_name}"
  end

  def update_ad_thumbnail
    return if ENV["USE_LDAP"] != "true" || dn.blank? || update_thumbnail == false

    with_ldap do |ldap|
      picture_data = File.binread(picture.path(:thumb))
      ldap.replace_attribute dn, :thumbnailPhoto, picture_data
      raise Exception, "Unable to update thumbnailPhoto - #{ldap.get_operation_result.message}" if ldap.get_operation_result.code != 0
    end
  end
end
