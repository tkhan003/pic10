class CommentsController < ApplicationController

  def create
    @comment=Comment.create(params.require(:comment).permit(:comment, :post_id, :user_id))
    @comment.user_id=current_user.id
    if @comment.save
      # logger.warn"CHECK THIS OUT #{@comment.inspect}"
      # logger.warn"#{@comment.user.inspect}"
      # logger.warn"CHECK THIS OUT #{@comment.user.email}"
      redirect_to :back, notice: "comment saved"
    else
      redirect_to :back, notice: "comment couldnt be saved"
    end
  end

end
