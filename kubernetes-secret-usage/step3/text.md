create a file at path `/opt/secret/value.txt` with the value of `secret`. You have get this value with kubectl command.

Try to get this secret directly from ETCD. 

You have to use etcdctl. 

<details>
<summary>Tips</summary>

Secrets are stored by default in the ETCD database under the following path:  
`registry/secrets/namespace/nameofsecret`

And you can find any info to use etcdctl in manifest of etc at this path:
`/etc/kubernetes/manifests/etcd.yaml` 


</details>

Copy all the answer from ETCD DB to `/opt/secret/valueetcd.txt`. ( you have to user edirecting the output to file )

