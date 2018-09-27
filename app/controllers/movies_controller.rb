class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    sort_choice = params[:sort]
    #handles case when ratings is empty 
    if params[:ratings] == nil
      @selected_ratings = @all_ratings.map { |key| [key, 1] }.to_h
      #{'G' => 1, 'PG' => 1, 'PG-13' => 1, 'R' => 1, 'NC-17' => 1}
    else
      @selected_ratings = params[:ratings]
    end
    
    case sort_choice
    when 'title_header'
      @title_header = 'hilite'
      @movies = Movie.where(:rating => @selected_ratings.keys).order(title: :asc)
    when 'release_date_header'
      @release_date_header = 'hilite'
      @movies = Movie.where(:rating => @selected_ratings.keys).order(release_date: :asc)
    when nil
      @movies = Movie.where(:rating => @selected_ratings.keys)
      
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
