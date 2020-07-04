require "ruby_home"
require "rpi_gpio"

class HomeServer
  RPI_GPIO_NUMBERING = :board
  RPI_GPIO_PIN = 8

  def initialize
    setup_gpio
    setup_pi_as_bridge
    light = setup_light

    light.on.after_update do |on|
      on ? RPi::GPIO.set_high(RPI_GPIO_PIN) : RPi::GPIO.set_low(RPI_GPIO_PIN)
    end
  end

  def run
    RubyHome.run
  end

  private
  
  def setup_gpio
    RPi::GPIO.set_numbering(RPI_GPIO_NUMBERING)
    RPi::GPIO.setup(RPI_GPIO_PIN, as: :output)
  end

  def setup_pi_as_bridge
    RubyHome::ServiceFactory.create(
      :accessory_information,
      name: "Raspberry Bridge"
    )
  end

  def setup_light
    RubyHome::ServiceFactory.create(:lightbulb,
      on: true,
      name: "Desk Light",
    )
  end
end

HomeServer.new.run
