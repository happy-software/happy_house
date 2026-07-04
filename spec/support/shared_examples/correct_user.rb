# frozen_string_literal: true

RSpec.shared_examples "redirects other users to root" do
  it "redirects a different logged-in user to root" do
    log_in_as(other_user)
    subject
    expect(response).to redirect_to(root_url)
  end
end
