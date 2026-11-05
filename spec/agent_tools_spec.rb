# frozen_string_literal: true

require 'rails_helper'
require 'spree/api/testing_support/agent_tools_contract'

# Fails when an admin action has no documented operation, an opt-out has no
# reason, or two actions would derive the same agent tool name.
RSpec.describe 'agent tools' do
  it_behaves_like 'an engine whose admin writes are agent tools', Rails.application
end
