class LeasesController < ApplicationController
  # before_action :correct_user,   only: [:index, :new, :create, :show, :edit, :update, :destroy]
  before_action :set_lease, only: [:show, :edit, :update, :destroy]

  # GET /leases
  # GET /leases.json
  def index
    properties = current_user&.properties
    @leases = properties&.flat_map(&:leases)
  end

  # GET /leases/1
  # GET /leases/1.json
  def show
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "Lease #{@lease.start_date.year} - #{@lease.property.display_name}",
               :layout => "pdf.html",
               :page_size => 'A4',
               :template => "leases/show.html.erb"
      end
    end
  end

  # GET /leases/new
  def new
    @lease = Lease.new
  end

  # GET /leases/1/edit
  def edit
  end

  # POST /leases
  # POST /leases.json
  def create
    @lease = Lease.new(lease_params)

    respond_to do |format|
      if @lease.save
        format.html { redirect_to @lease, notice: 'Lease was successfully created.' }
        format.json { render :show, status: :created, location: @lease }
      else
        format.html { render :new }
        format.json { render json: @lease.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leases/1
  # PATCH/PUT /leases/1.json
  def update
    respond_to do |format|
      if @lease.update(lease_params)
        format.html { redirect_to @lease, notice: 'Lease was successfully updated.' }
        format.json { render :show, status: :ok, location: @lease }
      else
        format.html { render :edit }
        format.json { render json: @lease.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leases/1
  # DELETE /leases/1.json
  def destroy
    @lease.destroy
    respond_to do |format|
      format.html { redirect_to leases_url, notice: 'Lease was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lease
      @lease = Lease.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lease_params
      params.require(:lease).permit(:start_date,
                                    :end_date,
                                    :amount,
                                    :lease_frequency_id,
                                    :details,
                                    :property_document_id,)
    end

    # def correct_user
    #   leases = @leases
    #
    #   redirect_to root_url unless current_user&.properties.include?()
    # end
end
