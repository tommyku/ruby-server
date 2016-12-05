class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :groups, -> { order 'created_at desc' }
  has_many :notes, -> { order 'created_at desc' }

  has_many :owned_presentations, :class_name => "Presentation", :foreign_key => "user_id"

  has_one :presentation, as: :presentable

  def token_validation_response
    self.as_json(
      except: [
        :tokens, :created_at, :updated_at
      ],
      include: [
        :presentation,
        {:groups => {:include => [:presentation]}},
        {:notes => {:include => [:presentation]}}
      ])
    end

    def serializable_hash(options = {})
      result = super(options)
      result[:single_user_mode] = Rails.configuration.x.neeto.single_user_mode
      result
    end

end
