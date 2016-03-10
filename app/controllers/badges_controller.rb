class BadgesController < ApplicationController
  before_action :set_badge, only: [:show, :edit, :update, :destroy, :camera, :print, :snapshot, :crop]

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

  def print
    # print the badge

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

  # GET /badges/1/crop
  def crop
    ratio = @badge.picture_geometry(:original).width / @badge.picture_geometry(:badge).width
    @badge.crop_x = params[:x].to_i * ratio
    @badge.crop_y = params[:y].to_i * ratio
    @badge.crop_w = params[:w].to_i * ratio
    @badge.crop_h = params[:h].to_i * ratio

    @badge.picture.reprocess! :badge
    @badge.picture.reprocess! :thumb

    Design.first.render_card(@badge)
    @badge.update_ad_thumbnail

    respond_to do |format|
      format.html { render text: @badge.card.url(:preview) }
      format.json { render json: { url: @badge.card.url(:preview) } }
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
      format.html { render text: @badge.picture.url(:badge) }
      format.json { render json: { url: @badge.picture.url(:badge) }, status: :ok }
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
      params.require(:badge).permit(:employee_id, :name, :title, :department, :dn)
    end
  
end
