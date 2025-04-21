# Soar Datamap Validation

This action checks the productions in a Soar project against their datamap using [VisualSoar](https://github.com/SoarGroup/VisualSoar).

## Inputs

| Name          | Description                                                                                           | Required | Default                                               |
|---------------|-------------------------------------------------------------------------------------------------------|----------|-------------------------------------------------------|
| `projectPath` | Path to the Soar project file to validate, relative to your project root.                             | Yes      |                                                       |
| `outputPath`  | Path to the output file where the validation results will be saved (in JSON lines format).            | No       | ${{ runner.temp }}/visualsoar_dm_validation_log.jsonl |

## Outputs

| Name          | Description                                                                                        |
|---------------|----------------------------------------------------------------------------------------------------|
| `outputPath`  | Path to the output file where the validation results were saved (in JSON lines format).            |

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
