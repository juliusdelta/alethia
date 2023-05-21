# frozen_string_literal: true

class OpenAiService
  def initialize
    @client = OpenAI::Client.new(access_token: Rails.application.credentials.openai.api_key)
  end

  def fetch_humanized_bill(bill_text)
    response = @client.chat(
      parameters: {
        model: 'gpt-3.5-turbo', # need gpt-4-32k
        messages: [{ role: 'user', content: "Explain the following in plain terms: #{bill_text}" }], # Required.
        temperature: 0.7
      }
    )

    response.dig('choices', 0, 'message', 'content')
  end
end
