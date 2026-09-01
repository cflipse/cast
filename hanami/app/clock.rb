require "tzinfo"

module Cast
  class Clock
    TZ = TZInfo::Timezone.get('America/New_York')

    def tz = TZ
    def now = TZ.now
    def today = now.to_date

    def cutoff
      today = now.to_date

      Time.new(today.year, today.month, today.day, 8, 0, 0, TZ)
    end
  end
end
