# auto_register: false
# frozen_string_literal: true

require "vite_ruby"

module Cast
  module Views
    module Helpers
      # Add your view helpers here

      def vite_client_tag
        return unless ViteRuby.instance.dev_server_running?

        # Served through the DevServerProxy so the browser never needs the internal vite host
        src = "/#{ViteRuby.instance.config.public_output_dir}/@vite/client"
        tag.script(type: "module", src: src, nonce: content_security_policy_nonce)
      end

      def vite_javascript_tag(name)
        src = ViteRuby.instance.manifest.path_for(name, type: :javascript)
        tag.script(src: src, type: "module", nonce: content_security_policy_nonce)
      end

      def vite_stylesheet_tag(name)
        src = ViteRuby.instance.manifest.path_for(name, type: :stylesheet)
        tag.link(rel: "stylesheet", href: src)
      end

      def vite_asset_path(name)
        ViteRuby.instance.manifest.path_for(name)
      end
    end
  end
end
