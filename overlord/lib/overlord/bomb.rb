require 'pry'

class Bomb
  attr_reader :status, :activation_code, :deactivation_code,
    :failed_deactivation_attempts

  def initialize
    @status = :not_booted
    @failed_deactivation_attempts = 0
  end

  def boot(given_activate_code = "1234", given_deactivate_code = "0000")
    return unless @status == :not_booted
    if valid_code?(given_activate_code) && valid_code?(given_deactivate_code)
      @activation_code = given_activate_code
      @deactivation_code = given_deactivate_code
      @status = :inactive
    end
  end

  def activate(code)
   if activation_code == code && @status == :inactive
      @status = :active
   end
  end

  def deactivate(code)
    if @status == :active
      if code == deactivation_code
        @status = :inactive
        @failed_deactivation_attempts = 0
      else
        @failed_deactivation_attempts += 1
        explode if failed_deactivation_attempts >= 3
      end
    end
  end

  def explode
    @status = :exploded if @status == :active
  end

  private

  def valid_code?(code)
    !!(code =~ /^\d{4}$/)
  end
end
