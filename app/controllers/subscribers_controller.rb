class SubscribersController < ApplicationController
  before_action :set_subscriber, only: %i[ show update destroy ]

  # GET /subscribers or /subscribers.json
  def index
    @subscribers = Subscriber.all
  end

  # GET /subscribers/1 or /subscribers/1.json
  def show
  end

  # POST /subscribers or /subscribers.json
  def create
    @subscriber = Subscriber.new(subscriber_params)

    respond_to do |format|
      if @subscriber.save
        format.html { redirect_to @subscriber, notice: "Subscriber was successfully created." }
        format.json { render :show, status: :created, location: @subscriber }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @subscriber.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /subscribers/1 or /subscribers/1.json
  def update
    respond_to do |format|
      if @subscriber.update(subscriber_params)
        format.html { redirect_to @subscriber, notice: "Subscriber was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @subscriber }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @subscriber.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /subscribers/1 or /subscribers/1.json
  def destroy
    @subscriber.destroy!

    respond_to do |format|
      format.html { redirect_to subscribers_path, notice: "Subscriber was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subscriber
      @subscriber = Subscriber.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def subscriber_params
      params.expect(subscriber: [ :email ])
    end
end
