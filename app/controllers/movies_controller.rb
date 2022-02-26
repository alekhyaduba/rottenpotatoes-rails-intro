class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    session.clear unless request.url.include? "/movies"
    # @sort = params[:sort] || session[:sort]
    # if @sort == 'title'
    #   @title_class = 'hilite'
    # elsif @sort =='release_date'
    #   @title_header = 'hilite'
    # end
    @all_ratings = Movie.ratings
    @p_ratings = @all_ratings
    # session[:ratings] = session[:ratings] || @all_ratings
    # params[:ratings].nil? ? @p_ratings = session[:ratings] : @p_ratings = params[:ratings].keys
    # params[:ratings]? @p_ratings = params[:ratings].keys : @p_ratings = session[:ratings] 
    # params[:sort]?  @sort = params[:sort] : @sort  = session[:sort]
    # params[:sort] = @sort
    
    @p_ratings = params[:ratings].keys if params[:ratings] 
    # params[:ratings]? @p_ratings = params[:ratings].keys : @p_rating = @all_ratings
    @sort = params[:sort] if params[:sort]
    # session[:ratings] = @p_ratings
    # session[:sort] = @sort
    
    if @sort
      @movies = Movie.where(rating: @p_ratings).order(@sort)
    else
      @movies = Movie.all
      @movies = Movie.where(rating: @p_ratings)
    end
    # @movies = Movie.where(rating: @p_ratings).order(@sort)
    session[:ratings] = params[:ratings] if !session[:ratings]
    session[:sort] = params[:sort] if params[:sort]
  
    # params[:sort] = session[:sort] if !params[:sort]


    
    # redirect_to movies_path(sort: @sort, ratings: @p_ratings)
    
    # if @sort || @p_ratings
    #   @movies = Movie.where(rating: @p_ratings).order(@sort)
    # else
    #   # @movies = Movie.all
    #   @movies = Movie.where(rating: @p_ratings).order(@sort)
    # end
  
    if (!params[:sort] && !params[:ratings]) && (session[:sort] && session[:ratings])
      flash.keep
      return redirect_to movies_path(sort: session[:sort], ratings: session[:ratings])
    elsif !params[:sort] && session[:sort]
      flash.keep
      return redirect_to movies_path(sort: session[:sort], ratings: params[:ratings])
    elsif !params[:ratings] && session[:ratings]
      flash.keep
      return redirect_to movies_path(sort: params[:sort], ratings: session[:ratings])
    end
    

    

    # sort = params[sort]
    # case sort
    # when 'title'
    #     @movies = Movie.order('title ASC')
    #   when 'release_date'
    #     @movies = Movie.order('release_date ASC')
    # end
    
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
