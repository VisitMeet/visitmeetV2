class TagsController < ApplicationController
  before_action :authenticate_user!, except: [:autocomplete]
  before_action :set_tag, only: %i[ show edit update destroy ]

  # GET /tags or /tags.json
  def index
    query = params[:query]
    tags = Tag.where('name LIKE ?', "%#{query}%").limit(10)
    render json: tags.map(&:name)
  end

  # GET /tags/1 or /tags/1.json
  def show
  end

  # GET /tags/new
  def new
    @tag = Tag.new
  end

  # GET /tags/1/edit
  def edit
  end

  # POST /tags or /tags.json
  def create
    @tag = Tag.new(tag_params)

    respond_to do |format|
      if @tag.save
        format.html { redirect_to @tag, notice: "Tag was successfully created." }
        format.json { render :show, status: :created, location: @tag }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tags/1 or /tags/1.json
  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to @tag, notice: "Tag was successfully updated." }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1 or /tags/1.json
  def destroy
    @tag.destroy!

    respond_to do |format|
      format.html { redirect_to tags_path, status: :see_other, notice: "Tag was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def autocomplete
    term = params[:term].to_s.downcase
    tag_type = params[:tag_type]
    
    # Popular suggestions if no term provided
    popular_locations = %w[tokyo paris london newyork bali barcelona istanbul rome amsterdam berlin]
    popular_professions = %w[photographer chef guide artist musician historian architect designer foodie local]
    
    tags = case tag_type
           when 'location'
             if term.blank?
               popular_locations
             else
               db_results = LocationTag.where('location ILIKE ?', "%#{term}%").pluck(:location)
               suggested = popular_locations.select { |loc| loc.include?(term) }
               (db_results + suggested).uniq.first(10)
             end
           when 'profession'
             if term.blank?
               popular_professions
             else
               db_results = ProfessionTag.where('profession ILIKE ?', "%#{term}%").pluck(:profession)
               suggested = popular_professions.select { |prof| prof.include?(term) }
               (db_results + suggested).uniq.first(10)
             end
           else
             []
           end
    
    render json: tags.first(10)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = Tag.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tag_params
      params.require(:tag).permit(:name, :tag_type)
    end
end
