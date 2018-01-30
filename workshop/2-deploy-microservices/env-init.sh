ssh root@host01 "rm -rf /root/projects/ /root/temp-pom.xml"

ssh root@host01 "wget https://github.com/istio/istio/releases/download/0.4.0/istio-0.4.0-linux.tar.gz -P /root/; tar -zxvf /root/istio-0.4.0-linux.tar.gz -C /root; until $(oc status &> /dev/null); do sleep 1; done; oc login -u system:admin"

ssh root@host01 "oc adm policy add-cluster-role-to-user cluster-admin developer; oc adm policy add-scc-to-user anyuid -z istio-ingress-service-account -n istio-system; oc adm policy add-scc-to-user anyuid -z istio-egress-service-account -n istio-system; oc adm policy add-scc-to-user anyuid -z default -n istio-system"

ssh root@host01 "oc apply -f /root/istio-0.4.0/install/kubernetes/istio.yaml"

ssh root@host01 "oc expose svc istio-ingress -n istio-system"

