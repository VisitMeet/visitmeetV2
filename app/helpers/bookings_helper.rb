module BookingsHelper
  def status_badge_class(status)
    case status.to_s
    when 'pending'
      'bg-yellow-100 text-yellow-800'
    when 'accepted'
      'bg-green-100 text-green-800'
    when 'declined'
      'bg-red-100 text-red-800'
    when 'cancelled'
      'bg-gray-100 text-gray-800'
    when 'completed'
      'bg-blue-100 text-blue-800'
    else
      'bg-gray-100 text-gray-800'
    end
  end
end
