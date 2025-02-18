module.exports = {
    // Enforce using single quotes
    singleQuote: true,

    // Set tab width to 4 spaces for Solidity projects
    tabWidth: 4,

    // Use tabs instead of spaces
    useTabs: false,

    // Do not add semicolons at the end of statements
    semi: false,

    // Include trailing commas where valid in ECMAScript 5 (objects, arrays, etc.)
    trailingComma: 'es5',

    // Control the wrapping of object literals, arrays, function parameters
    bracketSpacing: true,

    // Always include parentheses around a sole arrow function parameter
    arrowParens: 'always',

    // Control line length to 80 characters for better readability
    printWidth: 80,

    // Override for Solidity files (usually .sol)
    overrides: [
        {
            files: '*.sol',
            options: {
                // Specific settings for Solidity can go here if needed
                printWidth: 100, // Increase line width to 100 for Solidity files
                tabWidth: 4,
            },
        },
    ],
}
