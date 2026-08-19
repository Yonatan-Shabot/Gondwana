# Gondwana

Gondwana is a library chart designed to provide functions for creating different cluster objects with plug-and-play ease.

Built specifically for supporting the [Mesopotamia Helm Chart](https://github.com/yonatan-shabot/Mesopotamia.git), this chart only contains functions to create deployments, secrets, services, etc...

## Getting Started

These instructions will guide you through including the Gondwana library chart in your project to handle your application deployments.

### Prerequisites

To use Gondwana, you will need the following installed and configured on your cluster:

- Helm v3+

### Installing

Because Gondwana is built as a **Library Chart**, it is not deployed on its own. Instead, you include it as a dependency in your application's Helm chart.

1. Open your application's `Chart.yaml` file.
2. Add Gondwana to your `dependencies` block:

```yaml
apiVersion: v2
name: my-awesome-app
description: A Helm chart for Kubernetes
type: application
version: 0.1.0
appVersion: "1.0.0"

dependencies:
  - name: gondwana
    version: 0.1.5
    repository: "oci://ghcr.io/yonatan-shabot"
```
3. Update your chart dependencies to download Gondwana:

```Bash
helm dependency update
```

4. Create a new chart and use the include function to use any of the templates / helpers provided here.

### Running the tests

Automated testing suites for the Gondwana chart are currently in development and will be available in future releases.

### Built With

Helm - The package manager for Kubernetes

### Contributing

Please read CONTRIBUTING.md for details on our code of conduct, and the process for submitting pull requests to us.

### Versioning

We use SemVer for versioning. For the versions available, see the tags on this repository.

### Authors

Yonatan Shabot - Initial work - @Yonatan-Shabot

For business inquiries / suggestions (keep in mind: this is my first open-source project, complaints / suggestions are more than welcome), please reach out at: shabotyonatan@gmail.com

### License

This project is licensed under the MIT License - see the LICENSE file for details.
