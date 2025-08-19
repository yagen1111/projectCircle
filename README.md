# for changes in the modules
terragrunt init --terragrunt-source-update
# Deploy dev environment
cd dev
terragrunt apply-all

# Deploy prod environment  
cd ../prod
terragrunt apply-all

# Connect to dev cluster
aws eks update-kubeconfig --region us-east-1 --name dev-eks

# Connect to prod cluster
aws eks update-kubeconfig --region us-east-1 --name prod-eks

# Apply ArgoCD applications
cd C:\Users\yagen\argocd-app
kubectl apply -f staging-applications.yaml
kubectl apply -f dev-applications.yaml
kubectl apply -f prod-applications.yaml

wait for the alb...

go to aws console -> route53 -> Hosted zones -> yagen.store -> change the a record to the new alb
yagen.store
dev.yagen.store
staging.yagen.store