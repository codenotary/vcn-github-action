# vcn-github-action

General-purpose GitHub Action that downloads and enables the usage of the **vcn** tool from Codenotary to perform operations on digital assets.

## How to use it

There are two ways to use this action:

1. Default **standard_usage: true** -> Uses all inputs.
2. Optional **standard_usage: false** -> Uses only the version input.

### 1. standard_usage: true

This will **use all the workflow inputs**, which are:

| Input         | Configuration                                  | Default value   |
|---------------|------------------------------------------------|-----------------|
| version       | `vcn` version.                                 | Latest version. |
| asset         | Digital asset.                                 | No default.     |
| mode          | `vcn` command.                                 | `n` (notarize)  |
| cnc_host      | Codenotary Cloud hostname, without `https://`. | No default.     |
| cnc_grpc_port | Port used to connect to Codenotary Cloud.      | 443             |
| cnc_api_key   | API key for the ledger.                        | No default.     |

**Recommended**: **[use secrets for the API key](https://docs.github.com/en/actions/security-guides/encrypted-secrets)**

#### Example

```yml
name: get-vcn

on:
  push:
    branches: [main]

jobs:
  get-some-other-version-vcn-binary:
    runs-on: ubuntu-latest
    steps:
      - name: Download vcn
        uses: codenotary/vcn-github-action@v2
        with:
            version: v0.9.8
            cnc_host: codenotary-cnc-url
            cnc_grpc_port: 443
            asset: vcn
            cnc_api_key: ${{secrets.VCN_LC_API_KEY}}
```


### 2. standard_usage: false

This will download the latest available binary (currently only for Linux) and **use only the version input**, as below:

| Input         | Configuration                                  | Default value   |
|---------------|------------------------------------------------|-----------------|
| version       | `vcn` version.                                 | Latest version. |

You will have to provide the command with options to interact with it.

This usage allows for more flexibility and options, so we recommend only using this if you're experienced with `vcn` and would like to specify more options than what is available through the **standard_usage: true** mode.

**Example**

```yml
jobs:
  get-latest-vcn-binary:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v2
        with:
          ref: ${{ github.event.review.commit_id }}
    
      # This downloads the vcn binary, no other inputs needed
      - name: Download vcn
        uses: codenotary/vcn-github-action@v2
        with:
          standard_usage: false
      # Intermediate steps in which you build, test, scan, etc...
      ...
      # Simple notarization, including an attachment  
      - name: Test vcn binary is available
        run: ./vcn n my_artifact.jar --lc-host codenotary-cnc-url --lc-port 443 --lc-api-key ${{secrets.my_cnc_api_key}} --attach reports/my_scan_report
        shell: bash
```
