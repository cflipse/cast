module Cast
  class Slugger
    def call(str)
      str.to_s
        .downcase
        .gsub(/[^a-z0-9]+/i, "-")
        .gsub(/(^-|-+$)/, "")
        .gsub(/-+/, "-") # Squeeze duplicate hyphens
    end
  end
end
