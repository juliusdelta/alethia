# frozen_string_literal: true

class GooglePalmService
  def initialize
    @client = Faraday.new(
      url: 'https://generativelanguage.googleapis.com/v1beta2/models/text-bison-001:generateText',
      params: { key: Rails.application.credentials.google.palm_api_key },
      headers: {
        'Content-Type': 'application/json'
      }
    )
  end

  def test_prompt
    @client.post do |req|
      req.body = { prompt: { text: 'Tell me how a bill becomes legislation' } }.to_json
    end
  end

  def translate_bill_by_text(bill_text)
    response = @client.post do |req|
      req.body = {
        prompt: { text: "Explain in laymens terms #{bill_text}" },
        safetySettings: safety_settings
      }.to_json
    end

    JSON.parse(response.body)
  end

  def translate_bill_by_attr(attribute_string)
    response = @client.post do |req|
      req.body = {
        prompt: { text: "Explain bill #{attribute_string}" },
        safetySettings: safety_settings,
        maxOutputTokens: 128
      }.to_json
    end

    JSON.parse(response.body)
  end

  private

  def safety_settings
    safety_categories = %w[
      HARM_CATEGORY_DEROGATORY
      HARM_CATEGORY_TOXICITY
      HARM_CATEGORY_SEXUAL
      HARM_CATEGORY_MEDICAL
      HARM_CATEGORY_VIOLENCE
      HARM_CATEGORY_DANGEROUS
    ]

    safety_categories.map { |category| { category:, threshold: 'BLOCK_NONE' } }
  end
end
