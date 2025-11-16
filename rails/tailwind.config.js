/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "public/*.html",
    "app/helpers/**/*.rb",
    "app/frontend/**/*.{js,ts}",
    "app/views/**/*.{html,erb}",
    "app/builders/**/*.rb",
    "app/components/**/*.{html,erb,rb}",
  ],
  theme: {
    extend: {
      fontFamily: {
        'header': ["Packard\\ Antique", "ui-serif", "Georgia", "Cambria", "Times\\ New\\ Roman", "Times", "serif"],
      },
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
