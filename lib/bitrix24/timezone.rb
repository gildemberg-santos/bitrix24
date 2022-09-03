# frozen_string_literal: true

module Bitrix24
  @timezone = "America/Sao_Paulo"
  def self.timezone
    @timezone
  end

  def self.timezone=(timezone)
    @timezone = timezone
  end
end
