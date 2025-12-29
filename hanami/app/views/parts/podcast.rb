# auto_register: false
# frozen_string_literal: true

module Casts
  module Views
    module Parts
      class Podcast < Casts::Views::Part
        def description
          helpers.markdown value.description
        end
      end
    end
  end
end
