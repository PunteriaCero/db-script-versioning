# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-07

### Added
- Initial release of Database Scripts Delta Generator
- Support for comparing any two git references (commits, branches, tags)
- Automatic detection of changed files in configurable scripts folder
- Full file content capture using git show for both new and modified files
- Git diff fallback for edge cases
- Consolidated delta SQL output with headers including base/head commit hashes
- Outputs for delta file path, change detection, and file list
- GitHub Action branding with blue database icon
- Comprehensive README with quick start guide
- MIT License
- Example SQL migration scripts demonstrating versioning
- Test workflow for validating action functionality
- Getting Started guide for implementation
- `.gitignore` for action repositories

### Features
- 📝 Generates consolidated delta scripts from git changes
- 🔍 Detects new and modified files automatically
- 🗂️ Configurable scripts folder path
- 🔧 Flexible reference comparison (any git ref to any git ref)
- 📦 Single output file ready for deployment
- ✅ Idempotent migration scripts using IF NOT EXISTS
- 🔐 Maintains commit hash trail in delta headers
- 📊 Provides change detection output for conditional workflows

### Technical Details
- **Bash-based**: Portable across GitHub Actions runners
- **Git-native**: Uses git show and git diff, no external dependencies
- **Atomic**: Single temp file approach prevents partial writes
- **Fallback-capable**: Graceful handling of edge cases

### Example Usage
```yaml
- uses: camuzziar/db-script-versioning@v1
  with:
    base_ref: main
    head_ref: ${{ inputs.release_version }}
    scripts_path: scripts
```

### Known Limitations
- Requires `fetch-depth: 0` in checkout step for full history
- Base reference must exist in remote origin
- Works with git-based repositories only

### Files Changed in v1.0.0
- Added `action.yml` (main action implementation)
- Added `README.md` (comprehensive documentation)
- Added `LICENSE` (MIT license)
- Added `.gitignore` (GitHub Actions best practices)
- Added `.github/workflows/test-delta.yml` (example workflow)
- Added `.github/CODEOWNERS` (maintainer definition)
- Added `docs/GETTING_STARTED.md` (implementation guide)
- Added `scripts/001_create_users_table.sql` (example migration)
- Added `scripts/002_add_email_verification.sql` (example migration)
- Added `scripts/003_add_user_roles.sql` (example migration)
- Added `CHANGELOG.md` (this file)

### Contributors
- [@camuzziar](https://github.com/camuzziar) - Initial implementation

---

## Unreleased

### Planned Features
- [ ] Support for additional SQL dialects (MySQL, PostgreSQL, Oracle)
- [ ] Delta file compression options
- [ ] Changelog generation from commit messages
- [ ] Integration with database migration tools (Flyway, Liquibase)
- [ ] Multi-file output support (per directory)
- [ ] File filtering by pattern
- [ ] Dry-run mode
- [ ] Validation mode (check SQL syntax)

### Known Issues
- None reported

[1.0.0]: https://github.com/camuzziar/db-script-versioning/releases/tag/v1.0.0
