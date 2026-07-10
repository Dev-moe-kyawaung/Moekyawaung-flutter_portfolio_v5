# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 5.x.x   | ✅ Active  |
| < 5.0   | ❌ EOL     |

## Reporting a Vulnerability

If you discover a security vulnerability, please **do not** open a public GitHub issue.

Email: `moekyawaung@engineer.com`

Include:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (optional)

I'll respond within **48 hours** and provide a fix within **7 days** for confirmed issues.

## Scope

- Firebase security rules misconfigurations
- XSS vulnerabilities in web build
- Exposed API keys or secrets in source
- Dependency vulnerabilities (CVE)

## Security Practices

- Firebase Hosting security headers configured (X-Frame-Options, X-XSS-Protection, CSP)
- No API keys committed to source — all via GitHub Secrets
- Dependencies kept up-to-date via Dependabot
- All user inputs validated and sanitized in contact form
