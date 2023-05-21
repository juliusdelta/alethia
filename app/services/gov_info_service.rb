# frozen_string_literal: true

class GovInfoService
  def initialize
    @client = Faraday.new(
      url: 'https://api.govinfo.gov',
      params: { api_key: Rails.application.credentials.govinfo.api_key },
      headers: {
        'Content-Type': 'application/json'
      }
    )
  end

  # def fetch
  #   response = @client.get('/packages/BILLS-117hr7449ih/htm')
  #   bill_text = remove_html(response.body)
  #   puts "reading from bill #{bill_text[0, 300]}"
  #
  #   # OpenAiService.new.chat(bill_text)
  # end

  def get_list_by_published(start_date: 1.month.ago, end_date: Time.zone.now)
    formatted_start_date = start_date.strftime('%Y-%m-%d')
    formatted_end_date = end_date.strftime('%Y-%m-%d')

    url = "/published/#{formatted_start_date}/#{formatted_end_date}"
    params = { pageSize: '15', collection: 'BILLS', offsetMark: '*' }

    response = @client.get(url, params)

    JSON.parse(response.body)
  end

  def get_bill_by_package_id(package_id:)
    response = @client.get("/packages/#{package_id}/summary")

    JSON.parse(response.body)
  end

  def get_bill_text_by_package_id(package_id:)
    response = @client.get("packages/#{package_id}/htm")

    remove_html(response.body)
  end

  private

  def remove_html(text)
    # Remove HTML tags
    html_pattern = /<[^>]+>/
    text = text.gsub(html_pattern, '')

    # Remove newline characters
    newline_pattern = /\n/
    text.gsub(newline_pattern, '')
  end
end
