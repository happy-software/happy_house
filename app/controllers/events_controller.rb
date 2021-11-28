class EventsController < ApplicationController
  before_action :correct_user
  before_action :set_property
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = @property.events
  end

  def show
  end

  def edit
  end

  def new
    @event = @property.events.new
  end

  def create
    @event = @property.events.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to [@current_user, @property, @event], notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: [@current_user, @property, event] }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to [current_user, @event.property, @event], notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: [current_user, @event.property, @event] }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to user_property_events_url, notice: 'Event was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_event
    @event = @property.events.find(params[:id])
  end

  def set_property
    @property = Property.find(params[:property_id])
  end

  def event_params
    params.require(:event).permit(:title, :starts_at, :ends_at, :content)
  end

  def correct_user
    redirect_to root_url unless Property.find(params[:property_id]).user == current_user
  end
end
