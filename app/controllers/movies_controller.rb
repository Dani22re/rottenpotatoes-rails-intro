class MoviesController < ApplicationController
  def index
    @all_ratings = Movie.all_ratings

    # redirect to RESTful URL if we have saved prefs but no params
    if params[:ratings].blank? && params[:sort_by].blank?
      if session[:ratings].present? || session[:sort_by].present?
        return redirect_to movies_path(
          ratings: (session[:ratings].presence && Hash[session[:ratings].product(['1'])]),
          sort_by: session[:sort_by]
        )
      end
    end

    # which ratings to show
    @ratings_to_show =
      if params[:ratings].present?
        params[:ratings].keys
      elsif session[:ratings].present?
        session[:ratings]
      else
        @all_ratings
      end
    @ratings_to_show = @all_ratings if @ratings_to_show.empty?

    # sort column (whitelist)
    requested_sort = params[:sort_by].presence || session[:sort_by]
    @sort_by = %w[title release_date].include?(requested_sort) ? requested_sort : nil

    # persist choices
    session[:ratings] = @ratings_to_show
    session[:sort_by] = @sort_by

    # query
    @movies = Movie.with_ratings(@ratings_to_show)
    @movies = @movies.order(@sort_by) if @sort_by.present?
  end

  def show
    @movie = Movie.find(params[:id])
  end
end
