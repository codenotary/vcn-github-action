# vcn-github-action

General-purpose GitHub Action that downloads and enables the usage of the **[vcn](https://github.com/codenotary/vcn-enterprise)** tool from Codenotary to perform operations on digital assets.

## How to use it

There are two ways to use this action:

1. Default **standard** usage.
2. Optional **non-standard** usage.

The usage is configured with the `standard_usage` input, as below:

| True             | False                        |
|------------------|------------------------------|
| Uses all inputs. | Uses only the version input. |

 The **non-standard** usage allows for more flexibility and options, so we recommend only using this if you're experienced with `vcn` and would like to specify more options than what is available through the **standard** usage mode.

### 1. Standard usage

This will **use the workflow inputs**, which are:

| Input         | Configuration                                  | Default value   |
|---------------|------------------------------------------------|-----------------|
| version       | `vcn` version.                                 | Latest version. |
| asset         | Digital asset.                                 | No default.     |
| mode          | `vcn` command.                                 | No default.     |
| cnc_host      | Codenotary Cloud hostname, without `https://`. | No default.     |
| cnc_grpc_port | Port used to connect to Codenotary Cloud.      | 443             |
| cnc_api_key   | API key for the ledger.                        | No default.     |

**Recommended**: **[use secrets for the API key](https://docs.github.com/es/actions/reference/encrypted-secrets)**.

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
      - name: Download VCN
        uses: codenotary/vcn-github-action@v2
        with:
            version: v0.9.8
            cnc_host: codenotary-cnc-url
            cnc_grpc_port: 443
            asset: vcn
            cnc_api_key: ${{secrets.VCN_LC_API_KEY}}
```


### 2. Non-standard usage

This will download the latest available binary (currently only for Linux) and **use only the version**, as below:

| Input         | Configuration                                  | Default value   |
|---------------|------------------------------------------------|-----------------|
| version       | `vcn` version.                                 | Latest version. |

You will have to provide the commands to interact with it.

Workflow:

```yml
jobs:
  get-latest-vcn-binary:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v2
        with:
          ref: ${{ github.event.review.commit_id }}
    
      # This downloads the VCN Binary, no other inputs needed
      - name: Download VCN
        uses: codenotary/vcn-github-action@v2
        with:
          standard_usage: false
      # Intermediate steps in which you build, test, scan, etc...
      ...
      # Simple notarization, including an attachment  
      - name: Test vcn binary is available
        run: ./vcn n my_artifact.jar --lc-host codenotary-cnc-url --lc-port 443 --lc-api-key ${{ secrets.my_cnc_api_key }} --attach reports/my_scan_report
        shell: bash
```
