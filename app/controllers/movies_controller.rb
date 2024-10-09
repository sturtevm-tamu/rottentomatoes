class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]
  
  def initialize
  end
  
  def initsession
    if session[:sorting_type] == nil then
	  session[:sorting_type] = "title"
	end
	if session[:sorting_order] == nil then
	  session[:sorting_order] = "ASC"
	end
  end
  
  def switch_sort new_sorter
	initsession
  
    if new_sorter == session[:sorting_type] then
	  if session[:sorting_order] == "ASC" then
	    session[:sorting_order] = "DESC"
	  else
	    session[:sorting_order] = "ASC"
	  end
	else
	  session[:sorting_type] = new_sorter
	  session[:sorting_order] = "ASC"
	end
  end

  # GET /movies or /movies.json
  def index
    initsession
  
    if params[:field] then
	  switch_sort params[:field]
	end
    @movies = Movie.order("#{session[:sorting_type]} #{session[:sorting_order]}")
	
	@sorter1 = session[:sorting_type] == "title" ? (session[:sorting_order] == "ASC" ? "↑" : "↓") : ""
	@sorter2 = session[:sorting_type] == "rating" ? (session[:sorting_order] == "ASC" ? "↑" : "↓") : ""
	@sorter3 = session[:sorting_type] == "release_date" ? (session[:sorting_order] == "ASC" ? "↑" : "↓") : ""
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
