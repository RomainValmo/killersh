1 - Create a file at path `/opt/secret/value.txt` with the value of `secret`. You have get this value with kubectl command. ( you have to create path before)

2 - Try to get this secret directly from ETCD. 

You have to use etcdctl. 

<details>
<summary>Tips</summary>
&nbsp;

Secrets are stored by default in the ETCD database under the following path:  
`/registry/secrets/namespace/nameofsecret`

And you can find any info to use etcdctl in manifest of etc at this path: (you need cacert, cert, and key)

`/etc/kubernetes/manifests/etcd.yaml` 

A tool named `etcdctl` can help you 

</details>
&nbsp;

Copy all the answer from ETCD DB to `/opt/secret/valueetcd.txt`. ( you have to use redirecting the output to file )

