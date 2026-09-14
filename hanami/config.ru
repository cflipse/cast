# frozen_string_literal: true

require "hanami/boot"
use(ViteRuby::DevServerProxy, ssl_verify_none: true) if ViteRuby.run_proxy?

run Hanami.app
