# ==Controller for Categories:
# Each item belongs to a category, this provides the logic for the view
#
# Has actions: index, show, new, edit, create, update, destroy
class CategoriesController < ApplicationController

  # This section displays the list of categories available. For Bestbay, this include laptops, mobile phones, bags, etc.
  #
  # GET /categories
  #
  # GET /categories.json
  def index
    @categories = Category.order("id ASC")
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @categories }
    end
  end

  # This section loads a previously created category with the intention of viewing: "read-only."
  #
  # Loads params[: id] which selects the category for viewing.
  #
  # GET /categories/1
  #
  # GET /categories/1.json
  def show
    @category = Category.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @category }
    end
  end

  # This section builds a new instance of the category. Note that it will not save it yet.
  #
  # When this form is submitted, Rails sends it to the "create" action.
  #
  # GET /categories/new
  #
  # GET /categories/new.json
  def new
    @category = Category.new

    respond_to do |format|
        format.html # new.html.erb
      format.json { render json: @category }
    end
  end

  # This section retrieve a previously created category with the intention of changing its attributes.
  #
  # The changes will not be made or submitted yet.
  #
  # The corresponding view submits to the "update" action to save the changes.
  #
  # Loads params[: id] which selects the category for editing.
  #
  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # This section saves the category that was setup using the "new" action.
  #
  # Loads params[: category] which creates the category in the database.
  #
  # POST /categories
  #
  # POST /categories.json
  def create
    @category = Category.new(params[:category])
    #Creates a new category
    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
        format.json { render json: @category, status: :created, location: @category }
      else
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # This section save the changes made when editing a previously created category.
  #
  # Loads params [: id]  of category that will be updated, then stores param [: category].
  #
  # PUT /categories/1
  #
  # PUT /categories/1.json

  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # This section destroys or deletes a previously created category.
  #
  # Loads params [: id]  of category and destroys it.
  #
  # DELETE /categories/1
  #
  # DELETE /categories/1.json
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to categories_url }
      format.json { head :no_content }
    end
  end
end