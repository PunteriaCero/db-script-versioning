# Getting Started with Database Scripts Delta Generator

This guide will help you set up and use the Database Scripts Delta Generator action in your workflow.

## Installation

### 1. Add Action to Your Workflow

Create a workflow file in your repository (e.g., `.github/workflows/delta-release.yml`):

```yaml
name: Generate Database Delta

on:
  workflow_dispatch:
    inputs:
      release_version:
        description: Release version (e.g., v1.0.0)
        required: true

jobs:
  delta:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - name: Generate delta
        uses: camuzziar/db-script-versioning@v1
        id: delta
        with:
          base_ref: main
          head_ref: ${{ inputs.release_version }}
          scripts_path: scripts
      
      - name: Upload to release
        if: steps.delta.outputs.has_changes == 'true'
        uses: softprops/action-gh-release@v1
        with:
          files: ${{ steps.delta.outputs.delta_file }}
          tag_name: ${{ inputs.release_version }}
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Repository Structure

Organize your repository like this:

```
your-repo/
├── scripts/
│   ├── 001_create_schema.sql
│   ├── 002_add_tables.sql
│   └── migrations/
│       └── 003_add_indexes.sql
├── .github/
│   └── workflows/
│       └── delta-release.yml
└── README.md
```

## Usage

### Basic: Compare main vs HEAD

```yaml
- uses: camuzziar/db-script-versioning@v1
  with:
    base_ref: main
    head_ref: HEAD
```

### Advanced: Compare two tags

```yaml
- uses: camuzziar/db-script-versioning@v1
  with:
    base_ref: v1.0.0
    head_ref: v1.1.0
```

### Custom scripts path

```yaml
- uses: camuzziar/db-script-versioning@v1
  with:
    base_ref: main
    head_ref: HEAD
    scripts_path: database/migrations
```

## Testing Locally

### Simulate Delta Generation

```bash
# See which files changed
git diff --name-only origin/main..HEAD -- scripts/

# See file content that would be included
git show HEAD:scripts/your-file.sql
```

### Test Full Workflow

```bash
# Fetch full history
git fetch --depth=0

# Compare different branches
git diff origin/main..HEAD -- scripts/ | head -50
```

## Workflow Examples

### Example 1: Manual Release Delta

Manually trigger to generate delta between any two refs:

```yaml
on:
  workflow_dispatch:
    inputs:
      from_ref:
        description: 'From reference'
        required: true
        default: 'main'
      to_ref:
        description: 'To reference'
        required: true
        default: 'develop'
```

See `.github/workflows/test-delta.yml` for complete example.

### Example 2: Automatic Release Delta

Generate delta automatically when creating a release:

```yaml
on:
  release:
    types: [published]

jobs:
  delta:
    # ... uses event.release.tag_name and main
```

## Troubleshooting

### No Changes Detected

- Ensure `fetch-depth: 0` in checkout step
- Verify base reference exists: `git fetch origin base_ref`
- Check script path: `git ls-tree -r HEAD scripts/`

### File Encoding Issues

- Ensure all SQL files are UTF-8 encoded
- Use consistent line endings (LF recommended)

### Large Delta Files

- Consider splitting scripts into smaller files
- Use subdirectories to organize by feature

## Best Practices

1. **File Naming**: Use sequential numbering (001_, 002_, etc.)
2. **Comments**: Add descriptive headers with ticket references
3. **Idempotency**: Use `IF NOT EXISTS` to prevent errors
4. **Testing**: Always test migrations in lower environments first
5. **Documentation**: Comment complex changes for future reference

## Example SQL Migration

```sql
-- =============================================================================
-- MIGRATION: Add New Feature Table
-- TICKET: PROJ-1234
-- AUTHOR: Team
-- CREATED: 2026-07-07
-- DESCRIPTION: Adds table and indexes for new feature
-- =============================================================================

-- Create table with proper schema
CREATE TABLE IF NOT EXISTS NEW_FEATURE (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    NAME NVARCHAR(255) NOT NULL,
    CREATED_AT DATETIME DEFAULT GETUTCDATE()
);

-- Add index
CREATE INDEX idx_new_feature_name ON NEW_FEATURE(NAME);

PRINT 'Migration completed';
```

## Next Steps

1. Copy example SQL files or create your own
2. Commit to a feature branch
3. Create pull request and merge to main
4. Trigger workflow manually or on release
5. Download delta from artifacts or release

## Documentation

- [Action Repository](https://github.com/camuzziar/db-script-versioning)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [SQL Server Documentation](https://docs.microsoft.com/sql/)

## Support

For issues and questions:
- 📖 Check [README.md](../README.md)
- 🐛 Open [GitHub Issue](https://github.com/camuzziar/db-script-versioning/issues)
- 💬 Start [Discussion](https://github.com/camuzziar/db-script-versioning/discussions)
