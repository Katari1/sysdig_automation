This is a place for Vikram's scripts to build up a backend on AWS

You need a working k8 cluster. If you don't have one you can spin one up in one command assuming you have aws cli set up along with kops

kops create cluster --cloud-labels Infrastructure=XXXXXX-Kubernetes,description=XXXXXX-Test-K8s,terminationdate=XXXXXX --node-count 3 --zones us-east-1b --node-size t2.2xlarge --master-size t2.medium --ssh-public-key ~/.ssh/[key].pub XXXXXX-k8.dev.draios.com Make XXXXX a unique identifier

Once you have a working cluster then update sysdigcloud/config.yaml with the following:

valid license key in sysdigcloud/configmap.yaml
valid pull-secretl in sysdigcloud/ pull-secret.yaml
A valid api.url (Line 129 in sysdigcloud/config.yaml)
A valid collector.url (Line 124 in Sysdigcloud/config.yaml)
NOTE: These scripts will automatically create you a CNAME record in AWS. Your api.url and collector.url SHOULD BE THE SAME. It should be whatever you want but end in .dev.draios.com. If you don't follow this these scripts won't work 

Due to the complexity we now have a few requirements. You must have the following installed for this to work.
1.  jq
2.  envsubst
3.  awscli (configured)
4.  kubectl (newest version)
5.  curl
6.  anchore-cli (https://github.com/anchore/anchore-cli)
7.  docker


From there you have 4 bash scripts to build your environment.

platform_nonscanning_ha
platform_nonscanning_nonha
secure_scanning_hainstall
secure_scanning_nonha

If you want k8s auditing functionality to work then you need to the following:
1.  Modify the deployment script you're using
2.  Go to the bottom of the script and find the function "enable_k8s_audit".  You will see there are two parameters being passed.  The first is the path to your ssh key.  The second is the user with passwordless sudo access.


This is a fully featured environment.  Using these scripts will do the following:
1.  Deploy a full 1929 sysdig install (Scanning included)
2.  Deploy agents with k8 metrics.
3.  Update falco rules to the latest.
4.  Enable k8 auditing
5.  Add the quay.io repo to your scanning implementation as well as an alert to scan all unscanned images.
6.  Deploy watchtower dashboards in monitor so you can see how your cluster is behaving.
7.  I am using a public wildcard cert so anything XXXX.dev.draios.com will show up as trusted.  Please note you can't do XXXX.XXXX.dev.draios.com as that will make the cert still show up as untrusted.

Lastly, I have made a util.sh script which has a full working menu and will perform a lot of different functions.  When you're done using Sysdig make sure you run the utility script and select option 1 for "Cleanup Sysdig".  This will help clean up AWS volumes as well as remove the CNAME record.

Once you're done with your cluste run kops delete cluster XXXXX.dev.draios.com --yes
