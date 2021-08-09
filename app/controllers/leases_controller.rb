class LeasesController < ApplicationController
  before_action :set_property
  before_action :set_lease, only: [:show, :edit, :update, :destroy]

  # GET /properties/:property_id/leases
  # GET /properties/:property_id/leases.json
  def index
    @leases = @property.leases.with_eager_loaded_contract
  end

  # GET /properties/:property_id/leases/new
  def new
    @lease = Lease.new
  end

  # POST /properties/:property_id/leases
  # POST /properties/:property_id/leases.json
  def create
    @lease = @property.leases.new(lease_params)

    respond_to do |format|
      if @lease.save
        format.html { redirect_to [@current_user, @property, @lease], notice: 'Lease was successfully created.' }
        format.json { render :show, status: :created, location: [@current_user, @property, @lease] }
      else
        format.html { render :new }
        format.json { render json: @lease.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /properties/:property_id/leases/1
  # GET /properties/:property_id/leases/1.json
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

  # GET /properties/:property_id/leases/1/edit
  def edit
  end

  # PATCH/PUT /properties/:property_id/leases/1
  # PATCH/PUT /properties/:property_id/leases/1.json
  def update
    respond_to do |format|
      if @lease.update(lease_params)
        format.html { redirect_to [@property, @lease], notice: 'Lease was successfully updated.' }
        format.json { render :show, status: :ok, location: [@property, @lease] }
      else
        format.html { render :edit }
        format.json { render json: @lease.errors, status: :unprocessable_entity }
      end
    end
  end

  def renew
    property = set_property
    new_lease = property.property_interface.renew_lease!

    respond_to do |format|
      if new_lease
        format.html { redirect_to [@property, new_lease], notice: 'New Lease created!' }
        format.json { render :show, status: :ok, location: [@property, new_lease] }
      end
    end
  end

  # DELETE /properties/:property_id/leases/1
  # DELETE /properties/:property_id/leases/1.json
  def destroy
    @lease.destroy
    respond_to do |format|
      format.html { redirect_to property_leases_url, notice: 'Lease was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lease
      @lease = @property.leases.find(params[:id])
    end

    def set_property
      @property = Property.find(params[:property_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lease_params
      params.require(:lease).permit(:start_date,
                                    :end_date,
                                    :amount,
                                    :lease_frequency_id,
                                    :contract)
    end
end
