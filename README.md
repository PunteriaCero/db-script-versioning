# Database Scripts Delta Generator

A GitHub Action that generates consolidated delta SQL scripts containing only the changes made between two git references. Perfect for automated database migration releases and change tracking.

## Features

- 🔍 **Automatic Change Detection**: Identifies modified and newly added files in your scripts folder
- 📝 **Full Content Capture**: Uses `git show` to capture complete file content, including newly added files
- 🗂️ **Flexible Paths**: Works with any scripts folder structure
- 📦 **Release-Ready**: Generates single consolidated delta file for easy deployment
- 🔧 **Customizable**: Configure base/head references and scripts path

## Use Cases

- **Database Migrations**: Generate delta scripts for UAT/production deployments
- **Change Tracking**: Document all database changes between releases
- **CI/CD Pipelines**: Automate delta script generation in your workflow
- **Audit Trail**: Maintain consolidated change history

## Quick Start

```yaml
name: Generate Database Delta

on:
  workflow_dispatch:
    inputs:
      ref:
        description: 'Release branch/tag'
        required: true

jobs:
  delta:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
          ref: ${{ inputs.ref }}
      
      - uses: camuzziar/db-script-versioning@v1
        id: delta
        with:
          base_ref: main
          head_ref: ${{ inputs.ref }}
          scripts_path: scripts
      
      - name: Upload delta
        if: steps.delta.outputs.has_changes == 'true'
        uses: actions/upload-artifact@v4
        with:
          name: delta-scripts
          path: ${{ steps.delta.outputs.delta_file }}
```

## Inputs

| Input | Description | Default |
|-------|-------------|---------|
| `base_ref` | Base commit/branch for comparison | `main` |
| `head_ref` | Head commit/branch for comparison | `github.head_ref \|\| github.ref` |
| `scripts_path` | Relative path to scripts folder | `scripts` |

## Outputs

| Output | Description |
|--------|-------------|
| `delta_file` | Path to generated SQL delta file |
| `has_changes` | Boolean indicating if changes were found |
| `changed_files` | Multiline list of modified files |

## How It Works

1. **Detects Changes**: Runs `git diff --name-only` between base and head references to identify modified files
2. **Captures Content**: Uses `git show HEAD:file` to extract full file content from git history
3. **Consolidates**: Combines all changed files into a single delta SQL script
4. **Outputs**: Makes the delta file available for artifact upload or further processing

## Example Repository Structure

```
my-database-repo/
├── scripts/
│   ├── 001_create_users_table.sql
│   ├── 002_add_email_column.sql
│   └── migrations/
│       └── 003_populate_email.sql
├── .github/
│   └── workflows/
│       └── release-delta.yml
└── README.md
```

## Workflow Example

See [examples/test-workflow.yml](.github/workflows/test-workflow.yml) for a complete working example.

## Testing

The repository includes example SQL files and a test workflow. To test locally:

```bash
# Simulate delta generation
git diff --name-only origin/main..HEAD -- scripts/

# View changes that would be included
git show HEAD:scripts/your-file.sql
```

## Limitations

- Works with git-based repositories only
- Requires fetch-depth: 0 in checkout step for full history
- Base reference must exist in origin

## License

MIT - See [LICENSE](LICENSE)

## Author

Created by [@camuzziar](https://github.com/camuzziar)

## Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request with test cases

## Support

- 📖 Read the [documentation](https://github.com/camuzziar/db-script-versioning)
- 🐛 Report issues on [GitHub Issues](https://github.com/camuzziar/db-script-versioning/issues)
- 💬 Discuss on [GitHub Discussions](https://github.com/camuzziar/db-script-versioning/discussions)
