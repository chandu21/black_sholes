class OptionsController < ApplicationController
  
    before_filter :authenticate_user!
  
  # GET /options
  # GET /options.json
  def index
    @options = current_user.options.order("created_at DESC").page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @options }
    end
  end

  # GET /options/1
  # GET /options/1.json
  def show
    @option = current_user.options.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @option }
    end
  end

  # GET /options/new
  # GET /options/new.json
  def new
    @option = current_user.options.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @option }
    end
  end

  # GET /options/1/edit
  def edit
    @option = current_user.options.find(params[:id])
  end

  # POST /options
  # POST /options.json
  def create
    @option = current_user.options.build(params[:option])
    option_params = params[:option]
    @prices = Option.black_scholes_call_price(option_params[:price].to_i,option_params[:strike].to_i,option_params[:riskfree].to_i,option_params[:dividend].to_f,option_params[:term].to_f,option_params[:volatility].to_f) 
    @option.call_price = @prices[0]
    @option.put_price = @prices[1]
    respond_to do |format|
      if @option.save
        format.html { redirect_to @option, notice: 'Option was successfully created.' }
        format.json { render json: @option, status: :created, location: @option }
      else
        format.html { render action: "new" }
        format.json { render json: @option.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /options/1
  # PUT /options/1.json
  def update
    @option = Option.find(params[:id])
    option_params = params[:option]
    @prices = Option.black_scholes_call_price(option_params[:price].to_i,option_params[:strike].to_i,option_params[:riskfree].to_i,option_params[:dividend].to_f,option_params[:term].to_f,option_params[:volatility].to_f) 
    @option.update_attributes(:call_price => @prices[0] ,:put_price => @prices[1]) 
    respond_to do |format|
      if @option.update_attributes(params[:option])
        format.html { redirect_to @option, notice: 'Option was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render 'edit' }
        format.json { render json: @option.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /options/1
  # DELETE /options/1.json
  def destroy
    @option = Option.find(params[:id])
    @option.destroy

    respond_to do |format|
      format.html { redirect_to options_url }
      format.json { head :ok }
    end
  end
end
