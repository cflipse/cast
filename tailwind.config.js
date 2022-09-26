/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "public/*.html",
    "app/helpers/**/*.rb",
    "app/frontend/**/*.{js,ts}",
    "app/views/**/*.{html,erb}",
    "app/builders/**/*.rb",
    "app/components/**/*.{html,erb}",
  ],
  theme: {
    extend: {
      gridTemplateRows: {
        'form': "fit-content(15rem) minmax(20rem, 1fr)",
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
  ],
}
