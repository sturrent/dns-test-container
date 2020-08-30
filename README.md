# dns-test-container

This is a set of scripts and tools use to generate a docker image that will run a dns test and generates a simple graph with resolution time.
It uses dnsperf and resperf tools from https://www.dns-oarc.net/ to generate a simple html page with the results.

The github actions can be used to trigger a new build and push the updated image.
The actions will get triggered any time a new release gets published.

Here is the general usage for the image and script:

Run in Docker
```docker run -it sturrent/dns-test-container:latest```

That will run the container using the /dns-plot/runner.sh which generates output of resperf-report and dnsperf that will be available over http port 80 in the container.
