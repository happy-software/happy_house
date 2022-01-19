# frozen_string_literal: true

module EventsHelper
  def event_path(event)
    property = event.property
    user     = property.user
    user_property_event_path(user, property, event)
  end

  def event_time(timestamp)
    date_time_format = "%b %d, %Y %I:%M %p %Z"
    timestamp.strftime(date_time_format)
  end
end
