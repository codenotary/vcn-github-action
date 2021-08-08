# vcn-github-action

General-purpose GitHub action enabling the usage of the **[vcn](https://github.com/codenotary/vcn)** tool from CodeNotary.com to notarize digital assets, now supporting the generation of a Bill of Materials for Go, Python, .NET and Maven projects.

## How to use it

For a better understanding of how to use this action, have a look in the provided [example workflow](.github/workflows/example.yml).

There are 2 main ways to use this action: the default **standard** usage and optional **non-standard** usage. Although both use cases are well depicted in the example workflow file, it's worth mentioning that either one will accomplish the same basic goal which is interacting with your Codenotary Immutable ledger in an automated way.

### Standard usage

The standard usage makes it simple to integrate VCN notarizations, authentications, and any other interaction to most existing workflows. It downloads the latest available binary (currently only supports Linux-based environments) and **uses the workflow inputs** as configured in the above-mentioned example to provide the necessary abstraction to simplify the process of securing your builds, commits or anything you'd like.

The configurable options are:

- version - Instead of downloading the latest version, we'll download with a specific vcn version **Optional** - If you don't use this option the latest version will be used
- asset - Asset to notarize/authenticate/untrust **Optional** - We use this in standard usage so it's required if standard_usage is set to true (default), make sure to include the filename
- mode - Whether to notarize, authenticate, or untrust the asset **'n' for Notarize, 'a' for Authenticate and 'untrust' for Untrust, defaults to 'n'**
- cnil_host - The hostname for your CodeNotary immutable ledger, **required, don't include https://**
- cnil_grpc_port - The port to use for vcn to interact with your CodeNotary immutable ledger, usually 443.
- cnil_api_key - API Key for your CodeNotary immutable ledger, we recommend using secrets for this -- see **[github docs](https://docs.github.com/es/actions/reference/encrypted-secrets)** for more info about secrets
- :warning: standard_usage - **False if you will NOT use the inputs but rather configure your environment variables/and commands.** If this is set to true, the action will just include the VCN Binary in your workflow but leave everything - else up to you. This allows for more flexibility and options so we recommend only using this if you're experienced with vcn and would like to specify more options than what's available through the standard usage mode.

### non-standard usage

**standard_usage: false** causes all other inputs **except version** to be ignored. If the input is set to false you will be left with the latest version of vcn in your workflow but you will have to provide the commands to interact with it. Below are a few examples of non-standard usage

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
        uses: codenotary/vcn-github-action@main
        with:
          standard_usage: false
      # Intermediate steps in which you build, test, scan, etc...
      ...
      # Simple notarization, including an attachment  
      - name: Test vcn binary is available
        run: ./vcn n my_artifact.jar --lc-host codenotary-cnil-url --lc-port 443 --lc-api-key ${{ secrets.my_cnil_api_key }} --attach reports/my_scan_report
        shell: bash

```

The above example is notarizing an asset but yours might need to authenticate before deploying or do something completely different. For more examples see the [vcn README](https://github.com/codenotary/vcn)


:bulb: Unlike similar images, this vcn action directly uses the latest release binary instead of a docker image so no build tools are provided. Use this on top of your existing workflows instead.
