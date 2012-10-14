class ItemsController < ApplicationController
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
    #@items = Item.find_all_by_category_id(params[:id])
    #@items = Item.search_item_by_title(params[:id].to_s.downcase)

    if params["item_title"].to_s.downcase != "" # Search by title
      @items = Item.search_item_by_title(params["item_title"].to_s.downcase)
    else # Search by parameters
      if params["category_id"].to_s.downcase != ""
        @items = Item.where(:category_id => params["category_id"])
      end
      #if params["id"].to_s.downcase != ""
      #  @items = @items.where(:id => params["id"])
      #end
    end
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
    @categories = Category.all
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
    @categories = Category.all
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
end
