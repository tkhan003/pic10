class FriendshipsController < ApplicationController
  before_action :set_values, only: [:index]
  before_action :set_inverse_state_if_accepted, only: [:index]

 
  def index
    logger.warn "HERE ARE THE #{@requested_friendships.inspect}"
    respond_to do |format|
      format.html{}
      format.json {render json:@friendships}
    end
    # @friend=User.find(@requested_friendships.first.friend_id)
    logger.warn "THIS IS THE USER I WANT TO ADD->#{@requested_friendships}"

    # @friend = User.find(ajaxcall);
    # logger.warn "THIS IS THE USER I WANT TO ADD->#{@friend.inspect}"
  end

  def show
  end

  def edit
  end

  def create
    @friendship = current_user.friendships.new(:friend_id=>params[:friend_id], :state=>'pending');
    # @inverseid = @inverse.id
      if @friendship.save
        logger.warn "friendship saved and the status is now #{@friendship.state}"
         FriendshipMailer.friendship_email(@friendship).deliver_now
        # logger.warn "the inverse relationship id is #{@inverseid}"
      redirect_to :back, notice: 'Friend Request sent.'
      else
        redirect_to root_path, notice: 'User is already your friend!'
      end
    # inverse relationship
    # @friend = @friendship.friend
    # @user = @friendship.user
    # @inverse = @friend.friendships.new(:friend_id=>@user.id, :state=>'requested');
    # if @inverse.save 
    #   logger.warn "inverse saved"
    # else
    #   logger.warn "error making the inverse relationship"
    # end
  end

 
  def update
    @friendship = Friendship.find(params[:id])
    logger.warn "current friendship is #{@friendship.id}"
    logger.warn "the state is currently #{params[:state]}"
    respond_to do |format|
      format.html{}
      format.json{
        if @friendship.update(state: params[:state])
          render json: @friendship
        else
          render json: @friendship.errors, status: :unprocessable_entity
        end
      }
    end
  end
    
  def destroy
    @friendship = Friendship.find(params[:id])
    if @friendship.destroy
      redirect_to friendships_path, notice: "Removed Friendship"
    else
      redirect_to root_path, notice: "couldnt remove"
    end
  end

  private
 
  def set_values
    logger.warn "setting values"
    @friendships = current_user.friendships;
    # logger.warn "#{@friendships}"
    @accepted_friendships=current_user.friendships.where(state:'accepted');
    @declined_friendships=current_user.friendships.where(state:'declined');
    @requested_friendships=current_user.friendships.where(state:'requested');
    @sent_friendships=current_user.friendships.where(state:'pending');
  end

  def set_inverse_state_if_accepted
    @sent_friendships.each do |x|
      logger.warn "THE STATE OF SENT FRIENDSHIP IS #{x.state} and its opposite is: #{x.opposite.first.state}"
      if x.opposite.first.state == "accepted"
        logger.warn "friend accepted your request"
        x.state = "accepted"
        x.save!
      else
        logger.warn "still pending"
      end
    end
  end

end
