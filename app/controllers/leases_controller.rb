class LeasesController < ApplicationController
  before_action :set_property
  before_action :set_lease, only: [:show, :edit, :update, :destroy]
  before_action :logged_in?
  before_action :correct_user

  def index
    @leases = @property.leases.with_eager_loaded_contract
  end

  def new
    @lease = Lease.new
  end

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

  def edit
  end

  def update
    respond_to do |format|
      if @lease.update(lease_params)
        format.html { redirect_to [current_user, @property, @lease], notice: 'Lease was successfully updated.' }
        format.json { render :show, status: :ok, location: [current_user, @property, @lease] }
      else
        format.html { render :edit }
        format.json { render json: @lease.errors, status: :unprocessable_entity }
      end
    end
  end

  def renew
    new_lease = @property.property_interface.renew_lease!

    respond_to do |format|
      if new_lease
        format.html { redirect_to [current_user, @property, new_lease], notice: 'New Lease created!' }
        format.json { render :show, status: :ok, location: [current_user, @property, new_lease] }
      end
    end
  end

  def destroy
    @lease.destroy
    respond_to do |format|
      format.html { redirect_to property_leases_url, notice: 'Lease was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_lease
      @lease = @property.leases.find(params[:id])
    end

    def set_property
      @property = Property.find(params[:property_id])
    end

    def lease_params
      params.require(:lease).permit(:start_date,
                                    :end_date,
                                    :amount,
                                    :lease_frequency_id,
                                    :contract)
    end

    def correct_user
      redirect_to root_url unless Property.find(params[:property_id]).user == current_user
    end
end
