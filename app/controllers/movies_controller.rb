class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]
  
  @@sorting_type = "title"
  @@sorting_order = "ASC"
  
  def initialize
    #@sorting_type = "title"
    #@sorting_order = "ASC"
  end
  
  def switch_sort new_sorter
    if new_sorter == @@sorting_type then
	  if @@sorting_order == "ASC" then
	    @@sorting_order = "DESC"
	  else
	    @@sorting_order = "ASC"
	  end
	else
	  @@sorting_type = new_sorter
	  @@sorting_order = "ASC"
	end
  end

  # GET /movies or /movies.json
  def index
    if params[:field] then
	  switch_sort params[:field]
	end
    @movies = Movie.order("#{@@sorting_type} #{@@sorting_order}")
  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to movie_url(@movie), notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to movie_url(@movie), notice: "Movie was successfully updated." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy!

    respond_to do |format|
      format.html { redirect_to movies_url, notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
end
