# ==Controller for Items:
# Controller provides the logic for the view, incorporates main logic of the program for bidding
#
# Has actions: index, show, new, edit, create, update, destroy, search, close_expired_bids, place_bid, buy_now
class ItemsController < ApplicationController
  before_filter :authenticate_user!
  skip_before_filter :authenticate_user!, :only=> [:index, :show, :search]

  # This section displays the list of items available regardless of category.
  #
  # GET /items
  #
  # GET /items.json
  def index
    @items = Item.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end
  end

  # Action for searching the items.
  #
  # When this action is initiated, the database is searched by the parameters below. Search can be done in two ways:
  #
  # (1) Loads params[: "item_title"] which searches the item by title
  #
  # (2) Loads params[: "category_id"] which searches the item by category
  #
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

  # This section loads a previously created item with the intention of viewing: "read-only."
  #
  # Loads params[: id] which selects the item for viewing.
  #
  # GET /items/1
  #
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

  # This section builds a new instance of an item. Note that it will not save it yet.
  #
  # When this form is submitted, Rails sends it to the "create" action.
  #
  # GET /items/new
  #
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

  # This section retrieve a previously created item with the intention of changing its attributes but changes will not be made or submitted yet.
  #
  # The corresponding view submits to the "update" action to save the changes.
  #
  # Loads params[: id] which selects the item for editing.
  #
  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
    @categories = Category.all
    4.times {@item.item_images.build}
  end

  # This section saves the item that was setup using the "new" action.
  #
  # Loads params[: item] which creates the item in the database.
  #
  # POST /items
  #
  # POST /items.json
  def create
    @item = Item.new(params[:item])
    #Create a new item, store the title downcase for DB for searching.
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

  # This section save the changes made when editing a previously created item.
  #
  # Loads params [: id]  of category that will be updated, then stores param [: item].
  #
  # PUT /items/1
  #
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

  # This section destroys or deletes a previously created item.
  #
  # Loads params [: id] of item and destroys it.
  #
  # DELETE /items/1
  #
  # DELETE /items/1.json
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end

  # Action for buying an item now, bypasses place_bid.
  #
  # Loads params [: id] of item and performs notification actions.
  #
  # Finds the current buyer and seller and sends them email via UserMailer, then change item_status to 2 (sold).
  #
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

  # Action to close expired bids so that it will not appear in the search results.
  #
  # Change in status include: "4" ended without bids & "3" ended with a winning bid.
  #
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

  # Action to place a bid, loads two parameters:
  #
  # Loads params[: id] which selects the item up for bidding.
  #
  # Loads params [" current_bid"] to compare the current amount to the proposed bidding price.
  #
  # Implements the business rules, i.e. will not allow a bid that is lower than minimum or a bid higher than buy now.
  #
  # Notifies the buyer/seller whenever a bid has been successfully completed.
  #

  def place_bid
    @item = Item.find(params[:id])
    @category = Category.find(@item.category_id)
    @item_end_date = @item.created_at + @item.bid_duration.to_i.days
    @current_bid = params["current_bid"]
    # Still an active item?
    if (DateTime.current < @item_end_date)
      if(Integer(@current_bid) < @item.minimum_bid_price) # Current bid lower than minimum bid
        flash[:alert] = "Please place a bid higher than $" + @item.minimum_bid_price.to_s
      elsif(Integer(@current_bid) >= @item.buy_price && (@item.buy_price > 0)) # Current bid greater than "buy now" price
        flash[:alert] = "Hey, you're bidding way to high! You should \"Buy Now\" instead!"
      elsif (Integer(@current_bid) >= @item.current_bid) # Current bid greater than minimum bid
        if (!@item.current_bidder_id.nil?) # If its the first bid
          @user = User.find(@item.current_bidder_id)
          #TODO: Refactor send email method
          UserMailer.welcome_email(@user).deliver
          puts("IT SHOULD HAVE EMAILED")
        end
        @item.current_bid =  @current_bid
        @item.minimum_bid_price = Integer(@current_bid) + 1
        @item.current_bidder_id = current_user.id
        @item.save!
      end
    else
      flash[:alert] = "This item is no longer available for bidding!"
    end
    render("show")
  end

end
