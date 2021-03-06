We can experiment with Istio routing rules by making a change to RecommendationsController.java.

Open `/recommendation/src/main/java/com/redhat/developer/demos/recommendation/RecommendationVerticle.java`{{open}} in the editor. Now make the following modification.

```java
    private static final String RESPONSE_STRING_FORMAT = "recommendation v2 from '%s': %d\n";
```    
</pre>

**Note:** The file is saved automatically. 

Now go to the recommendations folder `cd ~/projects/istio-tutorial/recommendation/`{{execute T1}}

Make sure that the file has changed: `git diff`{{execute T1}}. To exit, hit `q`{{execute T1}}

Compile the project with the modifications that you did.

`mvn package`{{execute T1}}

## Create the recommendation:v2 docker image.

We will now create a new image using `v2`. The `v2`tag during the docker build is significant.

Execute `docker build -t example/recommendation:v2 .`{{execute T1}}

You can check the image that was create by typing `docker images | grep recommendation`{{execute T1}}

## Create a second deployment with sidecar proxy

There is also a 2nd deployment.yml file to label things correctly

Execute: `oc apply -f <(istioctl kube-inject -f src/main/kubernetes/Deployment-v2.yml) -n tutorial`{{execute T1}}

To watch the creation of the pods, execute `oc get pods -w`{{execute T1}}

Once that the recommendation pod READY column is 2/2, you can hit `CTRL+C`. 

Test the `customer` endpoint: `curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute T1}}

You likely see "customer => preference => recommendation v2 from '2819441432-5v22s': 1" as by default you get round-robin load-balancing when there is more than one Pod behind a Service.

You likely see "customer => preference => recommendation v1 from '99634814-d2z2t': 3", where '99634814-d2z2t' is the pod running v1 and the 3 is basically the number of times you hit the endpoint.

Send several requests on `Terminal 2` to see their responses

`while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .5; done`{{execute T2}}

The default Kubernetes/OpenShift behavior is to round-robin load-balance across all available pods behind a single Service. Add another replica of recommendations-v2 Deployment.

`oc scale --replicas=2 deployment/recommendation-v2`{{execute T1}}

Wait the second `recommendation:v2` pod to become available, execute `oc get pods -w`{{execute T1}}

Once that the recommendation pod READY column is 2/2, you can hit `CTRL+C`. 

Make sure that the following command is running on `Terminal 2` `while true; do curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com; sleep .5; done`{{execute T2}}

You will see two requests into the v2 and one for v1

Scale back to a single replica of the recommendation-v2 Deployment

`oc scale --replicas=1 deployment/recommendation-v2`{{execute T1}}

On `Terminal 2`, you will see one requests into the v2 and one for v1.