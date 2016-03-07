class BadgesController < ApplicationController
  before_action :set_badge, only: [:show, :edit, :update, :destroy, :camera, :print, :image, :snapshot, :preview]

  # GET /badges
  # GET /badges.json
  def index
    @badges = Badge.all
  end

  # GET /badges/1
  # GET /badges/1.json
  def show
  end

  # GET /badges/new
  def new
    @badge = Badge.new
  end

  # GET /badges/1/edit
  def edit
  end

  # POST /badges
  # POST /badges.json
  def create
    @badge = Badge.new(badge_params)

    respond_to do |format|
      if @badge.save
        format.html { redirect_to camera_badge_url(@badge) }
        format.json { render :show, status: :created, location: @badge }
      else
        format.html { render :new }
        format.json { render json: @badge.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /badges/:id/camera
  # shows camera, allows taking of snapshot
  def camera
  end

  # returns snapshot from image
  def image
    # TODO! rework this with paperclip
    send_file "/tmp/picture_#{@badge.id}.jpg", disposition: 'inline'
  end

  def preview
    # TODO! rework this with paperclip
    send_file "/tmp/badge_#{@badge.id}.jpg", disposition: 'inline'
  end

  def print
    # print the badge and save the record

    id = @badge.id

    p = Prawn::Document.new({ page_size: [2.125 * 72, 3.375 * 72], page_layout: :landscape, margin: 7 })

    #p.stroke_axis

    p.move_down 4
    p.text_box "Kenai Peninsula Borough", at: [0, p.cursor], height: 12, width: 134, overflow: :shrink_to_fit, size: 12
    p.move_down 14
    p.text_box @badge.name, at: [0, p.cursor], height: 14, width: 134, overflow: :shrink_to_fit, style: :bold, size: 14
    p.move_down 14
    p.stroke_horizontal_rule
    p.move_down 4
    p.text_box @badge.department, at: [0, p.cursor], height: 10, width: 134, overflow: :shrink_to_fit, style: :italic, size: 10
    p.move_down 10
    p.text_box @badge.title, at: [0, p.cursor], height: 8, width: 134, overflow: :shrink_to_fit, style: :italic, size: 8
    p.move_down 12
    p.text_box '#' + @badge.employee_id, at: [0, p.cursor], height: 10, width: 130, overflow: :shrink_to_fit, size: 10, align: :right
    p.move_down 10

    p.image "/tmp/picture_#{id}.jpg", width: 100, at: [p.bounds.right - 95, p.bounds.top]
    p.image Rails.root.join('app', 'assets', 'images', 'kpblogot.jpg'), width: 90, at: [0, p.bounds.bottom + 86]
    p.render_file("/tmp/badge_#{id}.pdf")  # TODO: put employee number in file name
    
    # # convert to jpg to show a sample
    # horrible quality
    # require 'RMagick'
    # pdf_file_name = "/tmp/badge_#{id}.pdf"
    # img = Magick::Image.read(pdf_file_name)
    # img[0].write("/tmp/badge_#{id}.jpg")

# TODO! this is be in card generate not card print

    system("pdftoppm -r 300 -singlefile /tmp/badge_#{id}.pdf /tmp/badge_#{id} && convert /tmp/badge_#{id}.ppm /tmp/badge_#{id}.jpg")
    @badge.card = "/tmp/badge_#{id}.pdf"
    @badge.save!

    respond_to do |format|
      format.html { redirect_to badges_url }
    end
  end

  # PATCH/PUT /badges/1
  # PATCH/PUT /badges/1.json
  def update
    respond_to do |format|
      if @badge.update(badge_params)
        format.html { redirect_to @badge, notice: 'Badge was successfully updated.' }
        format.json { render :show, status: :ok, location: @badge }
      else
        format.html { render :edit }
        format.json { render json: @badge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /badges/1
  # DELETE /badges/1.json
  def destroy
    @badge.destroy
    respond_to do |format|
      format.html { redirect_to badges_url, notice: 'Badge was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /snapshot
  def snapshot
    id = @badge.id
    File.open("/tmp/picture_#{id}.jpg", 'wb') do |f|
      f.write(request.raw_post)
    end
    @badge.picture =  File.open "/tmp/picture_#{id}.jpg"
    @badge.save!
    File.delete("/tmp/picture_#{id}.jpg") if File.exist?("/tmp/picture_#{id}.jpg")

    respond_to do |format|
      format.html { render text: "" }
      format.json { render json: "", status: :ok }
    end
  end

  def lookup
    # find, don't find, or error
    # use ldap or not
    errors = []
    begin
      info = Badge.lookup_employee("employeeId", params[:id])
    rescue => e
      errors << "#{e.class} #{e.message}"
    end

    respond_to do |format|
      if errors.blank?
        format.html { render :lookup, layout: false, locals: { info: info } }
        format.json { render json: info, status: :ok }
      else
        format.html { render text: "<div class='alert alert-danger'>#{errors.join(', ')}</div>" }
        format.json { render json: errors, status: :not_found }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_badge
      @badge = Badge.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def badge_params
      params.require(:badge).permit(:employee_id, :name, :title, :department)
    end
  
end
