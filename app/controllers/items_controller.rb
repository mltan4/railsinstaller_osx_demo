class ItemsController < ApplicationController
  #before_filter :signed_in_user
  # GET /items
  # GET /items.json
  def index
    @items = Item.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end
  end

  def search
    if params["item_title"].to_s.downcase != "" # Search by title
      @items = Item.search_item_by_title(params["item_title"].to_s.downcase)
    else # Search by parameters
      if params["category_id"].to_s.downcase != ""
        @items = Item.where(:category_id => params["category_id"])
      end
    end

    #TODO: Control blank search
    #if params["item_title"] && params["category_id"] == nil
    #  @items = Item.search_item_by_title("")
    #end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    #Shows the item as identified by the id parameter
    @item = Item.find(params[:id])
    @category = Category.find(@item.category_id)
    @item_end_date = @item.created_at + @item.bid_duration.to_i.days
    #Want to have seller information available, but require a new DB migration
    #TODO: @seller = User.find_by_item_id(@item.id)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new
    #Creates new item
    @item = Item.new
    #Store categories in categories variable for processing
    @categories = Category.all #<!-- added this -->

    4.times {@item.item_images.build}

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
    @categories = Category.all
    4.times {@item.item_images.build}
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(params[:item])
    #Create a new item, store the title downcase for DB for searching
    @item.title = @item.display_title.downcase
    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render json: @item, status: :created, location: @item }
      else
        format.html { render action: "new" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end


  def place_bid
    @item = Item.find(params[:id])
    @category = Category.find(@item.category_id)
    @item_end_date = @item.created_at + @item.bid_duration.to_i.days
    @current_bid = params["current_bid"]
    if(Integer(@current_bid) < @item.minimum_bid_price)
      flash[:notice] = "Please place a bid higher than $" + @item.minimum_bid_price.to_s
    elsif(Integer(@current_bid) > @item.buy_price && (@item.buy_price > 0))
      flash[:notice] = "Hey, you're bidding way to high! You should \"Buy Now\" instead!"
    elsif ((Integer(@current_bid) >= @item.minimum_bid_price) && (Integer(@current_bid) >=@item.current_bid))  #need this bid to be greater than current and minimum bid
      @user = User.find(8)
      UserMailer.welcome_email(@user).deliver
      @item.current_bid =  @current_bid
      @item.minimum_bid_price = Integer(@current_bid) + 1
      @item.save!
    end

    render("show")
    #TODO: Control blank search
    #if params["item_title"] && params["category_id"] == nil
    #  @items = Item.search_item_by_title("")
    #end
  end

end
