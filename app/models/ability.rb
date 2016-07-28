class Ability
  include CanCan::Ability

  
  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      quest_abilities
    end
  end

  def quest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    quest_abilities
    alias_action :update, :destroy, :to => :modify
    alias_action :vote_up, :vote_down, :vote_cancel, :to => :vote
    can :create, [ Question, Answer, Comment ]
    can :modify, [ Question, Answer ], user: user
    can :vote, [ Question, Answer ] { |votable| user != votable.user} 
    can :best_answer, Answer, question: { user: user }
    can :destroy, Attachment, attachable: { user: user }
  end
end
