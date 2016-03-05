class BadgesController < ApplicationController
  before_action :set_badge, only: [:show, :edit, :update, :destroy]

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
    # @badge = Badge.new(badge_params)

    # respond_to do |format|
    #   if @badge.save
    #     format.html { redirect_to @badge, notice: 'Badge was successfully created.' }
    #     format.json { render :show, status: :created, location: @badge }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @badge.errors, status: :unprocessable_entity }
    #   end
    # end

    # print the badge and save the record

    p = Prawn::Document.new({ page_size: [2.125 * 72, 3.375 * 72], page_layout: :landscape, margin: 7 })

    #p.stroke_axis

    p.move_down 4
    p.text_box "Kenai Peninsula Borough", at: [0, p.cursor], height: 12, width: 134, overflow: :shrink_to_fit, size: 12
    p.move_down 14
    p.text_box info_params[:name], at: [0, p.cursor], height: 14, width: 134, overflow: :shrink_to_fit, style: :bold, size: 14
    p.move_down 14
    p.stroke_horizontal_rule
    p.move_down 4
    p.text_box info_params[:dept], at: [0, p.cursor], height: 10, width: 134, overflow: :shrink_to_fit, style: :italic, size: 10
    p.move_down 10
    p.text_box info_params[:title], at: [0, p.cursor], height: 8, width: 134, overflow: :shrink_to_fit, style: :italic, size: 8
    p.move_down 12
    p.text_box '#' + info_params[:number], at: [0, p.cursor], height: 10, width: 130, overflow: :shrink_to_fit, size: 10, align: :right
    p.move_down 10

    p.image "/tmp/picture_5218.jpg", width: 100, at: [p.bounds.right - 95, p.bounds.top]
    p.image Rails.root.join('app', 'assets', 'images', 'kpblogot.jpg'), width: 90, at: [0, p.bounds.bottom + 86]
    p.render_file("/tmp/badge_.pdf")  # TODO: put employee number in file name
    



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

  # POST /upload_image
  def upload_image
    id = params[:id]
    File.open("/tmp/picture_#{id}.jpg", 'wb') do |f|
      f.write(request.raw_post)
    end
    respond_to do |format|
      format.html { render text: "" }
      format.json { render json: "", status: :ok }
    end
  end

  def lookup
    info = nil
    results = Badge.lookup_employee("employeeId", params[:id])
    if results.present?
      info = {
        name: results.givenname.first + " " + results.sn.first,
        dept: results.department.first,
        title: results.title.first,
        number: results.employeeid.first,
        manager: results.manager.first,
        mail: results.mail.first
      }
    end

    respond_to do |format|
      if !info.blank?
        format.html { render :lookup, layout: false, locals: { info: info } }
        format.json { render json: info, status: :ok }
      else
        format.html { render text: "<div class='alert alert-warning'>Employee not found.</div>" }
        format.json { render json: {}, status: :not_found }
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
      params.require(:badge).permit(:employee_id, :name, :title, :department, :picture)
    end
    
    def info_params
      params.require(:info).permit(:number, :name, :title, :dept)
    end
end
