class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  validates_format_of :email, :without => /change@me.com/, on: :update

  has_one :identity

  def self.find_for_oauth(auth, signed_in_resource = nil)
    identity = Identity.find_for_oauth(auth)
    user = identity.user
    if user.nil?
      user = User.where(:email => auth.info.email).first if auth.info.email
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          email: auth.info.email.blank? ? 'change@me.com' : auth.info.email,
          password: Devise.friendly_token[0,20]
        )
        user.save!
      end

      if identity.user != user
        identity.user = user
        identity.save!
      end

      update_events auth.credentials.token

    end
    user
  end

  def self.update_events token
    fb_user = FbGraph::User.new('me', :access_token => token)
    fb_user.fetch
    events = fb_user.events
    if events
      events.each do |e|
        event = Event.find_by(:eid => e.raw_attributes["id"])
        if not event
          event = Event.create(
            description: e.description,
            start_time: e.start_time,
            end_time: e.end_time,
            location: e.location,
            name: e.name,
            venue: e.venue,
            eid: e.raw_attributes["id"]
          )
        end
      end
    end
  end


end
