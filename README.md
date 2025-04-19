# VisualSoar Datamap Validation Action

This GitHub Action runs the [VisualSoar](https://github.com/SoarGroup/VisualSoar) datamap validation on a user-specified Soar project.

## Inputs

| Name          | Description                                      | Required | Default |
|---------------|--------------------------------------------------|----------|---------|
| `projectPath` | Path to the Soar project file to validate.       | Yes      |         |

## Example Usage

```yaml
name: Validate Soar Project

on:
  push:
    paths:
      - "path/to/soar/project/**"

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3

      - name: Run VisualSoar Validation
        uses: SoarGroup/check_soar_datamap_action@v1
        with:
          projectPath: "path/to/soar/project/thor-soar.vsa.json"
```

## Outputs

This action does not currently produce outputs, but will fail the workflow if validation fails.
