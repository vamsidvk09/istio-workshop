Go to the source folder of `customer` microservice.

Execute: `cd ~/istio_tutorial/customer/`{{execute}}

Now execute `mvn package`{{execute}} to create the `customer-0.0.1-SNAPSHOT.jar` file.

## Create the customer docker image.

We will now use the provided [`Dockerfile`](https://github.com/redhat-developer-demos/istio_tutorial/blob/master/customer/Dockerfile) to create a docker image.

This image will be called `example/customer`.

To build a docker image type: `docker build -t example/customer .`{{execute}}

You can check the image that was create by typing `docker images | grep customer`{{execute}}

**Note**: Your very first docker build will take a bit of time as it downloads all the layers. Subsequent rebuilds of the docker image, updating only the jar/app layer will be very fast.

## Injecting the sidecar proxy.

Currently using the "manual" way of injecting the Envoy sidecar.

Check the version of `istioctl`. Execute `istioctl version`{{execute}}.

Also, make sure that you are using `springistio` project. Execute `oc project springistio`{{execute}}

Now let's deploy the customer pod with its sidecar.

Execute: `oc apply -f <(istioctl kube-inject -f src/main/kubernetes/Deployment.yml) -n springistio`{{execute}}

Also create a service: `oc create -f src/main/kubernetes/Service.yml`{{execute}} 

Since customer is the forward most microservice (customer -> preferences -> recommendations), let's add an OpenShift Route that exposes that endpoint.

Execute: `oc expose service customer`{{execute}}.

Check the route: `oc get route`{{execute}}

To watch the creation of the pods, execute `oc get pods -w`{{execute}}

Once that the customer pod is `Running`, you can hit `CTRL+C`. 

Try the microservice by typing `curl http://customer-springistio.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute}}

You should see the following error because preferences is not yet deployed, so you only get a partial response of "C100" plus the error message

`C100 *I/O error on GET request for "http://preferences:8080/"`

This concludes the deployment of `customer` microservice.