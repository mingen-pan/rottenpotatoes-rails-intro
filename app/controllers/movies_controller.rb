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
    ## a variable for index to read every option
    @all_ratings = Movie.ratings
    @checked_ratings = @all_ratings.clone
    sorted_key = params.fetch(:sorted, nil)
    ratings = params.fetch(:ratings, nil)

    if sorted_key != nil
      session[:sorted_key] = sorted_key
    end
    if ratings != nil
      session[:ratings] = ratings.keys
    else
      session[:ratings] = @all_ratings
    end

    @movies = Movie.all
    if (session.key? :sorted_key) || (session.key? :ratings)

      if session[:ratings] != nil
        @checked_ratings = session[:ratings]
        @movies = @movies.with_ratings @checked_ratings
      end

      if session[:sorted_key] == 'title'
        @movies = @movies.order :title
      elsif session[:sorted_key] == 'release_date'
        @movies = @movies.order :release_date
      end
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
