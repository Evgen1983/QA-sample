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
    
    can :create, [ Question, Answer, Comment ]
    can :update, [ Question, Answer ], user: user
    can :destroy, [ Question, Answer ], user: user


    can :vote_up, Question
    can :vote_down, Question
    can :vote_cancel, Question

    cannot :vote_up, Question, user: user
    cannot :vote_down, Question, user: user
    cannot :vote_cancel, Question, user: user

    
    can :set_best_answer, Answer, question: { user: user }

    can :vote_up, Answer
    can :vote_down, Answer
    can :vote_cancel, Answer

    cannot :vote_up, Answer, user: user
    cannot :vote_down, Answer, user: user
    cannot :vote_cancel, Answer, user: user
  end
end
