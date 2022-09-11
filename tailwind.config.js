/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "app/views/**/*",
    "app/frontend/**/*.{jss,ts}"
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require("@tailwindcss/forms"),
  ],
}
