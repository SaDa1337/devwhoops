# devwhoops
DevWhoops presentation


# Cmds

Building the naive docker image:
docker build . -f Naive.Dockerfile -t devwhoops:naive

Buliding the proper docker image:
docker build . -t devwhoops:v1

running the image:

docker run --rm -p 8122:80 -e ASPNETCORE_ENVIRONMENT=Production devwhoops:v1

docker run --rm -p 8122:80 -e ASPNETCORE_ENVIRONMENT=Production devwhoops:naive

Pushing to k8s cluster using kubectl:
kubectl apply -f deployment.yaml -f service.yaml -f ingress.yaml --context [YOUR CONTEXT HERE]

Pushing to k8s cluster using helm:
helm install sp-generic-web --name devwhoops --kube-context [YOUR CONTEXT HERE]

Deleting the app from k8s using helm:
helm delete devwhoops --purge
