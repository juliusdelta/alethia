# frozen_string_literal: true

gov_info_service = GovInfoService.new
bill_group = gov_info_service.get_list_by_published(start_date: 6.months.ago, end_date: Time.zone.now)

bill_group['packages'].each do |bill|
  id = bill['packageId']
  bill_json = gov_info_service.get_bill_by_package_id(package_id: id)
  short_title = bill_json['shortTitle']&.length ? bill_json['shortTitle'][0]['title'] : nil
  bill_text = gov_info_service.get_bill_text_by_package_id(package_id: id)

  Bill.create!(
    origin_chamber: bill_json['originChamber'],
    session: bill_json['session'],
    short_title:,
    title: bill_json['title'],
    branch: bill_json['branch'],
    su_doc_class_number: bill_json['suDocClassNumber'],
    doc_class: bill_json['docClass'],
    bill_number: bill_json['billNumber'],
    category: bill_json['category'],
    date_issued: bill_json['dateIssued'],
    bill_version: bill_json['billVersion'],
    gov_info_url: bill_json['detailsLink'],
    last_modified: bill_json['lastModified'],
    bill_text:,
    gov_info_raw_payload: bill_json
  )
end
