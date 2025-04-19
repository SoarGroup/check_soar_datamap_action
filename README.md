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

This action does not currently produce action outputs. If the validation fails, the action will be annotated with the diagnostics provided by VisualSoar, and the step itself will fail the build.
