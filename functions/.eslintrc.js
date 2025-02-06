module.exports = {
  root: true, // Définit ce fichier comme la racine de la configuration ESLint
  env: {
    node: true, // Active les règles pour Node.js
  },
  extends: [
    "eslint:recommended", // Utilise les règles de base d'ESLint
    "plugin:@typescript-eslint/recommended" // Active les bonnes pratiques pour TypeScript
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    ecmaVersion: "latest", // Utilise la dernière version ECMAScript
    sourceType: "module",
  },
  plugins: ["@typescript-eslint"],
  rules: {
    "@typescript-eslint/no-explicit-any": "off", // Désactive l'erreur "any"
  },
};
