import Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase
config :kiosk,
  timezone: "Europe/Rome",
  kiosk: [
    title: "Welcome in Kiosk!"
  ]
