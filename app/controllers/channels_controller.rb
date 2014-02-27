class ChannelsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_channel_by_name, :only => :show
  load_and_authorize_resource
  before_filter :set_channel_owner, only: :create

  def index
    # NOTE Eager loading doesn't respect limit
    nested_channel_data = []

    @channels = Channel.where(id: current_user.allowed_channels)

    # TODO this can be shortened
    @channels.each do |channel|
      activities = []
      more_activities = (channel.activities.count > Kandan::Config.options[:per_page])
      channel.activities.order('id DESC').includes(:user).page.each do |activity|
        activities.push activity.attributes.merge({
          :user => activity.user_or_deleted_user.as_json(:only => [:id, :email, :first_name, :last_name, :gravatar_hash, :active, :locale, :username, :avatar_url, :lang])
        })
      end

      nested_channel_data.push channel.attributes.merge({:activities => activities.reverse, :more_activities => more_activities})
    end
    
    respond_to do |format|
      format.json { render :text => nested_channel_data.to_json }
    end
  end

  def create
    if current_user.is_admin? || @channel.private_channel?
      if @channel.save
        current_user.allowed_channels << @channel.id.to_s
        current_user.save

        if @channel.private_channel?
          guess = User.find params[:guess_id]
          guess.allowed_channels << @channel.id
          guess.save
        end

        respond_to do |format|
          format.json { render :json => @channel, :status => :created }
        end
      else
        respond_to do |format|
          format.json { render :json => @channel.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  def show
    if current_user.allowed_channels.include?(@channel.id.to_s)
      respond_to do |format|
        format.json { render :json => @channel }
      end
    end
  end

  def update
    respond_to do |format|
      if current_user.allowed_channels.include?(@channel.id.to_s) and @channel.update_attributes(params[:channel])
        format.json { render :json => @channel, :status => :ok }
      else
        format.json { render :json => @channel.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    if current_user.allowed_channels.include?(@channel.id.to_s)
      @channel.destroy
    end

    respond_to do |format|
      format.json { render :json => nil, :status => :ok }
    end
  end

  private

  def find_channel_by_name
    @channel = Channel.where("LOWER(name) = ?", params['id'].downcase).first
  end

  def set_channel_owner
    #if current_user.allowed_channels.split(',').include?(@channel.id)
      @channel.user = current_user
    #end
  end
end
