class EntryTypesController < ApplicationController
  before_action :set_type, only: [:show, :edit, :update, :destroy]

  before_filter :auth_as_admin

  # GET /types
  # GET /types.json
  def index
    @entry_types = EntryType.all
  end

  # GET /types/1
  # GET /types/1.json
  def show
  end

  # GET /types/new
  def new
    @entry_type = EntryType.new
  end

  # GET /types/1/edit
  def edit
  end

  # POST /types
  # POST /types.json
  def create
    @entry_type = EntryType.new(type_params)

    respond_to do |format|
      if @entry_type.save
        format.html { redirect_to @entry_type, notice: 'Type was successfully created.' }
        format.json { render :show, status: :created, location: @entry_type }
      else
        format.html { render :new }
        format.json { render json: @entry_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /types/1
  # PATCH/PUT /types/1.json
  def update
    respond_to do |format|
      if @entry_type.update(type_params)
        format.html { redirect_to @entry_type, notice: 'Type was successfully updated.' }
        format.json { render :show, status: :ok, location: @entry_type }
      else
        format.html { render :edit }
        format.json { render json: @entry_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /types/1
  # DELETE /types/1.json
  def destroy
    @entry_type.destroy
    respond_to do |format|
      format.html { redirect_to entry_types_url, notice: 'Type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_type
      @entry_type = EntryType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def type_params
      params.require(:entry_type).permit(:name, :is_default, :position, :value_type, :diff_entry_type1_id, :diff_entry_type2_id)
    end
end
