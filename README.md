# dns-test-container

This is a set of scripts and tools use to generate a docker image that will run a dns test and generates a simple graph with resolution time.
It uses dnsperf and resperf tools from https://www.dns-oarc.net/ to generate a simple html page with the results.

The github actions can be used to trigger a new build and push the updated image.
The actions will get triggered any time a new release gets published.

Here is the general usage for the image and script:

Run in Docker
```docker run -it sturrent/dns-test-container:latest```

That will run the container using the /dns-plot/runner.sh which generates output of resperf-report and dnsperf that will be available over http port 80 in the container.

### Using in Kuberntes
Sample usage in kubernetes

Deploy pod:
```
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: dns-check1
spec:
  containers:
  - name: dns-check1
    image: sturrent/dns-check:latest
    ports:
      - containerPort: 80
EOF
```

Make the pod port 80 locally available:
```
kubectl port-forward pod/dns-check 8080:80
```

View results in a browser over localhost:8080 example:

![sample_view](https://user-images.githubusercontent.com/16940760/91664956-b5e3c100-eaaf-11ea-83ad-cd52c10e12c2.png)

### Using a different DNS server
The runner script will use first argument if present as the DNS server to query.
For example:
```
bash /dns-plot/runner.sh 172.29.0.10
```
