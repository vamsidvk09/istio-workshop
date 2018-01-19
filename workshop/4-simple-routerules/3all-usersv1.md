The file https://github.com/redhat-developer-demos/istio-tutorial/blob/master/istiofiles/route-rule-recommendations-v1.yml specifies that the destination will be the recommendation that contains the label `version=v1`.

Let's replace the RouteRule.

`oc replace -f ~/istio-tutorial/istiofiles/route-rule-recommendations-v1.yml -n tutorial`{{execute}}

**Note**: "replace" instead of "create" since we are overlaying the previous rule

Try the microservice several times by typing `curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute}}

you should only see v1 being returned.

## Explore the routerules object

You can check the existing route rules by typing `oc get routerules -n tutorial`{{execute}}. It will show that we only have a `routerule` object called `recommendations-default`. The name has been specified in the [route rule metadata](https://github.com/redhat-developer-demos/istio-tutorial/blob/master/istiofiles/route-rule-recommendations-v1.yml#L4)

You can check the contents of this `routerule` by executing `oc get routerules/recommendations-default -o yaml -n tutorial`{{execute}}