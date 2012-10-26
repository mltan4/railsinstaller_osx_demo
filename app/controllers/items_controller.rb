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
    @item = Item.find(params[:id])
    @category = Category.find(@item.category_id)
    @item_end_date = @item.created_at + @item.bid_duration.to_i.days
    #TODO: @seller = User.find_by_item_id(@item.id)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new
    @item = Item.new
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

  def buy_now
    puts("TRYING BUY NOW!!!")
    @item = Item.find(params[:id])
    puts("AAAAAA")
    puts(current_user.id)
    puts("BBBBBB")
    @item.current_bidder_id = current_user.id
    @item.status = 2
    @item.save
  end

  def close_expired_bids
    puts ("testing exp 1")
    @expired_items = Item.find_by_sql("select * from btb_bestbay_development.items i where TIMESTAMPADD(DAY,i.bid_duration,i.created_at) < NOW() AND i.status = 1;")
    puts ("testing exp 2")
    puts(@expired_items.count)
    puts ("testing exp 3")

    @expired_items.each do |item|
      item.status = 4
      item.save
      puts ("done")
    end

  end
end
