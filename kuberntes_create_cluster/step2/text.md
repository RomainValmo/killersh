
1 -in namespace `private`, you have to create a secret named `myfirstsecret`

You must set manually this value  `secret:123456`


<details>
<summary>Tips</summary>

To create secret manually and fix key:secret ,
you have tu use
`kubectl -n namespace create secret generic name --from-literal key=value `

</details>