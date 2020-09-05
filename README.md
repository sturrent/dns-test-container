# dns-test-container

This is a set of scripts and tools use to generate a docker image that will run a dns test and generates a simple graph with resolution time.
It uses dnsperf and resperf tools from https://www.dns-oarc.net/ to generate a simple html page with the results.

The github actions can be used to trigger a new build and push the updated image.
The actions will get triggered any time a new release gets published.

Here is the general usage for the image and script:

Run in Docker
```docker run -it sturrent/dns-test-container:latest```

That will run the container using the /dns-plot/runner.sh which generates output of resperf-report and dnsperf that will be available over http port 80 in the container.
The runner.sh scripts can take two arguments, first one sets the max queries per second and second one sets the DNS server IP to queriy.
If not arguments are provided, the script will use MAX_QPS=250 and DNS_SERVER=<DNS server in resolv.conf>

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
    image: sturrent/dns-perf-test:latest
    imagePullPolicy: Always
    ports:
      - containerPort: 80
    env:
    - name: DNS_SERVER
      value: ""
    - name: MAX_QPS
      value: "250"
EOF
```
Note: you can pass custom DNS_SERVER and MAX_QPS modifiying the ENV values accordingly.

#### Make the pod port 80 locally available:
```
kubectl port-forward pod/dns-check 8080:80
```

#### View results in a browser over localhost:8080 example:

![sample_view](https://user-images.githubusercontent.com/16940760/92313742-40cf2a80-ef8c-11ea-8e1d-92d3da843b19.png)

#### Running with a different MAX_QPS and DNS server
Get a terminal on the pod and pass custom MAX_QPS and custom DNS_SERVER.
For example:
```
bash /dns-plot/runner.sh 400 172.29.0.10
```
