class OpinionsController < ApplicationController
  before_filter :load_opinionable

  def index
    @opinion = @opinionable.opinion
  end

  def new
  end

private

  def load_opinionable
    resource, id = request.path[0...request.path.index('/opinions')].split('/').last(2)
    @opinionable = resource.singularize.classify.constantize.find(id)
  end

end
