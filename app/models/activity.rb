class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :channel

  paginates_per Kandan::Config.options[:per_page]

  before_create :translate_content

  def user_or_deleted_user
    user || User.deleted_user
  end

  private

  def translate_content
    if user.lang == 'EN'
      self.content_en = content
      self.content_tl = EasyTranslate.translate(content, :from => :en, :to => :tl, :key => 'AIzaSyD2CXYerd8vkdy7VLNU58NdQXJcEckxiNw')
    else
      self.content_en = EasyTranslate.translate(content, :from => :tl, :to => :en, :key => 'AIzaSyD2CXYerd8vkdy7VLNU58NdQXJcEckxiNw')
      self.content_tl = content
    end
  end
end
