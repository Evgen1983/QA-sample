module ApplicationHelper
  
  def author_of?(object)
    user_signed_in?&&(current_user.id == object.user_id)
  end
end
