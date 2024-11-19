
As you can see by default yours secrets are stored in plain text or just base64 encoded into ETCD.

Let's show, how to increase sécurity. 

1- Write an encryption configuration file. Use the following code. and save it as encrypt.yaml

```
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: mykey
              secret: cm9tYWlua2lsbGVyc2g1OQ==
      - identity: {}
                    
```

<details>
<summary>Explanations</summary>

We create a encryption file for ressource named "secrets"

We use provider aescbc to encryt data with the key:value mykey
aescbc provider allow key with 16/24/32 characters and must be provide in base64 encoded 
We use `echo -n "romainkillersh59" | base64`
We keep possibility to read secret from unencrypted secrets with identity provider

</details>

<br>

2- Apply it 

We have to config api-server to use our config file. 
We saved our file in this path `\root\encrypt.yaml`

Let's go to modify the api-server manifest 
`vim /etc/kubernetes/manifests/kube-apiserver.yaml`

We add this argument and file path 
`- --encryption-provider-config=/root/encrypt.yaml`

```
spec:
  containers:
  - command:
    - kube-apiserver
    - --encryption-provider-config=/root/encrypt.yaml  # add this line
    - --advertise-address=172.30.1.2
````

<br>

To allow kube-api-server to access to this file, we have to mount a new volume

```
    - mountPath: /usr/share/ca-certificates
      name: usr-share-ca-certificates
      readOnly: true
    - mountPath: /root/encrypt.yaml # add mountPath 
      name: encrypt # use the volume name 
      readOnly: true # put readonly
```

and 

```
  - hostPath:
      path: /usr/share/ca-certificates
      type: DirectoryOrCreate
    name: usr-share-ca-certificates
  - hostPath: #add this volume
      path: /root/encrypt.yaml #path 
      type: File #type of volume 
    name: encrypt #name must be the same that used in mountPath

```
<br>

Save and ensure that your api-server up back 



3- Create a new secret named `securesecret` into namespace `private` with this value `secret:youcantread` 

4- Show your registration into etcd call and ensure you new secret are encryted 

5- Show your previous secret myfirstsecret. Surprise !!!!!!

<details>
<summary>Explanations</summary>

Your encryption setup is only apply for new secrets. This is the reason why in initial encryption file we keep the possibilty to read unencrypted kind. To be really secure, we have to regenerate all secrets    
</details>

<br>

6- Regenerate all secrets 

`kubectl get secrets --all-namespaces -o json | kubectl replace -f - `


7- Ensure your previous secret are more secure now ! 