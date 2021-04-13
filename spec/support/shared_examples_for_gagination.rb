shared_examples "paginated list" do |route_left, route_right|
  it { expect(@response_data).to have_key("meta") }
  it { expect(@response_data["meta"]).to have_key("pagination") }
  it { expect(@response_data["meta"]["pagination"]).to have_key("page") }
  it { expect(@response_data["meta"]["pagination"]).to have_key("per_page") }
  it { expect(@response_data["meta"]["pagination"]).to have_key("total_pages") }
  it { expect(@response_data["meta"]["pagination"]).to have_key("total_objects") }
end
