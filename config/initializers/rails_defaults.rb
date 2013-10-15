ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :datetime_military => '%Y-%m-%d %H:%M',
  :datetime          => '%Y-%m-%d %I:%M%P',
  :time              => '%I:%M%P',
  :time_military     => '%H:%M%P',
  :datetime_short    => '%m/%d %I:%M',
  :date_short        => '%m月%d日'
)

ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(
  :date_full         => '%Y年%m月%d日',
  :date_short        => '%m月%d日'
)
