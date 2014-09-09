class OpinionsController < ApplicationController
  before_filter :load_opinionable

  def index
    @opinion = @opinionable.opinion
  end

  def new
  end

private

  def load_opinionable
    resource, id = request.path.split('/').last(3).first(2)
    @opinionable = resource.singularize.classify.constantize.find(id)
  end

end
