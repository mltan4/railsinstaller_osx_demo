class ItemsController < ApplicationController
  before_filter :authenticate_user!
  skip_before_filter :authenticate_user!, :only=> [:index, :show, :search]

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
      @items = Item.search_item_by_title(params["item_title"].to_s.downcase,1)
    else # Search by parameters
      if params["category_id"].to_s.downcase != ""
        @items = Item.where(:category_id => params["category_id"], :status => 1)
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
#    @seller = User.find(@item.seller_id)
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
    @item.seller_id = current_user.id
    @item.save!

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
    if params[:item] != {}
      @item.title = @item.display_title.downcase
    end
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

  def buy_now
    @item = Item.find(params[:id])
    puts(current_user.id)
    @item.current_bidder_id = current_user.id
    @buyer_user = User.find(@item.current_bidder_id)
    @seller_user = User.find(@item.seller_id)
    UserMailer.welcome_email(@buyer_user).deliver
    UserMailer.welcome_email(@seller_user).deliver
    @item.status = 2
    @item.save
  end

  def close_expired_bids
    puts ("Lookup for expired items")
    @expired_items = Item.find_by_sql("select * from btb_bestbay_development.items i where TIMESTAMPADD(DAY,i.bid_duration,i.created_at) < NOW() AND i.status = 1;")
    puts("Expired items found: " + @expired_items.count.to_s)

    @expired_items.each do |item|
      if (item.current_bidder_id.nil?)
        item.status = 4 # Bid ended with no bids
      elsif
        item.status = 3 # Bid ended with a winning bid
        #TODO: Send an email to the winner bidder
      end
      item.save
      puts ("Item ID: " + item.id + "updated")
    end
    #puts ("DISABLED TO AVOID DB OVERHEAD")
  end


  def place_bid
    @item = Item.find(params[:id])
    @category = Category.find(@item.category_id)
    @item_end_date = @item.created_at + @item.bid_duration.to_i.days
    @current_bid = params["current_bid"]
    # Still an active item?
    if (@item_end_date <= DateTime.current)
      if(Integer(@current_bid) < @item.minimum_bid_price) # Current bid lower than minimum bid
        flash[:alert] = "Please place a bid higher than $" + @item.minimum_bid_price.to_s
      elsif(Integer(@current_bid) >= @item.buy_price && (@item.buy_price > 0)) # Current bid greater than "buy now" price
        flash[:alert] = "Hey, you're bidding way to high! You should \"Buy Now\" instead!"
      elsif (Integer(@current_bid) >= @item.current_bid) # Current bid greater than minimum bid
        if (!@item.current_bidder_id.nil?) # If its the first bid
          @user = User.find(@item.current_bidder_id)
          #TODO: Refactor send email method
          UserMailer.welcome_email(@user).deliver
        end
        @item.current_bid =  @current_bid
        @item.minimum_bid_price = Integer(@current_bid) + 1
        @item.current_bidder_id = current_user.id
        @item.save!
      end
    end
    render("show")
  end

end
