# frozen_string_literal: true

# Integration specs that document the Admin API endpoints this store adds.
# `spree task openapi:generate` writes them into openapi/admin.yaml, which
# Spree reads to build an agent tool (MCP server and dashboard assistant)
# for each documented action. `spree generate spree_dev_tools:openapi`
# writes a skeleton spec for each admin action not documented yet.
require 'rails_helper'
require 'spree_dev_tools/rspec/openapi'
