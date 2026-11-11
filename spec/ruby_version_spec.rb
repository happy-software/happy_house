require 'rails_helper'

RSpec.describe 'Ruby version' do
  let(:ruby_version) { Rails.root.join('.ruby-version').read.strip }

  it 'matches the RUBY_VERSION in the Dockerfile' do
    dockerfile_version = Rails.root.join('Dockerfile').read[/^ARG RUBY_VERSION=(\S+)$/, 1]

    expect(dockerfile_version).to eq(ruby_version)
  end

  it 'matches the ruby version in .tool-versions' do
    tool_versions_version = Rails.root.join('.tool-versions').read[/^ruby (\S+)$/, 1]

    expect(tool_versions_version).to eq(ruby_version)
  end
end

